resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "Server"
  name             = "${var.app_name}-app"
}