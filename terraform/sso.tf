locals {
    environment_accounts = {
        prod = var.accounts.prod.id
        qual = var.accounts.qual.id
        dev  = var.accounts.dev.id
    }
}