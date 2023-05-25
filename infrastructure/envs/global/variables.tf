variable "project_name" {
  type        = string
  description = "Name of project."
  default     = "serverless-from-scratch"
}

variable "repo_slug" {
  type        = string
  description = "Name of your GitHub repository."
  default     = "gh/DomWeldon/serverless-from-scratch"
}

variable "default_region" {
  type        = string
  description = "Default AWS region to operate in."
  default     = "eu-west-2"
}

variable "domain_name" {
  type        = string
  description = "Domain name to use (with namecheap only)"
  default     = "domweldon.tech"
}