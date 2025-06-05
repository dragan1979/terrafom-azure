output "availability_set_id" {
  value       = element(concat(azurerm_availability_set.this.*.id, [""]), 0)
  description = "Azure VM Availability Set ID"
  depends_on = [
    azurerm_availability_set.this,
  ]
 }


