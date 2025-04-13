# Application Load Balancer and related resources creation script
# 01 - find the Application Load Balancer
data "aws_lb" "triage_ec2_alb" {
  name = "${lower(var.agency_secret)}-triage-ec2-alb"
}

data "aws_lb_listener" "triage_ec2_lb_https_listener" {
  load_balancer_arn = data.aws_lb.triage_ec2_alb.arn
  port              = "443"
}

# 02 - Keycloak target group
resource "aws_lb_target_group" "triage_ec2_keycloak_tg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-keycloak-tg"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.triage_ec2_vpc.id

  health_check {
    path = "/auth/realms/triage/.well-known/openid-configuration"
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-keycloak-tg"
  }
}

resource "aws_lb_target_group_attachment" "triage_ec2_kc_tg_link" {
  target_group_arn = aws_lb_target_group.triage_ec2_keycloak_tg.arn
  target_id        = aws_instance.triage_keycloak.id
  port             = 8080

}


# 03 - Load-Balancer Listener rule - to link with target groups
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule

# 03A /auth/ --> keycloak
resource "aws_lb_listener_rule" "triage_ec2_lb_keycloak_rule" {
  listener_arn = data.aws_lb_listener.triage_ec2_lb_https_listener.arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.triage_ec2_keycloak_tg.arn
  }

  condition {
    path_pattern {
      values = ["/auth", "/auth/*"]
    }
  }

  condition {
    host_header {
      values = ["${var.subdomain}.${var.top_domain}"]
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-kc-rule"
  }
}

# 03B - subdomain for keycloak
resource "aws_lb_listener_rule" "triage_ec2_lb_kcloop_rule" {
  listener_arn = data.aws_lb_listener.triage_ec2_lb_https_listener.arn
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.triage_ec2_keycloak_tg.arn
  }

  condition {
    path_pattern {
      values = ["/auth", "/auth/*"]
    }
  }

  condition {
    host_header {
      values = ["keycloak.${var.subdomain}.${var.top_domain}"]
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-kcloop-rule"
  }
}
