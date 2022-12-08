################################################################################
# CREATING AN EC2 INSTANCE USING COUNT 
################################################################################

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

resource "aws_autoscaling_group" "this" {
    health_check_type         = "EC2"
    max_size                  = 10
    desired_capacity          = 2 
    min_size                  = 2
    name                      = "${var.component}-asg-app1"
    launch_configuration = aws_launch_configuration.this.name
    service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn
  
    target_group_arns         =  [aws_lb_target_group.app1.arn]
    vpc_zone_identifier       =  aws_subnet.private_subnet.*.id

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

resource "aws_launch_configuration" "this" {
    ebs_optimized               = true
    enable_monitoring           = true
    iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
    image_id                    = data.aws_ami.ami.id
    instance_type               = var.instance_type
    name_prefix                 = "${var.component}-mylc"
    security_groups             = [aws_security_group.app_static_sg.id]
    spot_price                  = "0.014"
    user_data                   = file("${path.module}/templates/app1.sh")

    ebs_block_device {
        delete_on_termination = true
        device_name           = "/dev/xvdz"
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 32
        http_tokens                 = "optional"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 15
        volume_type           = "gp2"
    }
 lifecycle {
    create_before_destroy = true
  }
}
