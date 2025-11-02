module "bastion" {
  source          = "../../modules/bastion"
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  key_name        = var.key_name
  my_ip           = var.my_ip
}
