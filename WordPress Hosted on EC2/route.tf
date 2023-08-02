resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.thelondonchesssystem.com"
  type    = "A"

  alias {
      name                   = aws_lb.app_alb.dns_name
      zone_id                = aws_lb.app_alb.zone_id
      evaluate_target_health = true
    }
}

resource "aws_route53_zone" "primary" {
  name = "thelondonchesssystem.com"
}
