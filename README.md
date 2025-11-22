\# 🧀 Cheese Factory Infrastructure



Infraestructura modular automatizada para desplegar servicios contenerizados en AWS usando Terraform. Incluye VPC, EC2 con Docker, ALB, grupos de seguridad y backend remoto en S3 + DynamoDB.



---



\## 📁 Estructura del proyecto



cheese-factory-infra/ ├── envs/ │ ├── dev/ │ │ ├── backend.tf │ │ ├── main.tf │ │ ├── terraform.tfvars │ └── prod/ │ ├── backend.tf │ ├── main.tf │ ├── terraform.tfvars ├── modules/ │ └── app/ │ ├── main.tf │ ├── variables.tf │ ├── outputs.tf │ └── user\_data.sh ├── alb.tf ├── outputs.tf ├── security\_groups.tf ├── terraform.tfvars.example ├── variables.tf ├── vpc.tf └── README.md





---



\## 🧠 Requisitos



\- AWS CLI configurado (`aws configure`)

\- Terraform ≥ 1.5

\- Permisos para crear recursos en AWS (VPC, EC2, S3, DynamoDB, ALB)



---



\## 🚀 Despliegue por entorno



```bash

cd envs/dev         # o envs/prod

terraform init -reconfigure

terraform validate

terraform plan -var-file="terraform.tfvars"

terraform apply -var-file="terraform.tfvars"





🧱 Backend remoto

El estado se guarda en S3 y se bloquea con DynamoDB:



Bucket: cheese-tfstate-dev / cheese-tfstate-prod



Tabla: cheese-tf-lock





graph TD

&nbsp; subgraph VPC

&nbsp;   ALB\[Application Load Balancer]

&nbsp;   EC2\_1\[EC2 - Docker: Wensleydale]

&nbsp;   EC2\_2\[EC2 - Docker: Cheddar]

&nbsp;   EC2\_3\[EC2 - Docker: Stilton]

&nbsp;   ALB --> EC2\_1

&nbsp;   ALB --> EC2\_2

&nbsp;   ALB --> EC2\_3

&nbsp; end



&nbsp; User\[Usuario] --> ALB

&nbsp; S3\[(S3 Bucket - tfstate)]

&nbsp; Dynamo\[(DynamoDB - Lock)]

&nbsp; Terraform\[Terraform CLI] --> S3

&nbsp; Terraform --> Dynamo

&nbsp; Terraform --> VPC



🔐 Seguridad

ALB permite tráfico HTTP desde internet



EC2 permite HTTP desde ALB y SSH solo desde tu IP (my\_ip)



Bucket S3 con versionamiento y bloqueo público



Locking de estado con DynamoDB





output "alb\_dns\_name" {

&nbsp; value = aws\_lb.cheese\_alb.dns\_name

}



🧪 Validación

Verifica que el ALB esté accesible por DNS



Usa terraform output para inspeccionar recursos



Revisa logs de EC2 para confirmar ejecución de user\_data.sh





🧼 Limpieza



terraform destroy -var-file="terraform.tfvars"


# Proyecto Infra Quesos Modular
Prueba de GitHub Actions con pull_request













