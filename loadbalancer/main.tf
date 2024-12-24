# security hroup load balancer 

resource "aws_security_group" "app_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "app-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "app" {
  name               = var.name_lb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  subnets            = var.public_subnet_id

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = var.name_lb
  }
}

resource "aws_lb_target_group" "apptg" {
  name        = var.name_lb_target_group
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apptg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_lb_attachment" {
  autoscaling_group_name = var.name_autoScale
  lb_target_group_arn    = aws_lb_target_group.apptg.arn
}