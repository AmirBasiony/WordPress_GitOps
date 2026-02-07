# Generate the Ansible inventory file dynamically using a template
resource "local_file" "ansible_inventory" {
    # Path to the generated inventory file
    filename = "${path.module}/../wordpress-ansible/inventory.ini"

    # Populate the content of the inventory file using a template
    content = templatefile("${path.module}/inventory.tmpl", {
        web_instance_ids  = { for k, inst in aws_instance.web : k => inst.id } # Map of web instance IDs
        mysql_instance_id = aws_instance.mysql.id                              # MySQL instance ID
        ssm_bucket        = aws_s3_bucket.ansible_ssm_bucket.bucket           # S3 bucket for SSM
        aws_region        = var.aws_region                                    # AWS region
    })
}
# Generate the Ansible Terraform variables file dynamically
resource "local_file" "ansible_all_vars" {
  filename = "${path.module}/../wordpress-ansible/group_vars/all.yml"

  content = templatefile("${path.module}/all_ansible_vars.tmpl", {
    vpc_cidr         = aws_vpc.AppVPC.cidr_block
    efs_dns_name     = aws_efs_file_system.app_efs.dns_name
    mysql_private_ip = aws_instance.mysql.private_ip
  })
}


# Define a null resource to run the Ansible playbook
resource "null_resource" "run_ansible" {
  depends_on = [
    aws_instance.mysql,
    aws_instance.web,
    aws_lb_target_group_attachment.web_attach,
    local_file.ansible_inventory,
    local_file.ansible_all_vars
  ]

  triggers = {
    inventory_sha = sha1(local_file.ansible_inventory.content)
    vars_sha      = sha1(local_file.ansible_all_vars.content)
    tg_arn        = aws_lb_target_group.web_tg.arn
  }

  provisioner "local-exec" {
    working_dir = path.module

    command = <<EOT
        scripts/run_ansible_via_ssm.sh \
        ${var.aws_region} \
        ${aws_lb_target_group.web_tg.arn} \
        ${aws_instance.mysql.id} \
        "${join(" ", [for _, v in aws_instance.web : v.id])}" \
        "${path.module}/../wordpress-ansible"
    EOT
  }
}

    # # Use a local-exec provisioner to execute the Ansible playbook
    # provisioner "local-exec" {
    #     # Set the working directory to the Ansible project directory
    #     working_dir = "${path.module}/../wordpress-ansible"

    #     # Command to execute the Ansible playbook and verify connectivity
    #     command = <<EOT
    #         ansible-playbook wordpress.yml
    #         echo "Ansible playbook executed successfully."
    #         ansible -m ping all
    #     EOT
    # }
# }
