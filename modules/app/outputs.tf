output "instance_ids" {
  value = aws_instance.cheese[*].id
}

output "private_ips" {
  value = aws_instance.cheese[*].private_ip
}

output "alb_dns_name" {
  value = aws_lb.cheese_alb.dns_name
}
