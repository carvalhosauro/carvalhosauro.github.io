# carvalhosauro.github.io

Blog pessoal gerado com [Hugo](https://gohugo.io/) e o tema [Hextra](https://imfing.github.io/hextra/), publicado via [GitHub Pages](https://pages.github.com/).

## Páginas

| Página | Caminho |
|--------|---------|
| Home | `/` |
| Artigos | `/posts/` |
| Sobre | `/sobre/` |
| Quem sou eu | `/quem-sou-eu/` |
| Leituras | `/leituras/` |
| Arquivo | `/arquivo/` |
| RSS | `/index.xml` |

## Desenvolvimento local

Requisitos: Hugo Extended ≥ 0.145 e Go.

```bash
# Instalar dependências do tema
hugo mod tidy

# Servidor local com hot reload
hugo server -D
```

Abra [http://localhost:1313](http://localhost:1313).

## Novo artigo

```bash
hugo new content posts/titulo-do-artigo/index.md
```

Edite o arquivo gerado, ajuste `draft: false` quando estiver pronto.

## Deploy

O workflow `.github/workflows/hugo.yml` publica automaticamente a cada push na branch `main`.

No repositório GitHub:

1. **Settings → Pages → Build and deployment → Source: GitHub Actions**
2. Push para `main`

Site: https://carvalhosauro.github.io/

## Estrutura

```
.
├── content/
│   ├── _index.md           # Home
│   ├── posts/              # Artigos
│   ├── sobre.md
│   ├── quem-sou-eu.md
│   ├── leituras/
│   └── arquivo/            # Arquivo cronológico
├── hugo.yaml
├── go.mod
└── .github/workflows/hugo.yml
```
