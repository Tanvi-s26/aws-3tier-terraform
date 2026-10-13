variable "name" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "alert_email" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "asg_name" {
  type = string
}

variable "db_identifier" {
  type = string
}