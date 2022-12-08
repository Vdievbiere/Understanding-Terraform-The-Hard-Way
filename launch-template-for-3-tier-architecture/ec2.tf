data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = var.component

#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
}
################# CREATING ASG##############
resource "aws_autoscaling_group" "this" {
    depends_on = [aws_db_instance.registration_app_db]

    health_check_type         = "EC2"
    max_size                  = 10
    desired_capacity          = 2
    min_size                  = 2

    name                      = "${var.component}-myasg1"
    # service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.name
  
    target_group_arns         =  [aws_lb_target_group.registration_app.arn]
    vpc_zone_identifier       =  aws_subnet.private_subnet.*.id

    launch_template {
    id = aws_launch_template.registration_app.id 
    version = aws_launch_template.registration_app.latest_version
  }
    initial_lifecycle_hook {
        default_result        = "CONTINUE"
        heartbeat_timeout     = 180
        lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
        name                  = "ExampleTerminationLifeCycleHook"
        notification_metadata = jsonencode(
            {
                goodbye = "world"
            }
        )
    }
    initial_lifecycle_hook {
        default_result        = "CONTINUE"
        heartbeat_timeout     = 60
        lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
        name                  = "ExampleStartupLifeCycleHook"
        notification_metadata = jsonencode(
            {
                hello = "world"
            }
        )
    }
    instance_refresh {
        strategy = "Rolling"
        triggers = [
            "desired_capacity",
            "tag", "max_size",
        ]

        preferences {
            min_healthy_percentage = 50
            skip_matching          = false
        }
    }

  timeouts {}
  tag {
    key                 = "component"
    value               = "${var.component}"
    propagate_at_launch = true
  }
  tag {
    key                 = "vpc-tier"
    value               = "VPC-APP"
    propagate_at_launch = false
  }
lifecycle {
  create_before_destroy = true
}
}

##################################################
#CREATING LAUNCH TEMPLATE FOR REGISTRATION APP 
########################################################
resource "aws_launch_template" "registration_app" {
  depends_on = [aws_db_instance.registration_app_db]
  name = format("%s-%s", var.component, "registration-app-lt")
  description = "This  Launch template hold configuration for registration app"
  image_id = data.aws_ami.ami.id
  instance_type = var.instance_type
  iam_instance_profile  { 
    name = aws_iam_instance_profile.instance_profile.name
   }
  vpc_security_group_ids =[aws_security_group.registration-app-sg.id]

  user_data = base64encode(templatefile("${path.root}/templates/registration_app.tmpl",
    {
      hostname    = aws_db_instance.registration_app_db.address 
      db_port     = var.port
      db_name     = var.db_name
      db_username = var.username
      db_password = random_password.password.result
    }
  ))

  ebs_optimized = true 

  update_default_version = true 
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20 
      delete_on_termination = true
      volume_type = "gp2" 
    }
   }
  monitoring {
    enabled = true
  }   
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = format("%s-%s", var.component, "registration-app-lt")
    }
  }  
  lifecycle {
  create_before_destroy = true
}
}
