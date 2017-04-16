module "vpc" {
  source = "./modules/vpc"
  name = "${ var.name }"
  cidr = "${ var.vpc_cidr }"
  name_servers_file = "${ module.dns.name_servers_file }"
  location = "${ var.location }"
 }

module "dns" {
  source = "./modules/dns"
  name = "${ var.name }"
  internal_tld = "${ var.internal_tld }"
  master_ips = "${ module.etcd.master_ips }"
}

module "etcd" {
  source = "./modules/etcd"
  name = "${ var.name }"
  location = "${ var.location }"
  admin_username = "${ var.admin_username }"
  master_node_count = "${ var.master_node_count }"
  master_vm_size = "${ var.master_vm_size }"
  image_publisher = "${ var.image_publisher }"
  image_offer = "${ var.image_offer }"
  image_sku = "${ var.image_sku }"
  image_version = "${ var.image_version }"
  subnet_id = "${ module.vpc.subnet_id }"
  storage_account = "${ azurerm_storage_account.cncf.name }"
  storage_primary_endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  storage_container = "${ azurerm_storage_container.cncf.name }"
  availability_id = "${ azurerm_availability_set.cncf.id }"
  cluster_domain = "${ var.cluster_domain }"
  kubelet_image_url = "${ var.kubelet_image_url }"
  kubelet_image_tag = "${ var.kubelet_image_tag }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_tld = "${ var.internal_tld }"
  pod_cidr = "${ var.pod_cidr }"
  service_cidr = "${ var.service_cidr }"
  k8s_cloud_config = "${file("${ var.data_dir }/azure-config.json")}"
  ca = "${file("${ var.data_dir }/.cfssl/ca.pem")}"
  k8s_etcd = "${file("${ var.data_dir }/.cfssl/k8s-etcd.pem")}"
  k8s_etcd_key = "${file("${ var.data_dir }/.cfssl/k8s-etcd-key.pem")}"
  k8s_apiserver = "${file("${ var.data_dir }/.cfssl/k8s-apiserver.pem")}"
  k8s_apiserver_key = "${file("${ var.data_dir }/.cfssl/k8s-apiserver-key.pem")}"
}


module "bastion" {
  source = "./modules/bastion"
  name = "${ var.name }"
  location = "${ var.location }"
  bastion_vm_size = "${ var.bastion_vm_size }"
  image_publisher = "${ var.image_publisher }"
  image_offer = "${ var.image_offer }"
  image_sku = "${ var.image_sku }"
  image_version = "${ var.image_version }"
  admin_username = "${ var.admin_username }"
  subnet_id = "${ module.vpc.subnet_id }"
  storage_primary_endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  storage_container = "${ azurerm_storage_container.cncf.name }"
  availability_id = "${ azurerm_availability_set.cncf.id }"
  internal_tld = "${ var.internal_tld }"
}

module "worker" {
  source = "./modules/worker"
  name = "${ var.name }"
  location = "${ var.location }"
  admin_username = "${ var.admin_username }"
  worker_node_count = "${ var.worker_node_count }"
  worker_vm_size = "${ var.worker_vm_size }"
  image_publisher = "${ var.image_publisher }"
  image_offer = "${ var.image_offer }"
  image_sku = "${ var.image_sku }"
  image_version = "${ var.image_version }"
  subnet_id = "${ module.vpc.subnet_id }"
  storage_account = "${ azurerm_storage_account.cncf.name }"
  storage_primary_endpoint = "${ azurerm_storage_account.cncf.primary_blob_endpoint }"
  storage_container = "${ azurerm_storage_container.cncf.name }"
  availability_id = "${ azurerm_availability_set.cncf.id }"
  external_lb = "${ module.etcd.external_lb }"
  cluster_domain = "${ var.cluster_domain }"
  kubelet_image_url = "${ var.kubelet_image_url }"
  kubelet_image_tag = "${ var.kubelet_image_tag }"
  dns_service_ip = "${ var.dns_service_ip }"
  internal_tld = "${ var.internal_tld }"
  k8s_cloud_config = "${file("${ var.data_dir }/azure-config.json")}"
}


module "kubeconfig" {
  source = "./modules/kubeconfig"

  admin_key_pem = "${ var.data_dir }/.cfssl/k8s-admin-key.pem"
  admin_pem = "${ var.data_dir }/.cfssl/k8s-admin.pem"
  ca_pem = "${ var.data_dir }/.cfssl/ca.pem"
  data_dir = "${ var.data_dir }"
  fqdn_k8s = "${ module.etcd.fqdn_lb }"
  name = "${ var.name }"
}
