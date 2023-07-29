##################### ALB #####################

resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.pri_app_az_1.id, aws_subnet.pri_app_az_2.id]
  security_groups    = [aws_security_group.alb_sg.id]
  ip_address_type = "ipv4"
}

##################### ALB Listeners #####################

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.Pepperoni_Certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_target_group.arn
  }
}

##################### Target Group #####################

resource "aws_lb_target_group" "dev_target_group" {
  name        = "dev-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev_vpc.id
  target_type = "instance"
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200,301,302"
}
}

##################### Target Group Attachments #####################

resource "aws_lb_target_group_attachment" "alpha" {
  target_group_arn = aws_lb_target_group.dev_target_group.arn
  target_id        = aws_instance.app_server_az1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "bravo" {
  target_group_arn = aws_lb_target_group.dev_target_group.arn
  target_id        = aws_instance.app_server_az2.id
  port             = 80
}
