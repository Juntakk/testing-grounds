# Application Load Balancer and related resources creation script
# 6 - Application Load Balancer
resource "aws_lb" "triage_ec2_alb" {
  name               = "${lower(var.agency_secret)}-triage-ec2-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.triage_alb_sg.id]
  subnets         = [aws_subnet.triage_ec2_subnet_pub_a.id, aws_subnet.triage_ec2_subnet_pub_b.id]

  #  enable_deletion_protection = true -- good question ?
  enable_deletion_protection = false
  enable_http2               = true

  # Determines how the load balancer modifies the X-Forwarded-For header before 
  # sending the request to the target - set up to append (which is the default value)
  xff_header_processing_mode = "append"

  ip_address_type = "ipv4"

  /*
  access_logs {
    bucket  = aws_s3_bucket.triage_ec2_s3_bucket.id
    prefix  = "${var.agency_secret}-alb-logs"
    enabled = true
  }
*/

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-alb"
  }
}

# 8 - Load-Balancer Listener - to link with the certificate
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "triage_ec2_lb_https_listener" {
  load_balancer_arn = aws_lb.triage_ec2_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  #  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.triage_ec2_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-https"
  }
}

resource "aws_lb_listener" "triage_ec2_lb_http_listener" {
  load_balancer_arn = aws_lb.triage_ec2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      # HTTPS://#{host}:443/#{path}?#{query}
    }
  }

  tags = {
    Name = "${lower(var.agency_secret)}-triage-ec2-lb-http"
  }
}


# 10 - Create Route53 records for pointing to the load balancer
resource "aws_route53_record" "triage_ec2_alias_record" {
  zone_id = aws_route53_zone.triage_ec2_zone.id
  name    = "${var.subdomain}.${var.top_domain}"
  type    = "A"

  alias {
    name                   = "dualstack.${aws_lb.triage_ec2_alb.dns_name}"
    zone_id                = aws_lb.triage_ec2_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "triage_ec2_kcloop_alias_record" {
  zone_id = aws_route53_zone.triage_ec2_zone.id
  name    = "keycloak.${var.subdomain}.${var.top_domain}"
  type    = "A"

  alias {
    name                   = "dualstack.${aws_lb.triage_ec2_alb.dns_name}"
    zone_id                = aws_lb.triage_ec2_alb.zone_id
    evaluate_target_health = true
  }
}

# 11 - attach subdomain clearcase certificate to lo-clearcase-lb
resource "aws_lb_listener_certificate" "triage_ec2_lo_clearcase_https_lb_cert" {
  provider = aws.lo-clearcase-lb

  listener_arn    = data.aws_lb_listener.lo_clearcase_lb_https_listener.arn
  certificate_arn = aws_acm_certificate.triage_ec2_clearcase_cert.arn

  depends_on = [aws_acm_certificate_validation.triage_ec2_cert_clearcase_validation]
}