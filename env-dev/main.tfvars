instances = {
  frontend = {
    name = "frontend"
    type = "t3.small"
  }
  mongodb = {
    name = "mongodb"
    type = "t2.micro"
  }
  catalogue = {
    name = "catalogue"
    type = "t3.small"
  }
  redis = {
    name = "redis"
    type = "t2.micro"
  }
  user = {
    name = "user"
    type = "t3.small"
  }
  cart = {
    name = "cart"
    type = "t3.small"
  }
  mysql = {
    name = "mysql"
    type = "t2.micro"
  }
  shipping = {
    name = "shipping"
    type = "t2.micro"
  }
  rabbitmq = {
    name = "rabbitmq"
    type = "t2.micro"
  }
  payment = {
    name = "payment"
    type = "t3.small"
  }
}
env = "dev"
