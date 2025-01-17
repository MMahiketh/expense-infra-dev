module "main" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                    = local.ami_id
  name                   = "${local.resource_name}-${var.instance}"
  instance_type          = var.instance_type
  vpc_security_group_ids = [local.sg_id]
  subnet_id              = local.subnet_ids[0]

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

  triggers = {
    instance_id = module.main.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.main.id}"
  }

  depends_on = [aws_ami_from_instance.main]
}

resource "aws_lb_target_group" "main" {
  name     = "${local.resource_name}-${var.instance}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 90
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
  }
}

resource "aws_launch_template" "main" {
  name          = "${local.resource_name}-${var.instance}"
  image_id      = aws_ami_from_instance.main.id
  instance_type = var.instance_type

  instance_initiated_shutdown_behavior = "terminate"
  update_default_version               = true
  vpc_security_group_ids               = [local.sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      { Name = "${local.resource_name}-${var.instance}" },
      { From_Launch_Template = "True" },
      var.backend_tags
    )
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-${var.instance}" },
  )
}

resource "aws_autoscaling_group" "main" {
  name                      = "${local.resource_name}-${var.instance}"
  max_size                  = 10
  min_size                  = 2
  health_check_grace_period = 90
  health_check_type         = "ELB"
  desired_capacity          = 2
  target_group_arns         = [aws_lb_target_group.main.arn]
  vpc_zone_identifier       = local.subnet_ids

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  timeouts {
    delete = "10m"
  }

  tag {
    key                 = "Name"
    value               = "${local.resource_name}-${var.instance}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "example" {
  name                   = "${local.resource_name}-${var.instance}"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.main.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

resource "aws_alb_listener_rule" "main" {
  listener_arn = local.alb_listner_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = ["${var.instance}.app-${var.environment}.${var.domain}"]
    }
  }

}
