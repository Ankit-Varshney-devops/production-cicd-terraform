data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "${var.app_name}-lc"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.asg_web_sg.id]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_cd_instance_profile.name

  user_data = templatefile("node.sh", { region = var.aws_region, user = var.user, db_name = var.db_name, pass = var.passwd, host = aws_db_instance.postgresql.address, master_pass = var.db_password})

  root_block_device {
     volume_type = "gp2"
     volume_size = 30
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  name                 = "${var.app_name}-asg"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  
  vpc_zone_identifier  = [aws_subnet.subnet_public-A.id,aws_subnet.subnet_public-B.id]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.app_name}-asg-instance"
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_policy" "example" {
  name        = "${var.app_name}-asg-policy"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.bar.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }

}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.bar.id
  alb_target_group_arn   = aws_alb_target_group.target-group-1.arn
}