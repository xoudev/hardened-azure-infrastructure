data "azurerm_subscription" "current" {}

locals {
  # Azure limite un budget à 5 notifications : on découpe les seuils en lots de 5.
  chunks = chunklist(var.alert_thresholds, 5)
}

resource "azurerm_consumption_budget_subscription" "credit" {
  count           = length(local.chunks)
  name            = "budget-credit-${count.index + 1}"
  subscription_id = data.azurerm_subscription.current.id

  amount     = var.budget_amount
  time_grain = "Annually"

  time_period {
    start_date = var.budget_start_date
  }

  dynamic "notification" {
    for_each = local.chunks[count.index]
    content {
      enabled        = true
      threshold      = notification.value
      threshold_type = "Actual"
      operator       = "GreaterThanOrEqualTo"
      contact_roles  = ["Owner"]
    }
  }

  # La prévision (seuil 100 %) tient dans le dernier lot s'il reste de la place.
  dynamic "notification" {
    for_each = count.index == length(local.chunks) - 1 && length(local.chunks[count.index]) < 5 ? [1] : []
    content {
      enabled        = true
      threshold      = var.forecast_threshold
      threshold_type = "Forecasted"
      operator       = "GreaterThanOrEqualTo"
      contact_roles  = ["Owner"]
    }
  }
}
