
##################### ALB Security Group #####################

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.dev_vpc.id
}

resource "aws_security_group_rule" "alb_http_sg_inbound_rule_1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_https_sg_inbound_rule_2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}


##################### SSH Security Group #####################

resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "SSH Security Group"
  vpc_id      = aws_vpc.dev_vpc.id

}

resource "aws_security_group_rule" "ssh_sg_inbound_rule_1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh_sg.id
}

##################### Web Server Security Group #####################

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Webserver Security Group"
  vpc_id      = aws_vpc.dev_vpc.id

}

resource "aws_security_group_rule" "webserver_sg_inbound_rule_1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "webserver_sg_inbound_rule_2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "webserver_sg_inbound_rule_3" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.ssh_sg.id
  security_group_id = aws_security_group.webserver_sg.id
}


##################### EFS Security Group #####################

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "EFS Security Group"
  vpc_id      = aws_vpc.dev_vpc.id

}

resource "aws_security_group_rule" "efs_sg_inbound_rule_1" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id = aws_security_group.efs_sg.id
}

resource "aws_security_group_rule" "efs_sg_inbound_rule_2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.ssh_sg.id
  security_group_id = aws_security_group.efs_sg.id
}

resource "aws_security_group_rule" "efs_sg_inbound_rule_3" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  source_security_group_id = aws_security_group.efs_sg.id
  security_group_id = aws_security_group.efs_sg.id
}


##################### ACM #####################

resource "aws_acm_certificate" "Pepperoni_Certificate" {
  domain_name       = "thelondonchesssystem.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "Pepperoni_Certificate_Validation" {
  certificate_arn = aws_acm_certificate.Pepperoni_Certificate.arn
}
