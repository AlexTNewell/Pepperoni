##################### RDS #####################

resource "aws_db_instance" "rds_db" {
  allocated_storage    = 10
  db_name              = "rds_db"
  engine               = "mysql"
  engine_version       = "5.7"
  identifier           = "dev-rds-db"
  instance_class       = "db.t2.micro"
  username             = "beautiful_coalscuttle"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  availability_zone = var.secondary_region
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

##################### Database Subnet Groups #####################

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  description = "Database Subnet"
  subnet_ids = [aws_subnet.pri_db_az_1.id, aws_subnet.pri_db_az_2.id]

}