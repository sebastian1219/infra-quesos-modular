data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2_sg" {
  count       = var.create_ec2_sg ? 1 : 0
  name        = "cheese-${var.environment}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ec2-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "allow_alb_to_ec2" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.create_ec2_sg ? aws_security_group.ec2_sg[0].id : (var.ec2_sg_id != "" ? var.ec2_sg_id : null)
  source_security_group_id = var.alb_sg_id
  description              = "Permitir trafico HTTP desde el ALB"
}

resource "aws_instance" "cheese" {
  count         = 3
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = element(var.private_subnets, count.index)

  vpc_security_group_ids = [var.create_ec2_sg ? aws_security_group.ec2_sg[0].id : (var.ec2_sg_id != "" ? var.ec2_sg_id : null)]

  user_data = templatefile("${path.module}/user_data.sh", {
    docker_image = element(var.docker_images, count.index)
  })

  tags = {
    Name        = format("cheese-%s-%s", var.environment, count.index)
    IsPrimary   = count.index == 0 ? "true" : "false"
    Environment = var.environment
    Project     = "cheese-factory"
  }
}

resource "aws_lb" "cheese_alb" {
  name               = "cheese-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = {
    Name        = "cheese-${var.environment}-alb"
    Environment = var.environment
    Project     = "cheese-factory"
  }
}

resource "aws_lb_target_group" "cheese_tg" {
  name     = "cheese-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/index.html"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = {
    Environment = var.environment
    Project     = "cheese-factory"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cheese_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cheese_tg.arn
  }

}

resource "aws_lb_target_group_attachment" "cheese" {
  count               = length(aws_instance.cheese)
  target_group_arn    = aws_lb_target_group.cheese_tg.arn
  target_id           = aws_instance.cheese[count.index].id
  port                = 80

  depends_on = [
    aws_lb_target_group.cheese_tg,
    aws_lb_listener.http
  ]
}


