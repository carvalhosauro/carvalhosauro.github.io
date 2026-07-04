# carvalhosauro.github.io

Blog pessoal onde publico **meus aprendizados e opiniões** sobre tecnologia, engenharia de software e carreira.

Não é documentação oficial nem verdade absoluta — é registro do que estou estudando, testando e pensando em voz alta, com o rigor que espero de quem quer ser referência técnica um dia.

Gerado com [Hugo](https://gohugo.io/) e o tema [Hextra](https://imfing.github.io/hextra/), publicado via [GitHub Pages](https://pages.github.com/). Inspirado na densidade do [TabNews](https://www.tabnews.com.br) e na profundidade do [Fidelissauro](https://fidelissauro.dev).

## Idiomas

| Idioma | Home | RSS |
|--------|------|-----|
| Português (padrão) | `/pt-br/` | `/pt-br/index.xml` |
| English | `/en/` | `/en/index.xml` |

O seletor de idioma fica no menu. Traduções usam `translationKey` igual nos dois idiomas e pastas separadas (`content/pt-br/` e `content/en/`).

## Páginas

| Página | PT | EN |
|--------|----|----|
| Artigos | `/pt-br/posts/` | `/en/posts/` |
| Sobre | `/pt-br/sobre/` | `/en/about/` |
| Quem sou eu | `/pt-br/quem-sou-eu/` | `/en/who-am-i/` |
| Leituras | `/pt-br/leituras/` | `/en/reading/` |
| Arquivo | `/pt-br/arquivo/` | `/en/archive/` |

## Desenvolvimento local

Requisitos: Hugo Extended ≥ 0.146 e Go — ou use o **Dev Container** (`.devcontainer/`).

Detalhes do fluxo: [AGENTS.md](./AGENTS.md)

```bash
chmod +x scripts/dev.sh   # uma vez
./scripts/dev.sh server   # http://localhost:1313
```

## Novo artigo

```bash
hugo new content posts/titulo-do-artigo/index.md --lang pt-br
hugo new content posts/article-title/index.md --lang en
```

1. Use o mesmo `translationKey` nos dois idiomas.
2. Defina `draft: false` quando estiver pronto.

## Personalização

| Arquivo | Função |
|---------|--------|
| `assets/css/custom.css` | Tipografia, cores, micro-interações |
| `layouts/_partials/custom/footer.html` | Micro-copy do footer |
| `layouts/shortcodes/hero.html` | Hero da home |
| `hugo.yaml` → `languages.*.params.microcopy` | Textos da home/footer |
| `i18n/*.yaml` | Strings globais (404, busca, etc.) |

## Deploy

O workflow `.github/workflows/hugo.yml` publica automaticamente a cada push na branch `main`.

1. **Settings → Pages → Build and deployment → Source: GitHub Actions**
2. Push para `main`

Site: https://carvalhosauro.github.io/

## Evoluir para newsletter (futuro)

O blog continua sendo a **fonte da verdade** (Markdown no Git). A newsletter seria um canal de distribuição — não substitui o site.

### Caminho recomendado (simples)

1. **Escolher um provedor** — [Buttondown](https://buttondown.com/), [Substack](https://substack.com/), [ConvertKit](https://convertkit.com/) ou [Beehiiv](https://www.beehiiv.com/). Para começar enxuto, Buttondown integra bem com blogs estáticos.
2. **Blog → email** — a cada post publicado, enviar um e-mail resumido com link para o artigo completo no site (não republicar o texto inteiro, para manter SEO e controle no repo).
3. **Formulário no site** — adicionar CTA na home/footer (`layouts/_partials/custom/footer.html`) apontando para a página de inscrição do provedor.
4. **RSS como ponte** — muitos serviços importam `/pt-br/index.xml` para quem prefere receber tudo automaticamente.

### Caminho alternativo (mais controle)

- **Conteúdo exclusivo ocasional** no e-mail + arquivo público no blog depois.
- **Seção `content/pt-br/newsletter/`** no Hugo para arquivar edições enviadas (opcional).
- **Automação** — GitHub Action que, no deploy, notifica o provedor via webhook/API quando um post com tag `newsletter: true` for publicado.

### O que não muda

- Posts continuam em `content/pt-br/posts/` e `content/en/posts/`.
- Deploy continua via GitHub Actions.
- Opiniões e aprendizados permanecem versionados no Git, como hoje.

Quando decidir avançar, o passo mínimo é: provedor + link de inscrição no footer + hábito de avisar por e-mail a cada post novo.

## Estrutura

```
.
├── .devcontainer/
├── assets/css/custom.css
├── content/
│   ├── pt-br/
│   │   ├── _index.md
│   │   ├── posts/
│   │   ├── sobre.md
│   │   ├── quem-sou-eu.md
│   │   ├── leituras/
│   │   └── arquivo/
│   └── en/
│       ├── _index.md
│       ├── posts/
│       ├── about.md
│       ├── who-am-i.md
│       ├── reading/
│       └── archive/
├── i18n/
├── layouts/
├── scripts/dev.sh
├── AGENTS.md
├── hugo.yaml
└── .github/workflows/hugo.yml
```
