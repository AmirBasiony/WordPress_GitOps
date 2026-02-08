resource "aws_instance" "web" {
  for_each = var.web_servers

  ami                         = var.wp_ami
  instance_type               = var.instance_type
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = [var.web_sg_id]
  iam_instance_profile        = var.app_instance_profile_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = file("${path.root}/${var.user_data_path}")

  depends_on = [
    var.nat_gateway_id 
  ]  
  tags = merge(var.tags, {
    Name  = each.value.name
    Owner = var.owner
  })
}

resource "aws_instance" "mysql" {
  ami                         = var.db_ami
  instance_type               = var.instance_type
  subnet_id                   = var.mysql_subnet_id
  vpc_security_group_ids      = [var.mysql_sg_id]
  iam_instance_profile        = var.mysql_instance_profile_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = file("${path.root}/${var.user_data_path}")

  depends_on = [
    var.nat_gateway_id 
  ]

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-mysql"
    Owner = var.owner
  })
}
