resource "aws_alb_target_group" "target-group-1" {
  name = "${var.app_name}-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.default.id
  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200"  # has to be HTTP 200 or fails
  }
  deregistration_delay = 60
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target-group-1.arn
    type             = "forward"
  }
}