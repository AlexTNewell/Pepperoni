resource "aws_acm_certificate" "Pepperoni_Certificate" {
  domain_name       = "thelondonchesssystem.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "primary" {
  name = "thelondonchesssystem.com"
}

resource "aws_route53_record" "validation_records" {
  depends_on      = [aws_acm_certificate.Pepperoni_Certificate, aws_route53_zone.primary]
  allow_overwrite = true

  zone_id = data.aws_route53_zone.primary.zone_id
  ttl = 60

  name    = aws_acm_certificate.Pepperoni_Certificate.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.Pepperoni_Certificate.domain_validation_options.0.resource_record_type
  records = [ aws_acm_certificate.Pepperoni_Certificate.domain_validation_options.0.resource_record_value ]

}

resource "aws_acm_certificate_validation" "Pepperoni_Certificate_Validation" {
  depends_on      = [aws_acm_certificate.Pepperoni_Certificate, aws_route53_zone.primary]
  certificate_arn = aws_acm_certificate.Pepperoni_Certificate.arn
  validation_record_fqdns = aws_acm_certificate.Pepperoni_Certificate.domain_validation_options.0.resource_record_name
}

resource "aws_route53_record" "www" {
  depends_on = [aws_acm_certificate_validation.Pepperoni_Certificate_Validation]
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.thelondonchesssystem.com"
  type    = "A"

  alias {
      name                   = aws_lb.app_alb.dns_name
      zone_id                = aws_lb.app_alb.zone_id
      evaluate_target_health = false
    }
}
