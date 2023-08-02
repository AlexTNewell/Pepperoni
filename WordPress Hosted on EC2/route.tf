resource "aws_acm_certificate" "Pepperoni_Certificate" {
  domain_name       = "thelondonchesssystem.com"
  validation_method = "DNS"
}

resource "aws_route53_zone" "primary" {
  name = "thelondonchesssystem.com"
}

resource "aws_route53_record" "validation_records" {
  allow_overwrite = true
  name   = tolist(aws_acm_certificate.Pepperoni_Certificate.domain_validation_options)[0].resource_record_name
  record = [ tolist(aws_acm_certificate.Pepperoni_Certificate.domain_validation_options)[0].resource_record_value ]
  type   = tolist(aws_acm_certificate.Pepperoni_Certificate.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.primary.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "Pepperoni_Certificate_Validation" {
  certificate_arn = aws_acm_certificate.Pepperoni_Certificate.arn
  validation_record_fqdns = [ aws_route53_record.validation_records.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.thelondonchesssystem.com"
  type    = "A"

  alias {
      name                   = aws_lb.app_alb.dns_name
      zone_id                = aws_lb.app_alb.zone_id
      evaluate_target_health = false
    }
}
