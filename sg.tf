resource "aws_security_group" "asg_web_sg" {
  description = "Traffic Rules"
  name = "${var.app_name}-${var.env_type}_asg_web_sg"
  vpc_id      = aws_vpc.default.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["180.151.15.236/32", "180.151.78.218/32", "180.151.78.220/32", "180.151.78.222/32", "111.93.242.34/32", "182.74.4.226/32", "35.169.106.126/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-${var.env_type}_sg_group"
  }
}

resource "aws_security_group" "alb_web_sg" {
  description = "Traffic Rules"
  name = "${var.app_name}-${var.env_type}_alb_sg"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-${var.env_type}_sg_group"
  }
}

resource "aws_security_group" "rds_sg" {
  
  depends_on = [aws_security_group.alb_web_sg]
  vpc_id      = aws_vpc.default.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-${var.env_type}_rds_sg"
  }
}
