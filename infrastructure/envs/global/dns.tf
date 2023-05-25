// a route 53 zone is a DNS zone inside AWS, create one for our domain
resource "aws_route53_zone" "root" {
  name = var.domain_name
}

# place it at the Namecheap DNS for this domain
resource "namecheap_domain_dns" "main" {
  domain = var.domain_name

  nameservers = aws_route53_zone.root.name_servers
}

// create a certificate
resource "aws_acm_certificate" "root" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


// create validation records for the certificate
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.root.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 5
  type            = each.value.type
  zone_id         = aws_route53_zone.root.zone_id
}

// this resource checks whether the validation has happened
resource "aws_acm_certificate_validation" "root" {
  certificate_arn         = aws_acm_certificate.root.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

// point the domain at the API
resource "aws_route53_record" "api_gateway" {
  name    = var.domain_name
  type    = "A"
  zone_id = aws_route53_zone.root.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].hosted_zone_id
  }
}