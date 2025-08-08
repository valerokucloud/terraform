variable "paris_cidr" {
  description = "VPC Paris"
  // type = map(string)
  type = string
}

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type = string
}

variable "ec2_specs" {
  description = "Parametros de la instancia"
  type = map(string)
}

variable "enable_monitoring" {
  description = "Habilita el despliegue de un servidor de monitoreo"
  /* Se puede hacer con bool (T/F) o con number (1/0):
    type = bool 
  */
  type = number
}

variable "access_key" {
  
}

variable "secret_key" {
  
}