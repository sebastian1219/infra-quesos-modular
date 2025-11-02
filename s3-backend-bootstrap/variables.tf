variable "bucket_name" {
  description = "Nombre del bucket para el estado remoto"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev o prod)"
  type        = string
}
