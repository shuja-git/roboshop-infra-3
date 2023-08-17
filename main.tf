module "ec2" {
  for_each = var.instnces
  source = "./ec2"
  component = each.value["name"]
  instance_type = each.value["type"]
  password = each.value["password"]
  }

