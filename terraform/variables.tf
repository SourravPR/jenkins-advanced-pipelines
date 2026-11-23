variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "student_prefix" {
  description = "Unique prefix to prevent resource name collisions"
  type        = string
  default     = "instructor-demo"
}

variable "allowed_ssh_cidr" {
  description = "Baseline authorized CIDR for SSH (used to demonstrate drift)"
  type        = string
  default     = "203.0.113.10/32"
}
