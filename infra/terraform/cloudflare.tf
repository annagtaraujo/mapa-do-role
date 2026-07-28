resource "cloudflare_pages_project" "main" {
  account_id        = var.cloudflare_account_id
  name              = var.project_name
  production_branch = "main"

  build_config {
    # Site estático puro — sem build step, serve direto da raiz
    build_command   = ""
    destination_dir = "/"
    root_dir        = "/"
  }

  deployment_configs {
    production {
      # env_vars: mapa de variáveis injetadas no build (plain_text ou secret_text)
      env_vars = {
        VITE_SUPABASE_URL = {
          type  = "plain_text"
          value = "https://${supabase_project.main.id}.supabase.co"
        }
        VITE_SUPABASE_ANON_KEY = {
          type  = "plain_text"
          value = supabase_project.main.anon_key
        }
      }
      compatibility_date = "2024-01-01"
    }

    preview {
      env_vars = {
        VITE_SUPABASE_URL = {
          type  = "plain_text"
          value = "https://${supabase_project.main.id}.supabase.co"
        }
        VITE_SUPABASE_ANON_KEY = {
          type  = "plain_text"
          value = supabase_project.main.anon_key
        }
      }
      compatibility_date = "2024-01-01"
    }
  }

  source {
    type = "github"
    config {
      owner                         = "annagtaraujo"
      repo_name                     = "mapa-do-role"
      production_branch             = "main"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployments_enabled = true
      preview_deployment_setting    = "custom"
      preview_branch_includes       = ["dev", "staging"]
    }
  }
}

output "pages_url" {
  description = "URL do site no Cloudflare Pages"
  value       = "https://${cloudflare_pages_project.main.subdomain}.pages.dev"
}
