###############################
#        EC2 INSTANCE        #
###############################
resource "aws_instance" "web" {
  for_each = local.web_servers

  ami                    = var.wp_ami
  instance_type          = var.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.app_profile.name
  associate_public_ip_address = false
  user_data              = file("./scripts/install_ssm_agent.sh")

  tags = {
    Name  = each.value.name
    Owner = "amir"
  }
}

resource "aws_instance" "mysql" {
  ami                  = var.db_ami
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  iam_instance_profile = aws_iam_instance_profile.mysql_profile.name
  associate_public_ip_address = false
  user_data = file("./scripts/install_ssm_agent.sh")

  tags = {
    Name  = "amir-wp-mysql"
    Owner = "amir"
  }
}
