module "main" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = local.ami_id
  name = "${local.resource_name}-${var.instance}"

  instance_type          = var.instance_type
  vpc_security_group_ids = [local.sg_id]
  subnet_id              = local.subnet_id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-${var.instance}" },
    var.backend_tags
  )
}

resource "null_resource" "configuration" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.main.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host     = module.main.private_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "${var.instance}.sh"
    destination = "/tmp/${var.instance}.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/${var.instance}.sh",
      "sudo sh /tmp/${var.instance}.sh ${var.instance} ${var.environment} ${var.mysql_pass}"
    ]
  }
}

resource "aws_ec2_instance_state" "main" {
  instance_id = module.main.id
  state       = "stopped"

  depends_on = [null_resource.configuration]
}

resource "aws_ami_from_instance" "main" {
  name               = "${local.resource_name}-${var.instance}"
  source_instance_id = module.main.id

  depends_on = [aws_ec2_instance_state.main]
}

resource "null_resource" "delete_instance" {

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.main.id}"
  }

  depends_on = [aws_ami_from_instance.main]
}
