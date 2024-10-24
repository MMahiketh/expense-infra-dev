module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.resource_name

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.instance_type
  allocated_storage = 5

  db_name                     = "transactions"
  manage_master_user_password = false
  username                    = "root"
  password                    = "ExpenseApp1"
  port                        = "3306"

  skip_final_snapshot = true

  vpc_security_group_ids = [local.mysql_sg_id]

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-${var.instance}" },
    var.rds_tags
  )

  # DB subnet group
  db_subnet_group_name = local.db_subnet_group_name

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

#Create route 53 record for rds ( mysql-dev.mahdo.site )
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.domain_name

  records = [
    {
      name            = "${var.instance}-${var.environment}" #mysql-dev.mahdo.site
      type            = "CNAME"
      ttl             = 360
      allow_overwrite = true
      records         = [module.db.db_instance_address]
    }
  ]
}