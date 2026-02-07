locals {
  web_servers = {
    web1 = {
      subnet_id = aws_subnet.private_subnet_1.id
      name      = "amir-wp-webserver-1"
    }
    web2 = {
      subnet_id = aws_subnet.private_subnet_2.id
      name      = "amir-wp-webserver-2"
    }
  }
}

locals {
  public_subnet_ids = {
    pub1 = aws_subnet.public_subnet_1.id
    pub2 = aws_subnet.public_subnet_2.id
  }

  private_subnet_ids = {
    priv1 = aws_subnet.private_subnet_1.id
    priv2 = aws_subnet.private_subnet_2.id
  }
}
