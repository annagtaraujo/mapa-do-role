variable "supabase_access_token" {
  description = "Supabase Personal Access Token (https://supabase.com/dashboard/account/tokens)"
  type        = string
  sensitive   = true
}

variable "supabase_organization_id" {
  description = "ID da organização no Supabase (encontrado na URL do dashboard)"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token com escopo Edit em Pages e DNS"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "ID da conta Cloudflare (encontrado em dash.cloudflare.com)"
  type        = string
}

variable "google_oauth_client_id" {
  description = "Client ID do OAuth do Google Cloud Console"
  type        = string
  sensitive   = true
}

variable "google_oauth_client_secret" {
  description = "Client Secret do OAuth do Google Cloud Console"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Nome do projeto (usado como prefixo em recursos)"
  type        = string
  default     = "mapa-do-role"
}

variable "supabase_db_password" {
  description = "Senha do banco de dados Supabase (gerada pelo usuário, mínimo 12 chars)"
  type        = string
  sensitive   = true
}

variable "supabase_region" {
  description = "Região do Supabase (sa-east-1 para São Paulo)"
  type        = string
  default     = "sa-east-1"
}
