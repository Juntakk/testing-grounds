# Application Load Balancer and related resources creation script
# 6 - Application Load Balancer
data "aws_lb" "triage_ec2_alb" {
  #   provider = aws

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb"
  }

}

data "aws_lb_listener" "triage_ec2_lb_https_listener" {
  load_balancer_arn = data.aws_lb.triage_ec2_alb.arn
  port              = "443"
}

# 7 - Target Group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# 7A - API
resource "aws_lb_target_group" "triage_ec2_api_tg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-api-tg"
  target_type = "instance"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.triage_ec2_vpc.id

  health_check {
    path = "/docs"
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-api-tg"
  }
}

resource "aws_lb_target_group_attachment" "triage_ec2_api_tg_link" {
  target_group_arn = aws_lb_target_group.triage_ec2_api_tg.arn
  target_id        = aws_instance.triage_web.id
  port             = 8000
}

# 7B - Compute
resource "aws_lb_target_group" "triage_ec2_compute_tg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-compute-tg"
  target_type = "instance"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = data.aws_vpc.triage_ec2_vpc.id

  health_check {
    path = "/health/"
    # port = 443
    protocol = "HTTPS"
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-compute-tg"
  }
}

resource "aws_lb_target_group_attachment" "triage_ec2_compute_tg_link" {
  target_group_arn = aws_lb_target_group.triage_ec2_compute_tg.arn
  target_id        = aws_instance.triage_compute.id
  port             = 443
}


# 7D - Apache
resource "aws_lb_target_group" "triage_ec2_web_tg" {
  name        = "${lower(var.agency_secret)}-triage-ec2-web-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.triage_ec2_vpc.id

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-web-tg"
  }
}

resource "aws_lb_target_group_attachment" "triage_ec2_web_tg_link" {
  target_group_arn = aws_lb_target_group.triage_ec2_web_tg.arn
  target_id        = aws_instance.triage_web.id
  port             = 80
}

# 9 - Load-Balancer Listener rule - to link with target groups
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# 9A - /api/v1/ --> fastapi - commented since handled by apache reverse proxy configuration
/*
resource "aws_lb_listener_rule" "triage_ec2_lb_api_rule" {
  listener_arn = data.aws_lb_listener.triage_ec2_lb_https_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.triage_ec2_api_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1", "/api/v1/*"]
    }
  }

  condition {
    host_header {
      values = ["${var.agency_name}.${var.top_domain}"]
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-api-rule"
  }
}
*/

#9B - /intransit
resource "aws_lb_listener_rule" "triage_ec2_lb_compute_rule" {
  listener_arn = data.aws_lb_listener.triage_ec2_lb_https_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.triage_ec2_compute_tg.arn
  }

  condition {
    path_pattern {
      values = ["/intransit", "/intransit/*"]
    }
  }

  condition {
    host_header {
      values = ["${var.subdomain}.${var.top_domain}"]
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-compute-rule"
  }
}

# 9C - / --> Apache
resource "aws_lb_listener_rule" "triage_ec2_lb_http_rule" {
  listener_arn = data.aws_lb_listener.triage_ec2_lb_https_listener.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.triage_ec2_web_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = ["${var.subdomain}.${var.top_domain}"]
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-http-rule"
  }
}


# compute subdomain
/*
resource "aws_route53_record" "triage_ec2_compute_alias_record" {
  zone_id = data.aws_route53_zone.triage_ec2_zone.id
  name    = "compute.${var.agency_name}.${var.top_domain}"
  type    = "A"
  ttl     = 600
  records = [aws_instance.triage_compute.public_ip]
}

resource "aws_network_acl_rule" "triage_ec2_compute_pub_nacl_rule" {
  network_acl_id = data.aws_network_acls.triage_ec2_pub_nacl.ids[0]
  rule_number    = 600
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "172.16.2.50/24"
  from_port      = 22
  to_port        = 22
}
*/
