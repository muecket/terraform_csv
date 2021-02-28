terraform {
  required_version = ">=0.14.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  # file() - liest UTF-8 codierte Datei als string ein.
  # csvdecode() - Decodiert einen string im csv format.
  # Erzeugt eine Liste von maps mit den Daten.
  # Das Trennzeichen muss ein Komma sein!
  resource_groups = csvdecode(file("./rg_list.csv"))
}

resource "azurerm_resource_group" "rg" {
  # Geht durch jedes Object, dass durch die For-Schleife erzeugt wird.
  # Die For-Schleife erzeugt ein Object, dass zwei Ausdrücke hat.
  # Ausdruck1 => Ausdruck2 ... sie Beispiel für for-schleife unten.
  for_each = { for rg in local.resource_groups : rg.rgid => rg }

  name     = each.value.rgname
  location = each.value.location
  tags = {
    "testtag" = each.value.tag
  }
}

# Beipsiel liste von maps, die nach dem einlesen und decodieren
# erzeugt wird. Nach dem Befehl "resource_groups = csvdecode(file("./rg_list.csv"))"
#
#  local.resource_groups = [
#      {
#          location = "northeurope"
#          rgid     = "1"
#          rgname   = "tftest-testcsv-1-rg"
#          tag      = "Tag1"
#       },
#      {
#          location = "westeurope"
#          rgid     = "2"
#          rgname   = "tftest-testcsv-2-rg"
#          tag      = "Tag2"
#       },
# .
# .
# .
#   ]


# Mit output kann man sich den Inhalt der Variablen ausgeben lassen.
#
# output "csvdeco" {
#   value = local.resource_groups
# }

# Folgendes Object wird erzeugt, wenn die for-schleife ausgeführt wird.
# { for rg in local.resource_groups : rg.rgid => rg }
#
# object = {
#     1 = {
#         location = "northeurope"
#         rgid     = "1"
#         rgname   = "tftest-testcsv-1-rg"
#         tag      = "Tag1"
#     }
#     2 = {
#         location = "westeurope"
#         rgid     = "2"
#         rgname   = "tftest-testcsv-2-rg"
#         tag      = "Tag2"
#     }
#     .
#     .
#     .
#     }
