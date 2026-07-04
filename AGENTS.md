# AGENTS.md — carvalhosauro.github.io

Guia para agentes e contribuidores do blog Hugo.

## Visão geral

| Item | Valor |
|------|-------|
| Site | https://carvalhosauro.github.io/ |
| Gerador | Hugo Extended ≥ 0.146 |
| Tema | [Hextra](https://github.com/imfing/hextra) (módulo Go) |
| Deploy | GitHub Actions → GitHub Pages |
| Idiomas | `pt-br` (padrão), `en` |

Blog pessoal com i18n, micro-copy customizado e tema Hextra estendido via CSS/partials locais.

## Estrutura do repositório

```
.
├── .devcontainer/          # Ambiente de dev no Cursor/VS Code
├── .github/workflows/      # CI: build + deploy
├── archetypes/             # Template de novos posts
├── assets/css/custom.css   # Estilo e micro-interações
├── content/
│   ├── pt-br/              # Conteúdo em português
│   └── en/                 # Conteúdo em inglês (slugs em inglês)
├── i18n/                   # Strings globais (404, copyright, etc.)
├── layouts/                # Overrides do tema (404, footer, hero)
├── scripts/dev.sh          # Atalhos de desenvolvimento
├── hugo.yaml               # Config principal
├── go.mod / go.sum         # Módulo Hugo (tema Hextra)
└── public/                 # Build gerado (gitignored)
```

## Ambiente de desenvolvimento

### Opção A — Dev Container (recomendado)

1. Abra o repo no Cursor/VS Code.
2. **Reopen in Container** quando solicitado (ou Command Palette → *Dev Containers: Reopen in Container*).
3. O container instala **Go + Hugo Extended 0.146** e roda `hugo mod tidy` na criação.
4. Porta **1313** é encaminhada automaticamente.

Dentro do container:

```bash
./scripts/dev.sh server
```

### Opção B — Local

Requisitos: Go + Hugo Extended ≥ 0.146.

```bash
hugo mod tidy
./scripts/dev.sh server
```

## scripts/dev.sh

| Comando | O que faz |
|---------|-----------|
| `./scripts/dev.sh server` | `hugo server -D` em http://localhost:1313 |
| `./scripts/dev.sh build` | Gera `./public` (produção local) |
| `./scripts/dev.sh new-post pt-br "Meu artigo"` | Cria post em `content/pt-br/posts/...` |
| `./scripts/dev.sh new-post en "My article"` | Cria post em `content/en/posts/...` |

Torne executável se necessário: `chmod +x scripts/dev.sh`

## Conteúdo e i18n

Cada idioma tem **pasta própria** (`contentDir` no `hugo.yaml`):

| Página | PT | EN |
|--------|----|----|
| Home | `/pt-br/` | `/en/` |
| Artigos | `/pt-br/posts/` | `/en/posts/` |
| Sobre | `/pt-br/sobre/` | `/en/about/` |
| Quem sou eu | `/pt-br/quem-sou-eu/` | `/en/who-am-i/` |
| Leituras | `/pt-br/leituras/` | `/en/reading/` |
| Arquivo | `/pt-br/arquivo/` | `/en/archive/` |

### Traduzir conteúdo

1. Crie a versão nos dois idiomas (pastas `content/pt-br/` e `content/en/`).
2. Use o **mesmo** `translationKey` no front matter de ambos.
3. Slugs podem diferir por idioma (ex.: `sobre.md` ↔ `about.md`).

Exemplo de post:

```yaml
# content/pt-br/posts/meu-tema/index.md
translationKey: my-topic
draft: false
```

```yaml
# content/en/posts/my-topic/index.md
translationKey: my-topic
draft: false
```

O seletor de idioma do Hextra liga as páginas pela `translationKey`.

## Customização do tema

| Arquivo | Uso |
|---------|-----|
| `assets/css/custom.css` | Cores, tipografia, hover, animações |
| `layouts/_partials/custom/footer.html` | Micro-copy do rodapé |
| `layouts/_partials/custom/head-end.html` | Scripts extras |
| `layouts/shortcodes/hero.html` | Hero da home |
| `layouts/404.html` | Página 404 |
| `hugo.yaml` → `languages.*.params.microcopy` | Textos da home/footer por idioma |
| `i18n/pt-br.yaml`, `i18n/en.yaml` | Strings compartilhadas (404, etc.) |

Não edite o tema Hextra no cache de módulos — sobrescreva em `layouts/` e `assets/`.

## Build e deploy

- **Local:** `./scripts/dev.sh build` ou `hugo --gc --minify`
- **CI:** push na branch `main` dispara `.github/workflows/hugo.yml`
- **GitHub Pages:** Settings → Pages → Source: **GitHub Actions**
- Não commitar `public/` — o workflow gera no CI

## Convenções para agentes

1. **Commits:** Conventional Commits (`feat(content):`, `chore:`, `docs:`, `ci:`).
2. **Escopo:** Mudanças mínimas; não refatorar o que não foi pedido.
3. **Posts:** Manter tom direto (referência TabNews/Fidelissauro); PT e EN quando o conteúdo for publicável.
4. **Drafts:** Novos posts começam com `draft: true` até revisão explícita.
5. **Verificar:** Rodar `./scripts/dev.sh build` antes de concluir mudanças estruturais.

## O que este repo **não** usa (vs. AkitaOnRails)

- Docker Compose separado — só Dev Container
- Ruby / `generate_index.rb` — home e listagens vêm do Hextra
- Scripts de migração legada — blog novo, sem export Rails
