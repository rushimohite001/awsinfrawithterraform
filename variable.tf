variable "region"{
    description = "Reigon for Infrastructure"
    default = "us-east-1"
}


locals {
  instance_type="t2.micro"
  instance_name="Terra Instance"
  key_name="proj_demo"
  # private_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICis5L8i8qVZswfRtpaYQlsP0x5PndxDT/ZkNL3he1dp User@LAPTOP-G492FC2B"
  vpc_cidr_block="10.10.0.0/16"
  vpc_tag_name = "my_vpc"
  public_subnet_cidr="10.10.1.0/24"
  public_subnet_cidr_1="10.10.3.0/24"
  public_subnet_tag_name="pubic_subnet"
  public_subnet_tag_name_1="pubic_subnet_1"
  private_subnet_cidr="10.10.2.0/24"
  private_subnet_cidr_2="10.10.4.0/24"
  private_subnet_tag_name="private_subnet"
  private_subnet_tag_name_2="private_subnet_2"
  internet_gateway_tag_name="internet_gatway"
  route_table_tag_name="public_route_table_1"
}