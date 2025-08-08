resource "aws_vpc" "vpc_prueba" {
  cidr_block = var.paris_cidr
  /* Decidirá qué CIDR aplicar en función del Workspace (Dev o Prod) 
  cidr_block = lookup(var.paris_cidr, terraform.workspace)*/
    tags = {
    "Name" = "VPC Paris-${local.sufix}"
  }
}

// Creación subredes (pública y privada):
  resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.vpc_prueba.id
    cidr_block              = var.subnets[0]
    map_public_ip_on_launch = true
    tags = {
      Name = "public subnet-${local.sufix}"
    }
  }

  resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.vpc_prueba.id
    cidr_block = var.subnets[1]
    tags = {
      Name = "private subnet-${local.sufix}"
    }
    depends_on = [
      aws_subnet.public_subnet
    ]
  }

// Creación IGW para dar salida a Internet desde la subnet pública:
  resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpc_prueba.id
    tags = {
      Name = "IGW VPC Paris-${local.sufix}"
    }
  }

// Creación CRT:
  resource "aws_route_table" "public_crt" {
    vpc_id = aws_vpc.vpc_prueba.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
      Name = "Public CRT-${local.sufix}"
    }
  }

// Creación enrutamiento de tablas con la subnet pública
  resource "aws_route_table_association" "crta_public_subnet" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_crt.id
  }

// Primero crear el SG, después las reglas (IN/OUT) referenciando al SG + aplicarlo en la EC2
  resource "aws_security_group" "sg_public_instance" {
    name        = "Public Instance SG-${local.sufix}"
    description = "Allow SSH inbound traffic and all egress traffic"
    vpc_id      = aws_vpc.vpc_prueba.id
  }

  resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
    security_group_id = aws_security_group.sg_public_instance.id
    cidr_ipv4         = var.sg_ingress_cidr
    description       = "SSH over Internet"
    from_port         = 22
    ip_protocol       = "tcp"
    to_port           = 22
  }

  resource "aws_vpc_security_group_egress_rule" "allow_com_out" {
    security_group_id = aws_security_group.sg_public_instance.id
    cidr_ipv4         = var.sg_ingress_cidr
    description       = "OUT con."
    from_port         = 0
    ip_protocol       = "tcp"
    to_port           = 0
    // cidr_ipv6         = ["::/0"]
  }



