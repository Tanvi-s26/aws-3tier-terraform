variable "name" {
  type = string
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "db_sg_id" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "multi_az" {
  type    = bool
  default = true
}