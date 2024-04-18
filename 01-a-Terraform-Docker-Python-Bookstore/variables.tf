variable "instance_type" {
    type = string
    default = "t2.micro"
  
}

# variable "num_of_instance" {
#     type = number
#     default = 1
  
# }

variable "key_name" {
    type = string
    default = "firstkey"
  
}


variable "hosted-zone" {
  default = "ahmetdevops.click"
}
