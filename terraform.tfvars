paris_cidr = "10.10.0.0/16"
# public_subnet = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"
subnets = ["10.10.0.0/24", "10.10.1.0/24"]

/*
paris_cidr = {
  "prod" = "10.10.0.0/16"
  "dev" = "172.16.0.0/16"
}
*/

tags = {
  "Env"         = "dev"
  "Owner"       = "Valeroku"
  "IAC"         = "Terraform"
  "IAC Version" = "1.12.2"
  "Project"     = "cerberus"
  "Region"      = "Virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

// Parametrización de las instancias ec2:
  ec2_specs = {
    "ami" = "ami-070d5ebc329f499a5"
    "instance_type" = "t2.micro"
  }

enable_monitoring = 1