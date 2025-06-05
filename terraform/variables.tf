variable "region" {} # Allows for alternate region selection

# Defines the IPv4 ranges for each public subnet as a list
variable "public_subnet_cidr" {
    type = list(string)
    description = "List containing IPv4 CIDR for the Public Subnets"
    default = ["10.0.1.0/24"]
}


# Defines the IPv4 ranges for each private subnet as a list
#variable "private_subnet_cidr" {
#    type = list(string)
#    description = "List containing IPv4 CIDR's for the Private Subnets"
#    default = ["10.0.3.0/24", "10.0.4.0/24"]
#}