resource "aws_autoscaling_group" "app1_asg" {

  name = "${var.component}-app1-asg"
  desired_capacity   = 2
  max_size           = 10
  min_size           = 2

  vpc_zone_identifier  = aws_subnet.private_subnet.*.id
 health_check_type = "EC2"
 target_group_arns = [aws_lb_target_group.app1.arn]

  launch_template {
    id      = aws_launch_template.app1_lauch_template.id
    version = aws_launch_template.app1_lauch_template.latest_version
  }

  initial_lifecycle_hook {
    default_result = "CONTINUE"
    heartbeat_timeout = 60 
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    name = "ExampleStartupLifeCycleHook"
    notification_metadata = jsonencode(
            {
                hello = "world"
            }
        )
  }
  initial_lifecycle_hook {
    default_result = "CONTINUE"
    heartbeat_timeout = 180 
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    name = "ExampleTerminationLifeCycleHook"
    notification_metadata = jsonencode(
            {
                hello = "world"
            }
        )
  }

  tag {
    key                 = "component"
    value               = "${var.component}"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling" # UPDATE 

     triggers = ["tag", "desired_capacity", "max_size"]

    preferences {
      min_healthy_percentage = 50
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

### ############################## 
# CREATING LAUNCH_TEMPLATE
##############################
resource "aws_launch_template" "app1_lauch_template" {

  name = "${var.component}-app1-launch-template"
  description = "This is a template for the application app1"
  vpc_security_group_ids = [aws_security_group.app_static_sg.id]  
  image_id = data.aws_ami.ami.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      delete_on_termination = true 
      volume_type = "gp2"
    }
  }

user_data = filebase64("${path.module}/templates/app1.sh")

  credit_specification {
    cpu_credits = "standard"
  }
  ebs_optimized = true
  instance_market_options {
    market_type = "spot"
  }
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "${var.component}-app1-launch-template"
    }
}
}

################################################################
# CREATING AWS_AUTO_POLICY
##############################################################

resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
 name                   = "avg-cpu-policy-greater-than-xx"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name =  aws_autoscaling_group.app1_asg.id  
   estimated_instance_warmup = 180 

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }  
}

resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_yy" {
  name                   = "alb-target-requests-greater-than-yy"
  policy_type = "TargetTrackingScaling" 
  autoscaling_group_name = aws_autoscaling_group.app1_asg.id
   estimated_instance_warmup = 120 

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type ="ALBRequestCountPerTarget"
      resource_label = "${aws_lb.this.arn_suffix}/${aws_lb_target_group.app1.arn_suffix}"
    }

    target_value = 10.0
  }
}

################################################################################
# CREATING ASG NOTIFICATION
################################################################################

resource "random_pet" "this" {
}

resource "aws_sns_topic" "myasg_sns_topic" {
  name = "${var.component}-${random_pet.this.id}"
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
  protocol  = "email"
  endpoint  = "vedievbiere@gmail.com" 
}

## Create Autoscaling Notification Resource
resource "aws_autoscaling_notification" "myasg_notifications" {
  group_names = [ aws_autoscaling_group.app1_asg.id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.myasg_sns_topic.arn 
}

################################################################################
# CREATING ASG autoscaling schedule 
################################################################################

resource "aws_autoscaling_schedule" "increase_capacity_9am" {
  scheduled_action_name  = "increase-capacity-9am"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 8
  start_time             = "2030-12-11T09:00:00Z"
  recurrence             = "00 09 * * *"
  autoscaling_group_name = aws_autoscaling_group.app1_asg.id
}

resource "aws_autoscaling_schedule" "decrease_capacity_9pm" {
  scheduled_action_name  = "decrease-capacity-9pm"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  start_time             = "2030-12-11T21:00:00Z"
  recurrence             = "00 21 * * *"
  autoscaling_group_name = aws_autoscaling_group.app1_asg.id
}

################################################################################
# CREATING CLOUD WATCH ALARMS 
################################################################################
resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "${var.component}-high-cpu"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app1_asg.name
}

resource "aws_cloudwatch_metric_alarm" "appi_asg_cpu_alarm" {
  alarm_name          = "${var.component}-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold" # 
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80" 

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app1_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization and Triggers the ASG scaling policy to scale-out if CPU is above %80"
  alarm_actions     =[ 
    aws_autoscaling_policy.high_cpu.arn,
    aws_sns_topic.myasg_sns_topic.arn
  ]
}
