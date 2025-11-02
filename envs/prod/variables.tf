variable "environment" {
  description = "Nombre del entorno (dev o prod)"
  type        = string
}

variable "instance_type_map" {
  description = "Mapa de tipos de instancia por entorno"
  type        = map(string)
}

variable "docker_images" {
  description = "Lista de imágenes Docker por instancia"
  type        = list(string)
}

variable "my_ip" {
  description = "IP personal para acceso SSH"
  type        = string
}

variable "key_name" {
  description = "Nombre de la llave SSH para acceder a las instancias EC2"
  type        = string
}