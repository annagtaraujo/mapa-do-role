resource "supabase_project" "main" {
  organization_id   = var.supabase_organization_id
  name              = var.project_name
  database_password = var.supabase_db_password
  region            = var.supabase_region
}

resource "supabase_settings" "main" {
  project_ref = supabase_project.main.id

  auth = jsonencode({
    site_url               = "https://${var.project_name}.pages.dev"
    additional_redirect_urls = [
      "http://localhost:5173",
      "http://localhost:3000",
    ]
    external_google_enabled       = true
    # Client ID e Secret vêm de variáveis sensíveis — nunca hardcoded
    external_google_client_id     = var.google_oauth_client_id
    external_google_secret        = var.google_oauth_client_secret
    jwt_expiry                    = 3600
    refresh_token_rotation_enabled = true
  })
}

output "supabase_project_ref" {
  description = "Referência do projeto Supabase (usada em: supabase link --project-ref)"
  value       = supabase_project.main.id
}

output "supabase_project_url" {
  description = "URL da API do projeto Supabase"
  value       = "https://${supabase_project.main.id}.supabase.co"
}

output "supabase_anon_key" {
  description = "Chave anon pública do Supabase (segura para expor no frontend)"
  value       = supabase_project.main.anon_key
  sensitive   = false
}
