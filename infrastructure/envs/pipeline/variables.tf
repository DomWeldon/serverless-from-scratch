variable "api_entrypoint" {
  type    = string
  default = "app.main.handler"
}

variable "image_url" {
  type = string
}

variable "api_execution_arn" {
  type = string
}

variable "api_id" {
  type = string
}