resource "aws_acm_certificate" "Pepperoni_Certificate" {
  domain_name       = "thelondonchesssystem.com"
  validation_method = "DNS"
}

resource "aws_route53_zone" "primary" {
  name = "thelondonchesssystem.com"
}

resource "aws_route53_record" "validation_records" {
  depends_on      = [aws_acm_certificate.Pepperoni_Certificate]
  allow_overwrite = true
  name   = "www"
  records = "thelondonchesssystem.com"
  type   = "CNAME"
  zone_id = aws_route53_zone.primary.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "Pepperoni_Certificate_Validation" {
  certificate_arn = aws_acm_certificate.Pepperoni_Certificate.arn
  validation_record_fqdns = [ aws_route53_record.validation_records.fqdn]
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
