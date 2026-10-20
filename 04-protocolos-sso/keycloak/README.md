# Keycloak local — laboratório

Sobe o Keycloak **só na sua máquina**, no modo de desenvolvimento, para a fase 4. A imagem é a `26.8.1`, a mesma do guia oficial na data da trilha (20/10/2026). Se o site do Keycloak mostrar uma versão mais nova, vale atualizar a tag e anotar no registro do laboratório.

Isto não é instalação de empresa: não tem HTTPS, o banco é o embutido e a senha inicial do guia é `admin` / `admin`. A porta está publicada em `127.0.0.1:8080`. Não mude para `0.0.0.0`.

## Subir

Na pasta deste arquivo, com Docker Desktop ou Docker Engine já instalado:

```bash
docker compose up
```

Console: <http://127.0.0.1:8080/admin>

Para trocar a senha sem editar o compose, copie `.env.example` para `.env`. O `.env` fica de fora do Git.

Parar sem apagar o container: `Ctrl+C` e, depois, `docker start -a labiam-keycloak`. Apagar tudo: `docker compose down`. Se o container some, o realm some junto. Exporte o realm pelo console se quiser guardar o laboratório, e não commite o export se ele tiver segredo de client.

## O que praticar em seguida

1. Crie o realm `labiam`. Não use o realm `master` para aplicativo.
2. Crie um usuário fictício, por exemplo `ana.teste`.
3. Crie um client OpenID Connect e teste em <https://www.keycloak.org/app/>.
4. O lab de SAML entre dois realms está no checklist da fase 4 e no passo a passo de [`../../docs/trilha-iam.html`](../../docs/trilha-iam.html).

Guia oficial: [Keycloak no Docker](https://www.keycloak.org/getting-started/getting-started-docker).
