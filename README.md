# AgroCare Tech

Aplicação web MVC em **Spring Boot 3.3 + Thymeleaf** para gestão de animais, veterinários e serviços, com:

- login via **GitHub** ou **Google** (OAuth2);
- chat com IA (**Groq** via Spring AI);
- mensageria com **RabbitMQ**;
- banco **PostgreSQL** versionado com **Flyway**.

Este guia mostra como rodar tudo **localmente**.

## Pré-requisitos

| Ferramenta | Versão | Observação |
|---|---|---|
| Java (JDK) | 17+ | `java -version` |
| Docker + Docker Compose | qualquer recente | Sobe o Postgres e o RabbitMQ |
| Maven | opcional | O projeto já traz o wrapper `./mvnw` |
| Conta no GitHub | — | Para o login com GitHub |
| Conta Google | — | Para o login com Google |
| Conta na Groq | — | Para a chave da API do chat |

## Passo a passo

### 1. Clonar o repositório

```bash
git clone <url-do-repositorio>
cd AgroCare_Tech
```

### 2. Criar o arquivo `.env`

Todas as credenciais ficam num arquivo `.env` na raiz do projeto. Ele já está no `.gitignore`, então **não vai para o Git**. Comece pelo modelo:

```bash
cp .env.example .env
```

Os valores de banco, RabbitMQ e `SECURITY_USER_*` já vêm preenchidos. Faltam os tokens do GitHub, do Google e da Groq, explicados nos passos 3 a 5.

### 3. Token do GitHub (`GITHUB_ID` e `GITHUB_SECRET`)

1. Acesse **GitHub → Settings → Developer settings → OAuth Apps → New OAuth App**
   (link direto: [github.com/settings/applications/new](https://github.com/settings/applications/new)).
2. Preencha:
   - **Application name:** `AgroCare Tech (local)`
   - **Homepage URL:** `http://localhost:8080`
   - **Authorization callback URL:** `http://localhost:8080/login/oauth2/code/github`
3. Clique em **Register application**.
4. Copie o **Client ID** para `GITHUB_ID`.
5. Clique em **Generate a new client secret** e copie o valor para `GITHUB_SECRET`. Ele só aparece uma vez.

### 4. Token do Google (`GOOGLE_ID` e `GOOGLE_SECRET`)

1. Acesse [console.cloud.google.com](https://console.cloud.google.com) e crie um projeto, por exemplo `AgroCare Tech`.
2. **Tela de consentimento:** vá em **APIs e serviços → Tela de permissão OAuth** (ou **Google Auth Platform**) e clique em **Começar**:
   - **Nome do app:** `Agrocare Tech`
   - **E-mail de suporte** e **contato:** o seu e-mail
   - **Público:** **Externo**
3. **Usuários de teste:** em [console.cloud.google.com/auth/audience](https://console.cloud.google.com/auth/audience), na seção **Usuários de teste**, clique em **+ Adicionar usuários** e adicione o seu e-mail. Enquanto o app estiver em modo **Teste**, só esses e-mails conseguem entrar. Para liberar qualquer conta, clique em **Publicar app** na mesma página.
4. **Credenciais:** vá em **Clientes → Criar cliente** (ou **Credenciais → Criar credenciais → ID do cliente OAuth**):
   - **Tipo de aplicativo:** **Aplicativo da Web**
   - **URIs de redirecionamento autorizados:** `http://localhost:8080/login/oauth2/code/google`
5. Clique em **Criar**. Copie o **ID do cliente** para `GOOGLE_ID` e a **Chave secreta** para `GOOGLE_SECRET`. A chave pode ser exibida só uma vez; se precisar, baixe o JSON.

### 5. Token da Groq (`API_GENAI`)

1. Acesse [console.groq.com](https://console.groq.com) e crie uma conta (grátis).
2. Vá em **API Keys** ([console.groq.com/keys](https://console.groq.com/keys)) → **Create API Key**.
3. Copie a chave (começa com `gsk_`) para `API_GENAI`.

O modelo usado no chat está em `spring.ai.openai.chat.options.model`, no [application.properties](src/main/resources/application.properties). Se a Groq descontinuar o modelo, troque por um da [lista de modelos](https://console.groq.com/docs/models).

### 6. Subir o PostgreSQL e o RabbitMQ

```bash
docker compose up -d
```

Isso cria:

- **PostgreSQL 17** em `localhost:5432` (banco, usuário e senha: `mvcagrocaretech`)
- **RabbitMQ** em `localhost:5672`, com painel em [http://localhost:15672](http://localhost:15672) (usuário e senha: `mvcagrocaretech`)

Confira com `docker compose ps` se os dois containers estão `Up`. Se o `db` aparecer como `Exited`, veja a seção [Problemas comuns](#problemas-comuns).

### 7. Rodar a aplicação

O Spring **não lê o `.env` sozinho**: é preciso carregar as variáveis no terminal antes de rodar.

**macOS / Linux:**

```bash
set -a; source .env; set +a
./mvnw spring-boot:run
```

**Windows (PowerShell):**

```powershell
Get-Content .env | Where-Object { $_ -match '^\s*[^#].*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    Set-Item -Path "env:$($name.Trim())" -Value $value.Trim()
}
.\mvnw.cmd spring-boot:run
```

**IntelliJ:** em **Run → Edit Configurations → Environment variables**, cole as variáveis, ou use o plugin *EnvFile* apontando para o `.env`.

> Sempre que alterar o `.env`, **pare o app (Ctrl+C), carregue o `.env` de novo e rode outra vez**. O app só lê as variáveis ao iniciar.

Na primeira execução, o **Flyway** cria as tabelas e insere os dados de exemplo automaticamente (scripts em [src/main/resources/db/migration](src/main/resources/db/migration)).

### 8. Acessar

Abra [http://localhost:8080](http://localhost:8080). Você será redirecionado para `/login`; entre com **Google** ou **GitHub**.

| Rota | Descrição |
|---|---|
| `/` | Início (resumo, especialistas) |
| `/servico` | Atividades (histórico de atendimentos) |
| `/veterinario` | Especialistas |
| `/chat` | Chat com o assistente virtual (IA) |
| `/preferencias.html` | Perfil e preferências |
| `/logout` | Sair (encerra a sessão e limpa os dados do navegador) |

Se você entrar com GitHub e com Google usando o **mesmo e-mail**, é a mesma conta. O nome e a foto exibidos são os do último login.

## Gerar o .jar (opcional)

```bash
./mvnw clean package
set -a; source .env; set +a
java -jar target/mvc-agrocaretech-0.0.1-SNAPSHOT.jar
```

## Parar o ambiente

```bash
docker compose down        # para os containers, mantém os dados
docker compose down -v     # para e apaga os dados do banco e do RabbitMQ
```

## Problemas comuns

| Erro | Causa provável e solução |
|---|---|
| `Connection to localhost:5432 refused` | O Postgres não está rodando. Rode `docker compose up -d` e confira com `docker compose ps` |
| Container `db` como `Exited (1)` | O volume foi criado por outra versão do Postgres. Mantenha `postgres:17` no `docker-compose.yml`. Para recriar do zero: `docker compose down -v && docker compose up -d` |
| Google: `Erro 401: invalid_client` | O app foi iniciado sem o `.env` carregado (o Google recebe o texto `${GOOGLE_ID}`). Carregue o `.env` e reinicie o app (passo 7) |
| Google: `Acesso bloqueado` / `access_denied` | O seu e-mail não está em **Usuários de teste**, ou o app não foi publicado (passo 4) |
| `redirect_uri_mismatch` (Google) ou `redirect_uri is not associated` (GitHub) | A URI de callback cadastrada é diferente de `http://localhost:8080/login/oauth2/code/google` (ou `/github`) |
| Falha de autenticação no banco ou no RabbitMQ | Variáveis do `.env` não carregadas no terminal atual (passo 7) |
| `Port 8080 was already in use` | Outra aplicação está usando a porta. Descubra qual com `lsof -i :8080` e encerre, ou rode com `--server.port=8081` e ajuste as callback URLs no GitHub e no Google |
| Chat: erro 401 | `API_GENAI` ausente ou inválida |
| Chat: `400 model_decommissioned` | A Groq descontinuou o modelo. Troque o valor de `spring.ai.openai.chat.options.model` |
| Depois do login, 404 em `.well-known/appspecific/com.chrome.devtools.json` | É o Chrome DevTools, não o app; o login funcionou. Acesse `http://localhost:8080/` |
| `No static resource preferencias.html` | O arquivo precisa estar em `src/main/resources/static/`. Se acabou de ser criado, reinicie o app |
| Flyway `checksum mismatch` | Um script de migration já aplicado foi alterado. Rode `docker compose down -v` para recriar o banco |

## Tecnologias

Java 17 · Spring Boot 3.3 · Thymeleaf · Tailwind CSS · Spring Security (OAuth2 GitHub/Google) · Spring Data JPA · Flyway · PostgreSQL 17 · RabbitMQ · Spring AI (Groq) · Lombok
