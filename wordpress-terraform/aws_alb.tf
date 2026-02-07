###############################
#            ALB              #
###############################
resource "aws_lb" "web_alb" {
  name               = "amir-wp-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name  = "amir-wp-alb"
    Owner = "amir"
  }
}


resource "aws_lb_target_group" "web_tg" {
  name     = "amir-wp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.AppVPC.id

  health_check {
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name  = "amir-wp-tg"
    Owner = "amir"
  }
}



resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name  = "amir-wp-listener-80"
    Owner = "amir"
  }
}

resource "aws_lb_listener" "https_443" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

  tags = {
    Name  = "amir-wp-listener-443"
    Owner = "amir"
  }
}


resource "aws_lb_target_group_attachment" "web_attach" {
  for_each = aws_instance.web

  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = each.value.id
  port             = 80
}
