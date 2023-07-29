##################### EFS #####################

resource "aws_efs_file_system" "dev_efs" {
  creation_token = "my_efs"
}

##################### EFS Mount Targets #####################

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.dev_efs.id
  subnet_id      = aws_subnet.pri_db_az_1.id
  security_groups = aws_security_group.efs_sg.id
}

resource "aws_efs_mount_target" "bravo" {
  file_system_id = aws_efs_file_system.dev_efs.id
  subnet_id      = aws_subnet.pri_db_az_2.id
  security_groups = aws_security_group.efs_sg.id
}
