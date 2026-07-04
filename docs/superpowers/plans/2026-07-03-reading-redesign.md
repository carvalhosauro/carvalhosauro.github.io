# Reading Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign de leitura do blog: light-first, lista de posts custom com badges por tipo, página de artigo melhorada, micro-interações consistentes e microcopy PT+EN na voz definida na spec.

**Architecture:** Site Hugo (0.146.0 extended) com tema Hextra v0.12.3 via Hugo Modules. Customização por override: templates espelhando caminhos do tema em `layouts/`, CSS em `assets/css/custom.css` (montado por cima do arquivo homônimo do tema), textos em `hugo.yaml` (`params.microcopy`) e `i18n/*.yaml`. Nenhum fork do tema.

**Tech Stack:** Hugo extended ≥ 0.146.0, Hextra v0.12.3, CSS puro, JS vanilla (~15 linhas), YAML.

**Spec:** `docs/superpowers/specs/2026-07-03-reading-redesign-design.md`

## Global Constraints

- Hugo extended ≥ 0.146.0 (CI usa exatamente `0.146.0`; use essa versão para verificar).
- Hextra fixado em v0.12.3 — NÃO rodar `hugo mod get -u`.
- Front matter do tipo de post é `postType` (NUNCA `type` — é reservado do Hugo e altera o lookup de template).
- Valores válidos de `postType`: `aprendizado`, `opiniao`, `resumo` (slugs sem acento). Rótulos exibidos vêm de i18n.
- Light mode é o modo primário de design; dark é derivado. `params.theme.default: light`.
- Todas as animações/transições novas devem estar cobertas por `@media (prefers-reduced-motion: reduce)`.
- Timing de micro-interações: 150–220ms com easing único `cubic-bezier(0.2, 0.8, 0.2, 1)` (token `--site-ease`).
- Microcopy: primeira pessoa, honesto, direto, sem piada forçada de git/CI. Copiar textos EXATAMENTE da tabela da spec (seção 5).
- Commits: conventional commits em inglês (`feat:`, `fix:`, `chore:`, `docs:`), um commit por task.
- Build de verificação: `hugo --gc --minify` na raiz do repo; saída em `./public`.
- Referência do tema (só leitura, NÃO editar): clone em `/tmp/claude-1000/-home-gustavo-repo-me-carvalhosauro-github-io/c9a3ad52-3c63-4fe6-ba7e-686e4f969ddb/scratchpad/hextra`. Se ausente: `git clone --depth 1 --branch v0.12.3 https://github.com/imfing/hextra <esse caminho>`.

---

### Task 1: Ambiente de verificação + build baseline

Hugo não está instalado na máquina (dev normalmente roda no Dev Container). Instalar binário local para permitir verificação de cada task.

**Files:**
- Nenhum arquivo do repo é modificado nesta task.

**Interfaces:**
- Produces: comando `hugo` disponível no PATH (`~/.local/bin/hugo`), build baseline verde. Todas as tasks seguintes dependem disso.

- [ ] **Step 1: Verificar se hugo já existe**

Run: `command -v hugo && hugo version || echo "MISSING"`
Se já existir hugo extended ≥ 0.146.0, pule para o Step 3.

- [ ] **Step 2: Instalar hugo extended 0.146.0 em ~/.local/bin**

```bash
mkdir -p ~/.local/bin
curl -sL https://github.com/gohugoio/hugo/releases/download/v0.146.0/hugo_extended_0.146.0_linux-amd64.tar.gz \
  | tar -xz -C ~/.local/bin hugo
export PATH="$HOME/.local/bin:$PATH"
hugo version
```

Expected: `hugo v0.146.0-...+extended linux/amd64`

- [ ] **Step 3: Build baseline**

```bash
cd /home/gustavo/repo/me/carvalhosauro.github.io
hugo mod tidy
hugo --gc --minify
```

Expected: build sem erros, `Total in ... ms` no fim, diretório `./public` criado com `public/pt-br/index.html` e `public/en/index.html`. (`hugo mod tidy` baixa o Hextra na primeira vez; precisa de rede.)

- [ ] **Step 4: Sem commit** — nada mudou no repo. Registrar no relatório que baseline está verde.

---

### Task 2: Microcopy PT+EN + light default

Reescreve todos os textos na voz da spec e muda o default do tema para light. Textos vêm EXATAMENTE da tabela da seção 5 da spec.

**Files:**
- Modify: `hugo.yaml` (linhas ~36–44 pt-br, ~94–102 en, ~153–155 theme)
- Modify: `i18n/pt-br.yaml` (arquivo inteiro)
- Modify: `i18n/en.yaml` (arquivo inteiro)
- Modify: `content/pt-br/_index.md` (subtitles dos cards)
- Modify: `content/en/_index.md` (subtitles dos cards)
- Modify: `assets/css/custom.css` (remover bloco morto `.hextra-search-no-result::after`, linhas 127–133)

**Interfaces:**
- Consumes: nada.
- Produces: chaves i18n `readingTime`, `postType_aprendizado`, `postType_opiniao`, `postType_resumo` que as Tasks 5 e 6 consomem via `T "readingTime" $page.ReadingTime` e `T (printf "postType_%s" $slug)`.

- [ ] **Step 1: Atualizar microcopy pt-br em hugo.yaml**

Substituir o bloco `microcopy` do idioma `pt-br` por:

```yaml
      microcopy:
        heroEyebrow: "Diário técnico"
        heroTitle: "Escrevo pra entender o que aprendi."
        heroSubtitle: "Aprendizados, opiniões e resumos do que estou estudando. Sem fingir que sei mais do que sei."
        exploreTitle: "Por onde começar"
        footerTagline: "Um post por vez."
        footerAside: "Escrito por mim, revisado por mim. Os erros também são meus."
```

- [ ] **Step 2: Atualizar microcopy en em hugo.yaml**

Substituir o bloco `microcopy` do idioma `en` por:

```yaml
      microcopy:
        heroEyebrow: "Tech journal"
        heroTitle: "I write to understand what I learned."
        heroSubtitle: "Learnings, opinions, and digests of what I'm studying. No pretending I know more than I do."
        exploreTitle: "Start here"
        footerTagline: "One post at a time."
        footerAside: "Written by me, reviewed by me. The mistakes are mine too."
```

- [ ] **Step 3: Mudar default do tema para light em hugo.yaml**

```yaml
  theme:
    default: light
    displayToggle: true
```

- [ ] **Step 4: Reescrever i18n/pt-br.yaml (arquivo completo)**

```yaml
copyright: "© 2026 carvalhosauro"
readMore: "Continuar lendo"
backToHome: "Voltar pro início"
notFoundTitle: "Essa página não existe."
notFoundMessage: "Talvez o link envelheceu, talvez eu tenha quebrado alguma coisa. Provavelmente fui eu."
notFoundAction: "Voltar pro início"
noResultsFound: "Nada por aqui. Ou escrevi pouco, ou o termo é outro."
readingTime: "{{ .Count }} min de leitura"
postType_aprendizado: "aprendizado"
postType_opiniao: "opinião"
postType_resumo: "resumo"
```

(Nota: a chave antiga `searchEmpty` sai — era código morto. `noResultsFound` é a chave que o flexsearch do Hextra realmente usa no estado vazio.)

- [ ] **Step 5: Reescrever i18n/en.yaml (arquivo completo)**

```yaml
copyright: "© 2026 carvalhosauro"
readMore: "Keep reading"
backToHome: "Back to start"
notFoundTitle: "This page doesn't exist."
notFoundMessage: "Maybe the link aged, maybe I broke something. Probably me."
notFoundAction: "Back to start"
noResultsFound: "Nothing here. Either I wrote too little, or try another term."
readingTime: "{{ .Count }} min read"
postType_aprendizado: "learning"
postType_opiniao: "opinion"
postType_resumo: "digest"
```

- [ ] **Step 6: Remover CSS morto do estado vazio da busca**

Em `assets/css/custom.css`, remover o bloco inteiro (nada no site seta `data-empty-hint`):

```css
.hextra-search-no-result::after {
  content: attr(data-empty-hint);
  display: block;
  margin-top: 0.35rem;
  font-size: 0.85rem;
  color: var(--site-muted);
}
```

- [ ] **Step 7: Ajustar subtitles dos cards da home**

Em `content/pt-br/_index.md`, substituir o bloco de cards por:

```markdown
{{< cards >}}
  {{< card link="posts" title="Artigos" icon="newspaper" subtitle="Aprendizados, opiniões e resumos" >}}
  {{< card link="sobre" title="Sobre" icon="information-circle" subtitle="O que é este blog" >}}
  {{< card link="quem-sou-eu" title="Quem sou eu" icon="user" subtitle="Quem escreve por aqui" >}}
  {{< card link="leituras" title="Leituras" icon="book-open" subtitle="Livros e links que valeram a leitura" >}}
{{< /cards >}}
```

(Corrige também o typo "que valho".)

Em `content/en/_index.md`, substituir por:

```markdown
{{< cards >}}
  {{< card link="posts" title="Articles" icon="newspaper" subtitle="Learnings, opinions, and digests" >}}
  {{< card link="about" title="About" icon="information-circle" subtitle="What this blog is about" >}}
  {{< card link="who-am-i" title="Who am I" icon="user" subtitle="Who writes here" >}}
  {{< card link="reading" title="Reading" icon="book-open" subtitle="Books and links worth the time" >}}
{{< /cards >}}
```

- [ ] **Step 8: Build + asserts**

```bash
hugo --gc --minify
grep -q "Escrevo pra entender o que aprendi." public/pt-br/index.html && echo PT-HERO-OK
grep -q "I write to understand what I learned." public/en/index.html && echo EN-HERO-OK
grep -q "Um post por vez." public/pt-br/index.html && echo PT-FOOTER-OK
grep -q "Essa página não existe." public/pt-br/404.html && echo PT-404-OK
grep -q "This page doesn" public/en/404.html && echo EN-404-OK
grep -rq "data-empty-hint" public/ && echo DEAD-CSS-STILL-THERE || echo DEAD-CSS-GONE
```

Expected: todos os `*-OK` impressos e `DEAD-CSS-GONE`.

- [ ] **Step 9: Commit**

```bash
git add hugo.yaml i18n/ content/pt-br/_index.md content/en/_index.md assets/css/custom.css
git commit -m "feat(copy): rewrite microcopy in first-person voice, default to light theme"
```

---

### Task 3: Front matter postType (archetype + posts existentes)

**Files:**
- Modify: `archetypes/posts.md`
- Modify: `content/pt-br/posts/bem-vindo/index.md` (front matter)
- Modify: `content/en/posts/bem-vindo/index.md` (front matter)

**Interfaces:**
- Consumes: nada.
- Produces: `.Params.postType` (string: `aprendizado` | `opiniao` | `resumo`) nos posts. Tasks 5 e 6 leem via `$page.Params.postType`.

- [ ] **Step 1: Adicionar postType ao archetype**

`archetypes/posts.md` — adicionar a linha `postType` após `draft`:

```yaml
---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
postType: "aprendizado" # aprendizado | opiniao | resumo
translationKey: "{{ .File.ContentBaseName }}"
tags: []
description: ""
---
```

- [ ] **Step 2: Adicionar postType aos posts bem-vindo (pt-br e en)**

Em ambos `content/pt-br/posts/bem-vindo/index.md` e `content/en/posts/bem-vindo/index.md`, adicionar no front matter (após `draft: false`):

```yaml
postType: "aprendizado"
```

- [ ] **Step 3: Build para garantir que nada quebrou**

Run: `hugo --gc --minify`
Expected: build verde. (`postType` ainda não é renderizado — só não pode quebrar.)

- [ ] **Step 4: Commit**

```bash
git add archetypes/posts.md content/pt-br/posts/bem-vindo/index.md content/en/posts/bem-vindo/index.md
git commit -m "feat(content): add postType front matter for content type badges"
```

---

### Task 4: Fundação CSS — tokens, focus rings, sombras, motion

**Files:**
- Modify: `assets/css/custom.css`

**Interfaces:**
- Consumes: nada.
- Produces: custom properties `--site-ease`, `--site-duration`, `--site-accent` e o padrão de focus ring. Tasks 5–8 usam esses tokens.

- [ ] **Step 1: Adicionar tokens ao bloco `:root` existente**

No bloco `@layer theme { :root { ... } }`, adicionar após `--site-muted`:

```css
    --site-muted: rgb(20 20 20 / 0.66);
    --site-accent: hsl(var(--primary-hue) var(--primary-saturation) var(--primary-lightness));
    --site-ease: cubic-bezier(0.2, 0.8, 0.2, 1);
    --site-duration: 180ms;
    --site-shadow-lift:
      0 2px 4px rgb(20 20 20 / 0.04),
      0 6px 12px rgb(20 20 20 / 0.05),
      0 12px 24px rgb(20 20 20 / 0.06);
```

(Atenção: `--site-muted` sobe de `0.62` para `0.66` — contraste melhor no light. Substituir a linha existente, não duplicar.)

No bloco `html[class~="dark"]`, adicionar:

```css
    --site-shadow-lift:
      0 2px 4px rgb(0 0 0 / 0.3),
      0 8px 20px rgb(0 0 0 / 0.35);
```

- [ ] **Step 2: Focus rings consistentes**

Adicionar após o bloco de tokens (fora do `@layer`):

```css
/* Focus — keyboard navigation */
:where(a, button, input, select, summary, [tabindex]):not([class*="hextra-focus-visible"]):focus-visible {
  outline: 2px solid var(--site-accent);
  outline-offset: 2px;
  border-radius: 2px;
  box-shadow: none;
}
```

- [ ] **Step 3: Trocar sombra do card hover pelos tokens**

Substituir as regras existentes de `.hextra-card:hover` (incluindo a variante dark, que passa a ser coberta pelo token):

```css
.hextra-card {
  border: 1px solid var(--site-border);
  transition:
    transform var(--site-duration) var(--site-ease),
    box-shadow var(--site-duration) var(--site-ease),
    border-color var(--site-duration) var(--site-ease);
}

.hextra-card:hover {
  transform: translateY(-3px);
  border-color: rgb(255 183 77 / 0.45);
  box-shadow: var(--site-shadow-lift);
}
```

Remover a regra `html[class~="dark"] .hextra-card:hover { ... }` (o token dark cobre).

- [ ] **Step 4: Padronizar transições existentes com os tokens**

Nas regras existentes, trocar durações/easings hardcoded:
- `.hextra-nav-container a, .hextra-sidebar-container a` → `transition: color var(--site-duration) var(--site-ease), opacity var(--site-duration) var(--site-ease);`
- `.content a:not(.hextra-card)` → `transition: text-decoration-color var(--site-duration) var(--site-ease), color var(--site-duration) var(--site-ease);`
- `.hextra-code-copy-btn` → `transition: transform 150ms var(--site-ease), opacity 150ms var(--site-ease);`
- `.site-404__action` → `transition: transform var(--site-duration) var(--site-ease), border-color var(--site-duration) var(--site-ease), background var(--site-duration) var(--site-ease);`

- [ ] **Step 5: Build + assert**

```bash
hugo --gc --minify
find public -name '*.css' | xargs grep -l 'site-shadow-lift' && echo TOKENS-OK
find public -name '*.css' | xargs grep -l 'focus-visible' && echo FOCUS-OK
```

Expected: `TOKENS-OK` e `FOCUS-OK`.

- [ ] **Step 6: Commit**

```bash
git add assets/css/custom.css
git commit -m "feat(ui): add design tokens, focus rings, and layered shadows"
```

---

### Task 5: Lista de posts custom com badges

**Files:**
- Create: `layouts/_partials/post-meta.html`
- Create: `layouts/blog/list.html` (override do Hextra — base: clone do tema em `<scratchpad>/hextra/layouts/blog/list.html`)
- Modify: `assets/css/custom.css`

**Interfaces:**
- Consumes: `.Params.postType` (Task 3); chaves i18n `postType_*` e `readingTime` (Task 2); tokens CSS (Task 4).
- Produces: partial `post-meta.html` com assinatura `(dict "page" <Page> "showReadingTime" <bool>)` — a Task 6 consome com a mesma assinatura. Classes CSS `site-post-list`, `site-post-item`, `site-badge`, `site-badge--{aprendizado|opiniao|resumo|neutral}`, `site-post-meta`.

- [ ] **Step 1: Criar o partial post-meta.html**

`layouts/_partials/post-meta.html`:

```html
{{- /*
  Post metadata line: date + type badge + optional reading time.
  Params: page (Page), showReadingTime (bool, default false)
*/ -}}
{{- $page := .page -}}
{{- $showReadingTime := .showReadingTime | default false -}}
{{- $known := slice "aprendizado" "opiniao" "resumo" -}}
<div class="site-post-meta">
  {{- with $page.Date }}<time class="site-post-meta__date" datetime="{{ .Format "2006-01-02" }}">{{ partial "utils/format-date" . }}</time>{{ end -}}
  {{- with $page.Params.postType -}}
    {{- $slug := . -}}
    {{- $variant := cond (in $known $slug) $slug "neutral" -}}
    <span class="site-badge site-badge--{{ $variant }}">{{ or (T (printf "postType_%s" $slug)) $slug }}</span>
  {{- end -}}
  {{- if $showReadingTime }}<span class="site-post-meta__reading">{{ T "readingTime" $page.ReadingTime }}</span>{{ end -}}
</div>
```

- [ ] **Step 2: Criar o override da lista**

`layouts/blog/list.html` (estrutura externa copiada do tema; itens reescritos):

```html
{{ define "main" }}
  <div class="hx:mx-auto hx:flex hextra-max-page-width">
    {{ partial "sidebar.html" (dict "context" . "disableSidebar" true "displayPlaceholder" true) }}
    <article class="hx:w-full hx:break-words hx:flex hx:min-h-[calc(100vh-var(--navbar-height))] hx:min-w-0 hx:justify-center hx:pb-8 hx:pr-[calc(env(safe-area-inset-right)-1.5rem)]">
      <main id="content" class="hx:w-full hx:min-w-0 hextra-max-content-width hx:px-6 hx:pt-4 hx:md:px-12">
        {{ partial "breadcrumb.html" (dict "page" . "enable" false) }}
        {{ if .Title }}<h1 class="site-list-title">{{ .Title }}</h1>{{ end }}
        <div class="content">{{ .Content }}</div>
        {{- $pages := partial "utils/sort-pages" (dict "page" . "by" site.Params.blog.list.sortBy "order" site.Params.blog.list.sortOrder) -}}
        {{- $pagerSize := site.Params.blog.list.pagerSize | default 10 -}}
        {{- $paginator := .Paginate $pages $pagerSize -}}
        <ul class="site-post-list">
          {{- range $paginator.Pages }}
            <li class="site-post-item">
              {{ partial "post-meta.html" (dict "page" . "showReadingTime" true) }}
              <h3 class="site-post-item__title">
                <a href="{{ .RelPermalink }}">{{ .Title }}<span class="site-post-item__arrow" aria-hidden="true">→</span></a>
              </h3>
              <p class="site-post-item__summary">{{- partial "utils/page-description" . -}}</p>
            </li>
          {{ end -}}
        </ul>
        {{- if gt $paginator.TotalPages 1 -}}
          {{ partial "components/blog-pager.html" $paginator }}
        {{- end -}}
      </main>
    </article>
    <div class="hx:max-xl:hidden hx:h-0 hx:w-64 hx:shrink-0"></div>
  </div>
{{- end -}}
```

(Decisões: sem link "readMore" separado — o título é o link, com seta; tags saem da listagem — o badge de tipo assume o papel de classificação. Título da página deixa de ser centralizado.)

- [ ] **Step 3: CSS da lista e badges**

Adicionar em `assets/css/custom.css`:

```css
/* Post list */
.site-list-title {
  margin: 0.5rem 0 1.5rem;
  font-family: "IBM Plex Serif", Georgia, serif;
  font-size: 2rem;
  font-weight: 700;
  letter-spacing: -0.01em;
}

.site-post-list {
  margin: 0;
  padding: 0;
  list-style: none;
}

.site-post-item {
  padding: 1.5rem 0;
  border-top: 1px solid var(--site-border);
}

.site-post-item__title {
  margin: 0.5rem 0 0.35rem;
  font-family: "IBM Plex Serif", Georgia, serif;
  font-size: 1.35rem;
  line-height: 1.3;
  font-weight: 600;
}

.site-post-item__title a {
  color: inherit;
  text-decoration: none;
}

.site-post-item__title a:hover {
  text-decoration: underline;
  text-decoration-color: rgb(255 183 77 / 0.6);
  text-underline-offset: 0.18em;
}

.site-post-item__arrow {
  display: inline-block;
  margin-left: 0.35rem;
  opacity: 0;
  transform: translateX(-4px);
  transition: opacity var(--site-duration) var(--site-ease), transform var(--site-duration) var(--site-ease);
}

.site-post-item:hover .site-post-item__arrow {
  opacity: 1;
  transform: translateX(0);
}

.site-post-item__summary {
  margin: 0;
  max-width: 60ch;
  line-height: 1.65;
  color: var(--site-muted);
}

/* Post meta line */
.site-post-meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.6rem;
  font-family: "IBM Plex Mono", monospace;
  font-size: 0.78rem;
  color: var(--site-muted);
}

/* Type badges — desaturated, light-first */
.site-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.1rem 0.55rem;
  border: 1px solid transparent;
  border-radius: 999px;
  font-family: "IBM Plex Mono", monospace;
  font-size: 0.72rem;
  font-weight: 500;
  letter-spacing: 0.02em;
}

.site-badge--aprendizado {
  background: hsl(36 70% 93%);
  border-color: hsl(36 50% 80%);
  color: hsl(30 60% 30%);
}

.site-badge--opiniao {
  background: hsl(215 35% 93%);
  border-color: hsl(215 25% 79%);
  color: hsl(215 32% 32%);
}

.site-badge--resumo {
  background: hsl(95 30% 92%);
  border-color: hsl(95 22% 76%);
  color: hsl(100 30% 26%);
}

.site-badge--neutral {
  background: hsl(0 0% 93%);
  border-color: hsl(0 0% 80%);
  color: hsl(0 0% 30%);
}

html[class~="dark"] .site-badge--aprendizado {
  background: hsl(36 30% 16%);
  border-color: hsl(36 30% 28%);
  color: hsl(36 60% 72%);
}

html[class~="dark"] .site-badge--opiniao {
  background: hsl(215 25% 17%);
  border-color: hsl(215 22% 30%);
  color: hsl(215 45% 75%);
}

html[class~="dark"] .site-badge--resumo {
  background: hsl(100 20% 15%);
  border-color: hsl(100 18% 27%);
  color: hsl(95 35% 70%);
}

html[class~="dark"] .site-badge--neutral {
  background: hsl(0 0% 16%);
  border-color: hsl(0 0% 28%);
  color: hsl(0 0% 72%);
}
```

- [ ] **Step 4: Build + asserts**

```bash
hugo --gc --minify
grep -q "site-badge--aprendizado" public/pt-br/posts/index.html && echo BADGE-PT-OK
grep -q "min de leitura" public/pt-br/posts/index.html && echo READTIME-PT-OK
grep -q "site-badge--aprendizado" public/en/posts/index.html && echo BADGE-EN-OK
grep -q "min read" public/en/posts/index.html && echo READTIME-EN-OK
grep -q "site-post-item__arrow" public/pt-br/posts/index.html && echo ARROW-OK
```

Expected: todos os `*-OK`.

- [ ] **Step 5: Commit**

```bash
git add layouts/_partials/post-meta.html layouts/blog/list.html assets/css/custom.css
git commit -m "feat(ui): custom post list with type badges and reading time"
```

---

### Task 6: Página de artigo — header com meta + tipografia de leitura

**Files:**
- Create: `layouts/blog/single.html` (override do Hextra — base: `<scratchpad>/hextra/layouts/blog/single.html`)
- Modify: `assets/css/custom.css`

**Interfaces:**
- Consumes: partial `post-meta.html` com assinatura `(dict "page" . "showReadingTime" true)` (Task 5); tokens CSS (Task 4).
- Produces: classe `site-article-content` no wrapper do conteúdo e `site-article-meta` no header — a Task 7 usa `.site-article-meta` como detector de página de artigo no JS.

- [ ] **Step 1: Criar o override do single**

`layouts/blog/single.html` (mudanças vs. tema: bloco de data/autores substituído pelo partial `post-meta.html`; classe extra no `.content`; suporte a `authors` removido — o site não usa):

```html
{{ define "main" }}
  <div class="hx:mx-auto hx:flex hextra-max-page-width">
    {{ partial "sidebar.html" (dict "context" . "disableSidebar" true "displayPlaceholder" true) }}
    {{ partial "toc.html" . }}
    <article class="hx:w-full hx:break-words hx:flex hx:min-h-[calc(100vh-var(--navbar-height))] hx:min-w-0 hx:justify-center hx:pb-8 hx:pr-[calc(env(safe-area-inset-right)-1.5rem)]">
      <main id="content" class="hx:w-full hx:min-w-0 hextra-max-content-width hx:px-6 hx:pt-4 hx:md:px-12">
        {{ partial "breadcrumb.html" (dict "page" . "enable" true) }}
        {{ if .Title }}
        <div class="hx:flex hx:flex-col hx:sm:flex-row hx:items-start hx:sm:items-center hx:sm:justify-between hx:gap-4 hx:mt-2">
          <h1 class="site-article-title hx:mb-0 hx:text-4xl hx:font-bold hx:tracking-tight">{{ .Title }}</h1>
          {{ partial "components/page-context-menu" . }}
        </div>
        {{ end }}
        <div class="site-article-meta">
          {{ partial "post-meta.html" (dict "page" . "showReadingTime" true) }}
        </div>
        <div class="content site-article-content">
          {{ .Content }}
        </div>
        {{- partial "components/last-updated.html" . -}}
        {{- if (site.Params.blog.article.displayPagination | default true) -}}
          {{- .Store.Set "reversePagination" (.Params.reversePagination | default true) -}}
          {{- partial "components/pager.html" . -}}
        {{ end }}
        {{- partial "components/comments.html" . -}}
      </main>
    </article>
  </div>
{{ end }}
```

- [ ] **Step 2: CSS do header e tipografia de leitura**

Adicionar em `assets/css/custom.css`:

```css
/* Article page */
.site-article-title {
  font-family: "IBM Plex Serif", Georgia, serif;
  line-height: 1.2;
  letter-spacing: -0.01em;
}

.site-article-meta {
  margin: 1rem 0 3rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid var(--site-border);
}

/* Reading typography — Stripe-like breathing room, ~68ch measure */
.site-article-content {
  max-width: 68ch;
}

.site-article-content p,
.site-article-content li {
  font-size: 1.0625rem;
  line-height: 1.75;
}

.site-article-content h2 {
  margin-top: 2.75rem;
}

.site-article-content h3 {
  margin-top: 2rem;
}

.site-article-content blockquote {
  border-left: 3px solid rgb(255 183 77 / 0.5);
  font-style: normal;
  color: var(--site-muted);
}
```

- [ ] **Step 3: Build + asserts**

```bash
hugo --gc --minify
grep -q "site-article-meta" public/pt-br/posts/bem-vindo/index.html && echo META-OK
grep -q "site-badge--aprendizado" public/pt-br/posts/bem-vindo/index.html && echo BADGE-OK
grep -q "min de leitura" public/pt-br/posts/bem-vindo/index.html && echo READTIME-OK
grep -q "site-article-content" public/pt-br/posts/bem-vindo/index.html && echo CONTENT-OK
grep -q "min read" public/en/posts/bem-vindo/index.html && echo EN-OK
```

Expected: todos os `*-OK`.

- [ ] **Step 4: Commit**

```bash
git add layouts/blog/single.html assets/css/custom.css
git commit -m "feat(ui): article header with type badge and reading typography"
```

---

### Task 7: Barra de progresso de leitura

**Files:**
- Modify: `layouts/_partials/custom/head-end.html`
- Modify: `assets/css/custom.css`

**Interfaces:**
- Consumes: classe `.site-article-meta` (Task 6) como detector de página de artigo.
- Produces: elemento `.site-reading-progress` injetado via JS somente em páginas de artigo.

- [ ] **Step 1: Adicionar o script ao head-end.html**

`layouts/_partials/custom/head-end.html` — conteúdo completo (mantém a linha `js-ready` existente):

```html
<script>
  document.documentElement.classList.add("js-ready");
</script>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    if (!document.querySelector(".site-article-meta")) return;
    var bar = document.createElement("div");
    bar.className = "site-reading-progress";
    bar.setAttribute("aria-hidden", "true");
    document.body.appendChild(bar);
    var update = function () {
      var doc = document.documentElement;
      var max = doc.scrollHeight - doc.clientHeight;
      bar.style.width = (max > 0 ? (doc.scrollTop / max) * 100 : 0) + "%";
    };
    document.addEventListener("scroll", update, { passive: true });
    window.addEventListener("resize", update, { passive: true });
    update();
  });
</script>
```

(Sem JS a barra simplesmente não existe — degradação limpa, conforme spec.)

- [ ] **Step 2: CSS da barra**

Adicionar em `assets/css/custom.css`:

```css
/* Reading progress bar */
.site-reading-progress {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 60;
  height: 3px;
  width: 0;
  background: var(--site-accent);
  transition: width 80ms linear;
}
```

- [ ] **Step 3: Build + asserts**

```bash
hugo --gc --minify
grep -q "site-reading-progress" public/pt-br/posts/bem-vindo/index.html && echo JS-OK
grep -q "site-article-meta" public/pt-br/index.html && echo HOME-HAS-ARTICLE-META || echo HOME-CLEAN
find public -name '*.css' | xargs grep -l 'site-reading-progress' && echo CSS-OK
```

Expected: `JS-OK`, `HOME-CLEAN` (a home NÃO deve ter `.site-article-meta` — garante que a barra só aparece em artigo) e `CSS-OK`.

- [ ] **Step 4: Commit**

```bash
git add layouts/_partials/custom/head-end.html assets/css/custom.css
git commit -m "feat(ui): reading progress bar on article pages"
```

---

### Task 8: Refinos de micro-interação (TOC, âncoras, reduced-motion)

O Hextra já implementa TOC active-state (classe `hextra-toc-active` via `toc-scroll.js`), âncoras de heading (`.subheading-anchor`) e feedback do botão copy. Esta task só estiliza por cima e consolida o bloco `prefers-reduced-motion` com tudo que foi criado.

**Files:**
- Modify: `assets/css/custom.css`

**Interfaces:**
- Consumes: tokens CSS (Task 4); classes criadas nas Tasks 5–7.
- Produces: nada consumido por outras tasks (task final de estilo).

- [ ] **Step 1: TOC active-state e âncoras**

Adicionar em `assets/css/custom.css`:

```css
/* TOC active state (class applied by Hextra's toc-scroll.js) */
.hextra-toc a {
  transition: color var(--site-duration) var(--site-ease);
}

.hextra-toc .hextra-toc-active {
  color: var(--site-accent);
  font-weight: 600;
}

/* Heading anchors — theme shows them on hover; tint with accent */
.subheading-anchor::after {
  color: rgb(255 183 77 / 0.75) !important;
  transition: opacity var(--site-duration) var(--site-ease);
}
```

- [ ] **Step 2: Consolidar o bloco reduced-motion**

Substituir o bloco `@media (prefers-reduced-motion: reduce)` existente no fim do arquivo por:

```css
@media (prefers-reduced-motion: reduce) {
  .site-hero,
  .site-404,
  .hextra-card,
  .hextra-nav-container a,
  .hextra-sidebar-container a,
  .hextra-toc a,
  .content a:not(.hextra-card),
  .site-404__action,
  .site-post-item__arrow,
  .site-reading-progress,
  .subheading-anchor::after,
  .hextra-code-copy-btn {
    animation: none;
    transition: none;
  }

  .hextra-card:hover,
  .site-404__action:hover {
    transform: none;
  }

  .site-post-item__arrow {
    opacity: 1;
    transform: none;
  }
}
```

(Nota: a seta da lista fica sempre visível sob reduced-motion em vez de aparecer animada.)

- [ ] **Step 3: Build + assert**

```bash
hugo --gc --minify
find public -name '*.css' | xargs grep -l 'hextra-toc-active' && echo TOC-OK
find public -name '*.css' | xargs grep -l 'prefers-reduced-motion' && echo MOTION-OK
```

Expected: `TOC-OK` e `MOTION-OK`.

- [ ] **Step 4: Commit**

```bash
git add assets/css/custom.css
git commit -m "feat(ui): toc active state, anchor tint, consolidated reduced-motion"
```

---

### Task 9: Verificação final

**Files:**
- Nenhuma modificação esperada (só correções se algo falhar).

**Interfaces:**
- Consumes: tudo acima.
- Produces: evidência de verificação para o relatório final.

- [ ] **Step 1: Build limpo do zero**

```bash
rm -rf public && hugo --gc --minify
```

Expected: zero erros e zero warnings.

- [ ] **Step 2: Suite completa de asserts**

```bash
set -e
grep -q "Escrevo pra entender o que aprendi." public/pt-br/index.html
grep -q "I write to understand what I learned." public/en/index.html
grep -q "Um post por vez." public/pt-br/index.html
grep -q "site-badge--aprendizado" public/pt-br/posts/index.html
grep -q "site-badge--aprendizado" public/en/posts/index.html
grep -q "min de leitura" public/pt-br/posts/bem-vindo/index.html
grep -q "min read" public/en/posts/bem-vindo/index.html
grep -q "site-reading-progress" public/pt-br/posts/bem-vindo/index.html
grep -q "Essa página não existe." public/pt-br/404.html
! grep -rq "data-empty-hint" public/
! grep -rq "rota não mapeada" public/
echo ALL-OK
```

Expected: `ALL-OK`.

- [ ] **Step 3: Servidor local para inspeção visual**

```bash
hugo server -D --bind 0.0.0.0 --baseURL http://localhost:1313/ &
sleep 3
curl -s http://localhost:1313/pt-br/ | grep -q "Diário técnico" && echo SERVER-OK
kill %1
```

Expected: `SERVER-OK`.

- [ ] **Step 4: Checklist manual para o usuário (reportar, não executar)**

Itens que exigem olho humano — listar no relatório final para o usuário conferir em `./scripts/dev.sh server`:
1. Home pt-br e en: hero novo, cards com subtitles novos, light por padrão.
2. `/pt-br/posts/`: item com data + badge + título + resumo + tempo; seta desliza no hover.
3. Artigo bem-vindo: badge no header, barra de progresso ao rolar, âncora `#` no hover de heading.
4. TOC destaca seção ativa ao rolar (em artigo com headings suficientes).
5. Navegação por Tab: focus rings âmbar visíveis.
6. DevTools → emular `prefers-reduced-motion`: sem animações, seta da lista sempre visível.
7. Dark mode via toggle: badges e sombras legíveis.
8. 404 (URL inexistente): textos novos.

---

## Self-Review (executado na escrita do plano)

1. **Spec coverage:** Seção 1 (light-first, tipografia, sombras) → Tasks 2/4/6. Seção 2 (lista+badges, archetype) → Tasks 3/5. Seção 3 (progresso, header, âncoras, TOC, prev/next) → Tasks 6/7/8 (prev/next já nativo do tema, estilizado pelo hover padrão + tokens). Seção 4 (focus, timing, copy, reduced-motion) → Tasks 4/8. Seção 5 (microcopy PT+EN) → Task 2. Degradação (sem postType/sem JS/reduced-motion) → Tasks 5/7/8.
2. **Placeholder scan:** sem TBD/TODO; todo step de código tem o código.
3. **Type consistency:** `post-meta.html` chamado com `(dict "page" . "showReadingTime" true)` nas Tasks 5 e 6; classes `site-*` consistentes entre templates (Tasks 5–7) e CSS (Tasks 5–8); chaves i18n definidas na Task 2 = chaves usadas na Task 5 (`postType_%s`, `readingTime`).
