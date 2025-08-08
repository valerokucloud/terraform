/* Definición de variables locales dentro de la config (más sencillo cambiar aquí que no en todas las variables)
    Así, se evita lo siguiente:
    * Duplicación de código
    * Expresiones más legibles
    * Aplicación lógica sencilla
*/
    locals {
        sufix = "${var.tags.Project}-${var.tags.Env}-${var.tags.Region}" #recurso-cerberus-prod-region
    }

// Creación recurso para poder dar nombre al bucket Cerberus:
    resource "random_string" "sufijo-s3" {
    length = 8
    special = false
    upper = false
    }

// Creación locals para aplicar un sufijo único (a través de un randomize) al bucket, teniendo una estructura parecida al locals de arriba:
    locals {
      s3-sufix = "${var.tags.Project}-${random_string.sufijo-s3.id}"
    }