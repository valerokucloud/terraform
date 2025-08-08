// Declaración variables instancias
variable "instancias" {
  description = "Nombre de las instancias"
  type = set(string)
  // Definición de cuantas instancias necesitamos y su nombre:
    default = [ "apache","mysql","jumpserver"]
  
}

resource "aws_instance" "public_instance" {
  /* En el count: definimos el numero de instancias mencionadas en var.instancias. Tener en cuenta que trabajamos con valores de lista.
    count         = length(var.instancias) */
  // Utilizando un for_each (por cada instancia...) --> trata los elementos como una lista (mejor opción que el count)
    for_each = toset(var.instancias)
  ami           = var.ec2_specs.ami
  instance_type = var.ec2_specs.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
   
 // Definición nombre tags en base a la lista de la variable instancias:
    tags = {
    /*Utilizando el count:
      "Name" = var.instancias[count.index] */
    // ...me pones el nombre de los diferentes valores de var.instancias
      "Name" = "${each.value}-${local.sufix}"
  }
}

/* Estructura condicional Según el valor de la enable.monitoring creará la inst. o no
    Se pueden utilizar varios comparadores (<,>,==,...)
*/
  resource "aws_instance" "monitoring_instance" {
    /* Si es true --> crealo, si es 0 --> no
      count = var.enable_monitoring = ? 1 : 0
    */
    // Si se quiere hacer con number: es = 1? --> hazlo, 0 --> no lo hagas
      count = var.enable_monitoring == 1 ? 1 : 0
    ami           = var.ec2_specs.ami
    instance_type = var.ec2_specs.instance_type
    subnet_id     = aws_subnet.public_subnet.id
    key_name      = data.aws_key_pair.key.key_name
    vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
        
    tags = {
      "Name" ="Monitoreo-${local.sufix}" 
    }
  
  }


/* Uso de variables para explicar las funciones de Terraform a través de su consola:
  variable "cadena" {
    type = string
    default = "ami-123,AMI-AAV,ami-12f"
  }

  variable "palabras" {
    type = list(string)
    default = [ "hola","como","están" ]
  }


  variable "entornos" {
    type = map(string)
    default = {
      "prod" = "10.10.0.0/16"
      "dev" = "172.16.0.0/16"
    }
  }*/
