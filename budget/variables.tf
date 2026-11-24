variable "budget_amount" {
  type        = number
  description = "Crédit Azure total à surveiller, dans la devise de facturation"
  default     = 100
}

variable "budget_start_date" {
  type        = string
  description = "Premier jour du mois de début de la période (RFC3339, jour = 01)"
  default     = "2026-11-01T00:00:00Z"
}

variable "alert_thresholds" {
  type        = list(number)
  description = "Seuils d'alerte (% du budget, dépenses réelles), étape par étape"
  default     = [10, 20, 30, 40, 50, 60, 70, 80, 90]
}

variable "forecast_threshold" {
  type        = number
  description = "Seuil d'alerte sur la dépense prévue (% du budget)"
  default     = 100
}
