/*
 * variables.tf
 * Common variables to use in various Terraform files (*.tf)
 */

# The AWS region to use for the dev environment's infrastructure
# Currently, Fargate is only available in `us-west-1`.
variable "region" {
  default = "us-west-2"
}

# Tags for the infrastructure
variable "tags" {
  type = "map"
  default = {
    application = "wordpress"
    environment = "dev"
    team = "devops"
    contact-email = "j@j.ca"
    customer = "myself"
  }
}

# The application's name
variable "app" {
  default = "wordpress"
}

# The environment that is being built
variable "environment" {
  default = "dev"
}

# The port the container will listen on, used for load balancer health check
# Best practice is that this value is higher than 1024 so the container processes
# isn't running at root.
variable "container_port" {
  default = "80"
}

# The port the load balancer will listen on
variable "lb_port" {
  default = "80"
}

# The load balancer protocol
variable "lb_protocol" {
  default = "HTTP"
}


