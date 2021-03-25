variable "region" {
  default = "us-east-1"
}

variable "image" {
  default = "ami-042e8287309f5df03"
}

variable "zone1" {
  default = "us-east-1a"
}

variable "zone2" {
  default = "us-east-1b"
}


variable "keyName" {
  type    = string
  default = "us-east-1_KeyPair"
}
