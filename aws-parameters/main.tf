resource "aws_ssm_parameter" "param" {
  count = length(var.parameters)
  name  = var.parameters[count.index].name
  type  = var.parameters[count.index].type
  value = var.parameters[count.index].value
}
variable "parameters" {}
resource "aws_ssm_parameter" "secret" {
  count = length(var.secret)
  name  = var.secret[count.index].name
  type  = var.secret[count.index].type
  value = var.secret[count.index].value
}
variable "secret" {}
