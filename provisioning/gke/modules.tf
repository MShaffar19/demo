module "vpc" {
  source = "./modules/vpc"
  name = "${ var.name }"
  cidr = "${ var.cidr }"
  region = "${ var.region }"
}

module "cluster" {
  source = "./modules/cluster"
  name = "${ var.name }"
  region = "${ var.region }"
  zone = "${ var.zone }"
  project = "${ var.project}"
  node_count = "${ var.node_count }"
  network = "${ module.vpc.network }"
  subnetwork = "${ module.vpc.subnetwork }"
  node_version = "${ var.node_version }"
  master_user = "${ var.master_user }"
  master_password = ${ var.master_password }
  vm_size = ${ var.vm_size }
}