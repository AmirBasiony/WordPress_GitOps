resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"

  subnets         = var.public_subnet_ids
  security_groups = [var.alb_sg_id]

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-alb"
    Owner = var.owner
  })
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name_prefix}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = var.healthcheck_path
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    interval            = var.healthcheck_interval
    matcher             = "200-399"
  }

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-tg"
    Owner = var.owner
  })
}

resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.this.arn
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
}

resource "aws_lb_listener" "https_443" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  for_each = {
    "web-1" = var.web_instance_ids[0]
    "web-2" = var.web_instance_ids[1]
  }
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
  port             = var.target_port
}
