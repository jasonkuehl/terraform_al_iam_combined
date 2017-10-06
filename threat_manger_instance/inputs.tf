variable "vpc_id" {}
variable "sn" {
	type = "list"
}
variable "instance_type" {}
variable "tag_name" {}
variable "claimCIDR" {}
variable "monitoringCIDR" {}
variable "instance_count" {}
variable "primary_key_pair" {}
variable "zones" {
	type = "list"
}
variable "puppet_env" {}
