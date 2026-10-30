variable "localisation" {
  type        = string
  description = "localisation des ressources dans Azure"
  default     = "germanywestcentral"
}

variable "environment" {
  type        = string
  description = "type d'environnement"
  default     = "lab"
}

variable "project_name" {
  type        = string
  description = "nom du projet"
  default     = "secops"
}

variable "vnet_cidr" {
  type        = list(string)
  description = "CIDR de base pour les virtuals networks"
  default     = ["10.0.0.0/16"]
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "CIDR de base pour les subnetworks"
  default     = ["10.0.1.0/24"]
}