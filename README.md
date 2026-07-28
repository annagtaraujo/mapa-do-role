# Mapa do Rolê — Rio de Janeiro

Mapa interativo de eventos na cidade do Rio de Janeiro.

**Stack:** Cloudflare Pages · Supabase (Postgres + Auth) · MapLibre GL JS · OpenStreetMap/Protomaps · OpenTofu (IaC)

---

## Pré-requisitos

Antes de rodar qualquer comando, você precisa das seguintes contas e tokens:

### 1. Supabase

1. Crie uma conta em [supabase.com](https://supabase.com) e uma **organização**.
2. Gere um **Personal Access Token** em: `Dashboard → Account → Access Tokens`
3. Anote o **Organization ID** (aparece na URL do dashboard: `app.supabase.com/org/<org-id>`).

### 2. Cloudflare

1. Crie uma conta em [cloudflare.com](https://cloudflare.com).
2. Gere um **API Token** em: `Profile → API Tokens → Create Token`
   - Use o template **"Edit Cloudflare Workers"** como base, ou crie um custom com escopo:
     - `Account > Cloudflare Pages: Edit`
     - `Zone > DNS: Edit` (somente se for configurar domínio próprio)
3. Anote o **Account ID** (aparece na URL do dashboard: `dash.cloudflare.com/<account-id>`).

### 3. Google OAuth

1. Acesse o [Google Cloud Console](https://console.cloud.google.com).
2. Crie um projeto (ou use um existente).
3. Ative a **Google+ API** (ou People API).
4. Em **APIs & Services → Credentials**, crie um **OAuth 2.0 Client ID**:
   - Tipo: Web application
   - Authorized redirect URI: `https://<seu-supabase-project-ref>.supabase.co/auth/v1/callback`
5. Anote o **Client ID** e o **Client Secret**.

### 4. GitHub Secrets

No repositório GitHub, configure os seguintes Secrets (`Settings → Secrets and variables → Actions`):

| Secret | Descrição |
|--------|-----------|
| `SUPABASE_ACCESS_TOKEN` | Personal Access Token do Supabase |
| `SUPABASE_ORG_ID` | Organization ID do Supabase |
| `SUPABASE_DB_PASSWORD` | Senha do banco (você escolhe, mín. 12 chars) |
| `SUPABASE_PROJECT_REF` | Preenchido após o primeiro `tofu apply` |
| `CLOUDFLARE_API_TOKEN` | API Token do Cloudflare |
| `CLOUDFLARE_ACCOUNT_ID` | Account ID do Cloudflare |
| `GOOGLE_OAUTH_CLIENT_ID` | Client ID do Google OAuth |
| `GOOGLE_OAUTH_CLIENT_SECRET` | Client Secret do Google OAuth |

---

## Setup local (IaC com OpenTofu)

### Instalar OpenTofu

```bash
# macOS
brew install opentofu

# Ou via script oficial: https://opentofu.org/docs/intro/install/
```

### Configurar variáveis

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores reais (nunca commite esse arquivo)
```

### Inicializar e aplicar

```bash
cd infra/terraform

# Baixa os providers (supabase/supabase e cloudflare/cloudflare)
tofu init

# Visualiza o que será criado
tofu plan

# Cria os recursos (projeto Supabase + Pages project no Cloudflare)
tofu apply
```

Após o `apply`, anote o `supabase_project_ref` do output — você vai precisar dele para o passo de migrations.

---

## Migrations de banco (Supabase CLI)

O schema SQL **não** é gerenciado pelo OpenTofu. Use o Supabase CLI:

```bash
# Instalar
brew install supabase/tap/supabase

# Linkar com o projeto criado pelo tofu
supabase link --project-ref <supabase_project_ref>

# Criar uma nova migration
supabase migration new <nome-da-migration>

# Aplicar migrations no banco remoto
supabase db push
```

As migrations ficam em `infra/supabase/migrations/` e são versionadas no repositório.

---

## Deploy

O CI/CD via GitHub Actions roda automaticamente a cada push em `main`:

1. **`deploy.yml`** — executa `tofu apply` e depois `supabase db push`.
2. **`recycle-events.yml`** — roda toda segunda-feira para fazer scraping e upsert dos eventos (a ser implementado).

---

## Desenvolvimento local (frontend)

```bash
npm install
npm run dev
```

Crie um arquivo `.env` na raiz com:

```env
VITE_SUPABASE_URL=https://<project-ref>.supabase.co
VITE_SUPABASE_ANON_KEY=<anon-key>
```

---

## Estrutura do repositório

```
.
├── index.html                  # Frontend (a ser migrado para framework)
├── events.json                 # Dados estáticos (será substituído pelo Supabase)
├── infra/
│   ├── terraform/              # IaC com OpenTofu
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   ├── supabase.tf
│   │   ├── cloudflare.tf
│   │   └── terraform.tfvars.example
│   └── supabase/
│       ├── migrations/         # Schema SQL versionado
│       └── seed.sql
└── .github/
    └── workflows/
        ├── deploy.yml
        └── recycle-events.yml
```
