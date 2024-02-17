provider "aws" {
  region = "us-east-1"
}

variable "domain_name" {
  description = "The domain name for the WordPress site"
  default     = "testdomain.com"
}

variable "instance_name" {
  description = "The name of the Lightsail instance"
  default     = "WordPressInstanceTEST"
}

variable "blueprint_id" {
  description = "The blueprint ID for WordPress"
  default     = "wordpress" # replace with the actual blueprint ID for WordPress
}
