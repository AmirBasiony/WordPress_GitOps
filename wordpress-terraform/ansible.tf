# Generate the Ansible inventory file dynamically using a template
resource "local_file" "ansible_inventory" {
  # Path to the generated inventory file
  filename = "${var.ansible_repo_path}/inventory.ini"

  # Populate the content of the inventory file using a template
  content = templatefile("${path.module}/inventory.tmpl", {
    web_instance_ids  = module.compute.web_instance_ids  # Map of web instance IDs
    mysql_instance_id = module.compute.mysql_instance_id # MySQL instance ID
    ssm_bucket        = module.storage.ssm_bucket_name   # S3 bucket for SSM
    aws_region        = var.aws_region                   # AWS region
  })
}


# Generate the Ansible Terraform variables file dynamically
resource "local_file" "ansible_all_vars" {
  filename = "${var.ansible_repo_path}/group_vars/all.yml"

  content = templatefile("${path.module}/all_ansible_vars.tmpl", {
    vpc_cidr         = module.network.vpc_cidr
    efs_dns_name     = module.storage.efs_dns_name
    mysql_private_ip = module.compute.mysql_private_ip
    fqdn             = module.edge.fqdn
  })
}


resource "null_resource" "run_ansible" {
  depends_on = [
    local_file.ansible_inventory,
    local_file.ansible_all_vars,
    module.compute,
    module.alb,
    module.storage
  ]

  triggers = {
    inventory_sha = sha1(local_file.ansible_inventory.content)
    vars_sha      = sha1(local_file.ansible_all_vars.content)
    tg_arn        = module.alb.target_group_arn
  }
  
  provisioner "local-exec" {
    working_dir = path.module
    command     = <<EOT
      scripts/run_ansible_via_ssm.sh \
      ${var.aws_region} \
      ${module.alb.target_group_arn} \
      ${module.compute.mysql_instance_id} \
      "${join(" ", values(module.compute.web_instance_ids))}" \
      "${var.ansible_repo_path}"
    EOT
  }
}