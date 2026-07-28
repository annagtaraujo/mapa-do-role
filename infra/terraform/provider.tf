terraform {
  required_version = ">= 1.6"

  required_providers {
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # Recomendado: usar backend remoto para o estado (ex: Cloudflare R2 ou Supabase Storage)
  # backend "s3" {
  #   bucket                      = "mapa-do-role-tfstate"
  #   key                         = "terraform.tfstate"
  #   region                      = "auto"
  #   endpoint                    = "https://<account_id>.r2.cloudflarestorage.com"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  # }
}

provider "supabase" {
  # Token gerado em: https://supabase.com/dashboard/account/tokens
  # Definir via variável de ambiente: SUPABASE_ACCESS_TOKEN
  access_token = var.supabase_access_token
}

provider "cloudflare" {
  # Token gerado em: https://dash.cloudflare.com/profile/api-tokens
  # Definir via variável de ambiente: CLOUDFLARE_API_TOKEN
  api_token = var.cloudflare_api_token
}
