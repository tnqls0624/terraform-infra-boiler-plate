module "iapi_vpc" {
  source = "../../../modules/vpc"

  project = {
    name = var.project_name
    env  = var.env
  }

  vpc_config = {
    cidr_block       = var.cidr_block
    public_subnet_a  = var.public_subnet_a
    public_subnet_b  = var.public_subnet_b
    private_subnet_a = var.private_subnet_a
    private_subnet_b = var.private_subnet_b
  }

  aws_config = {
    account_id = var.account_id
    region     = var.region
    region_a   = var.region_a
    region_b   = var.region_b
  }
}

module "iapi_alb" {
  source     = "../../../modules/alb"
  depends_on = [module.iapi_vpc]

  projects = var.projects

  name = var.project_name
  env  = var.env

  aws_config = {
    account_id = var.account_id
    region     = var.region
  }

  vpc = {
    id         = module.iapi_vpc.vpc.id
    subnet_ids = concat(
      [for subnet in module.iapi_vpc.subnet.public : subnet.id],
    )
  }

  route53 = {
    hosted_zone_name = var.hosted_zone_name
  }

  container = {
    port = var.container_port
  }
}

module "iapi_route53" {
  source = "../../../modules/route53"

  projects = var.projects
  env      = var.env

  aws_config = {
    account_id = var.account_id
    region     = var.region
  }

  vpc = {
    id = module.iapi_vpc.vpc.id
  }

  route53 = {
    name = var.hosted_zone_name
  }

  alb = module.iapi_alb.alb
}

module "iapi_ecr" {
  for_each = var.projects
  source   = "../../../modules/ecr"

  name     = var.project_name
  sub_name = each.value.sub_name
  env      = var.env
}

module "iapi_service_discovery" {
  source = "../../../modules/service_discovery"
  name   = var.project_name
  env    = var.env
}

module "iapi_iam" {
  source = "../../../modules/iam"
  name   = var.project_name
  env    = var.env

  aws_config = {
    account_id = var.account_id
    region     = var.region
  }
}

module "iapi_security_group" {
  source    = "../../../modules/security_group"
  name      = var.project_name
  env       = var.env
  container = {
    port = var.container_port
  }
  vpc = {
    id = module.iapi_vpc.vpc.id
  }
}

module "iapi_ecs" {
  source     = "../../../modules/ecs"
  depends_on = [
    module.iapi_vpc, module.iapi_alb, module.iapi_ecr, module.iapi_service_discovery, module.iapi_iam,
    module.iapi_security_group
  ]
  for_each = var.projects

  name                   = var.project_name
  env                    = var.env
  namespace_id           = module.iapi_service_discovery.http_namespace_id
  ecs_task_execution_arn = module.iapi_iam.iam_ecs_task_execution_arn
  ecs_security_group_id  = module.iapi_security_group.security_group_ecs_id

  project = {
    sub_name           = each.value.sub_name,
    alb_container_port = each.value.alb_container_port,
    cpu                = each.value.cpu,
    memory             = each.value.memory
  }

  ecr = {
    name = module.iapi_ecr[each.key].ecr_name
    url  = module.iapi_ecr[each.key].ecr_url
  }

  alb = {
    target_group_arn = module.iapi_alb.alb[each.key].target_group_arn
  }

  aws_config = {
    account_id = var.account_id
    region     = var.region
  }

  container = {
    cpu    = var.container_cpu
    memory = var.container_memory
    port   = var.container_port
  }

  vpc = {
    id         = module.iapi_vpc.vpc.id
    subnet_ids = concat(
      [for subnet in module.iapi_vpc.subnet.private : subnet.id]
    )
  }
}

module "iapi_s3_code_pipeline" {
  source   = "../../../modules/s3"
  for_each = var.projects

  name = var.project_name
  env  = var.env

  project = {
    sub_name = each.value.sub_name
  }

  aws_config = {
    account_id = var.account_id
    region     = var.region
  }

  s3 = {
    mode  = "Private"
    names = ["code-pipeline"]
  }
}

module "iapi_code_pipeline" {
  source     = "../../../modules/code_pipeline"
  depends_on = [module.iapi_ecs, module.iapi_iam, module.iapi_s3_code_pipeline]
  for_each   = var.projects

  name = var.project_name
  env  = var.env

  repo_owner = var.repo_owner

  iam_code_build_arn    = module.iapi_iam.iam_code_build_arn
  iam_code_pipeline_arn = module.iapi_iam.iam_code_pipeline_arn

  project = {
    sub_name           = each.value.sub_name,
    alb_container_port = each.value.alb_container_port,
    repo_name          = each.value.repo_name
  }

  aws_config = {
    account_id = var.account_id
    region     = var.region
  }

  ecr = {
    name = module.iapi_ecr[each.key].ecr_name
  }

  ecs = {
    cluster_name = module.iapi_ecs[each.key].ecs_cluster_name
    service_name = module.iapi_ecs[each.key].ecs_service_name
  }

  container = {
    name = module.iapi_ecs[each.key].container_name
  }

  vpc = {
    id = module.iapi_vpc.vpc.id
  }

  s3 = {
    bucket_name = module.iapi_s3_code_pipeline[each.key].s3["code-pipeline"].bucket
  }
}

module "iapi_elasticache" {
  source     = "../../../modules/elasticache"
  depends_on = [module.iapi_vpc]

  project = {
    name = var.project_name
    env  = var.env
  }

  aws_config = {
    account_id = data.aws_caller_identity.current.account_id
    region     = var.region
    region_a   = var.region_a
    region_b   = var.region_b
  }

  vpc = {
    id = module.iapi_vpc.vpc.id
    subnet_ids = concat(
      [for subnet in module.iapi_vpc.subnet.public : subnet.id]
    )
  }

  elasticache = {
    num_cache_clusters = var.num_cache_clusters
    port               = var.elasticache_port
  }
}

module "iapi_rds" {
  source     = "../../../modules/rds"
  depends_on = [module.iapi_vpc]

  project = {
    name = var.project_name
    env  = var.env
  }

  rds = {
    public_access = var.rds_public_access
  }

  aws_config = {
    account_id = data.aws_caller_identity.current.account_id
    region     = var.region
    region_a   = var.region_a
    region_b   = var.region_b
  }

  vpc = {
    id         = module.iapi_vpc.vpc.id
    subnet_ids = concat(
      [for subnet in module.iapi_vpc.subnet.public : subnet.id]
    )
  }
}


