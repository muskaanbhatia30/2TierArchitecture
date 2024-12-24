// adding module network
module "tiernetwork"{
source="./network"
tier_vpc_tag=var.tier_vpc_tag
public_subnet_name=var.public_subnet_name
private_subnet_name=var.private_subnet_name
public_route_table=var.public_route_table
private_route_table = var.private_route_table
tier_nat = var.tier_nat
}

module "tierautoscale" {
  source = "./autoscale"
  name_launch_template=var.name_launch_template
  vpc_id=module.tiernetwork.vpc_id
  name_autoScale=var.name_autoScale
  private_subnet_id = module.tiernetwork.private_subnet_id
}

module "bastion" {
  source = "./bastion"
  bastion_sg = var.bastion_sg
  bastionServer = var.bastionServer
  public_subnet_id = module.tiernetwork.public_subnet_id
  vpc_id = module.tiernetwork.vpc_id
}

module "loadbalancer" {
  source = "./loadbalancer"
  public_subnet_id = module.tiernetwork.public_subnet_id
  name_lb = var.name_lb
  name_lb_target_group = var.name_lb_target_group
  vpc_id = module.tiernetwork.vpc_id
  name_autoScale = module.tierautoscale.name_autoScale
}
