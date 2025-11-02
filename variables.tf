variable "environment" {
  description = "Entorno de despliegue: dev o prod"
  type        = string
}

variable "instance_type_map" {
  default = {
    dev  = "t2.micro"
    prod = "t3.small"
  }
}

variable "my_ip" {
  description = "Tu IP pública para acceso SSH"
  type        = string
}

variable "docker_images" {
  type    = list(string)
  default = ["errm/cheese:wensleydale", "errm/cheese:cheddar", "errm/cheese:stilton"]
}
