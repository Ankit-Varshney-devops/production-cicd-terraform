resource "aws_lb" "test" {
  name               = "${var.app_name}-lb-prod"
  internal           = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb_web_sg.id ]
  subnets            = [ aws_subnet.subnet_public-A.id,aws_subnet.subnet_public-B.id ]

  enable_deletion_protection = false
  
  tags = {
    Environment = "production"
  }
}

