# Redesign de leitura — estilização, micro-interações e microcopy

**Data:** 2026-07-03
**Status:** aprovado em brainstorming, aguardando plano de implementação

## Contexto

Blog Hugo + Hextra (v0.12.3), bilíngue (pt-br default, en), publicado em
carvalhosauro.github.io. Conteúdo planejado: aprendizados técnicos, opiniões e
conteúdos condensados (resumos). Já existe uma base de customização
(`assets/css/custom.css`, hero shortcode, footer/head partials, microcopy em
`hugo.yaml` e `i18n/*.yaml`).

## Decisões de direção

- **Referências visuais:** Fidelissauro/TabNews (clareza técnica, densidade) +
  Stripe/Linear (polimento, espaçamento, hierarquia).
- **Light mode first:** light é o modo primário de design; dark é derivado.
  Default do tema muda de `system` para `light` (toggle permanece).
- **Tom de microcopy:** voz do texto de referência
  `~/docs/habits/BLOG/2026-06-17--my-workflow-w-ai/index.md` — primeira pessoa,
  confessional, direto, aforismos secos, gíria dev natural, humor
  autodepreciativo contido. Sem piada forçada de git/CI, sem gimmick.
- **Escopo:** redesign de leitura — polimento + layouts customizados (lista de
  posts, página de artigo), sem trocar de tema.

## Objetivos

1. Leitura confortável e hierarquia impecável (padrão Stripe) mantendo
   densidade de conteúdo (padrão TabNews).
2. Leitor identifica o tipo de conteúdo antes de clicar (badges).
3. Micro-interações sutis e consistentes, com acessibilidade
   (`focus-visible`, `prefers-reduced-motion`).
4. Microcopy inteiro (PT + EN) na voz definida.

## Não-objetivos

- Trocar tema ou reescrever layouts do Hextra além dos pontos listados.
- Sistema de comentários, newsletter, analytics.
- Novas seções de conteúdo ou mudança de estrutura de menu.

## Seção 1 — Fundação visual (light-first)

- Superfície clara quente `#fffdf8` mantida; revisar contraste de texto muted
  para AA no light.
- Sombras suaves em camadas (estilo Stripe) em vez de sombra única pesada.
- Dark mode revisado como derivado: mesmos tokens, valores ajustados.
- `hugo.yaml`: `params.theme.default: light`.
- Tipografia: IBM Plex Sans/Serif/Mono mantidas. No corpo do artigo:
  `font-size 1.0625rem`, `line-height 1.75`, medida máx. ~68ch. Headings serif
  com margem superior generosa (respiro entre seções).
- Accent único: âmbar (hue 32) — sem segunda cor de marca.

## Seção 2 — Listagem de posts + badges por tipo

- Override do template de lista de blog do Hextra (espelhar caminho do tema;
  caminhos exatos verificados na fase de plano contra Hextra v0.12.3).
- Item da lista: data (mono, curta) + badge do tipo + título (serif) + resumo
  + tempo de leitura.
- Front matter novo: `postType: aprendizado | opiniao | resumo` (slugs sem
  acento; rótulo exibido vem de i18n). Post sem `postType` → sem badge, layout
  não quebra. Nota: `type` é front matter reservado do Hugo (altera o lookup
  de template), por isso `postType`.
- Cores de badge (dessaturadas, sóbrias):
  - `aprendizado` → âmbar
  - `opiniao` → azul-ardósia
  - `resumo` → verde-musgo
- Hover do item: sublinhado no título + seta com deslize sutil. Sem card-lift.
- Archetype de post atualizado para incluir `type`.

## Seção 3 — Página de artigo

- Barra de progresso de leitura: fixa no topo, 2–3px, cor accent, JS vanilla
  (~10 linhas) em `head-end.html` ou script dedicado. Sem JS → não aparece,
  nada quebra. `prefers-reduced-motion` → sem transição animada.
- Header do artigo: badge do tipo + data + tempo de leitura
  (`.ReadingTime`, rótulo via i18n: "X min de leitura" / "X min read").
- Âncoras de heading (`#`) visíveis apenas no hover do heading — o Hextra já
  implementa (`.subheading-anchor`); refinar cor/transição via CSS.
- TOC: active-state com transição suave de cor — o Hextra já aplica a classe
  `hextra-toc-active` via `toc-scroll.js`; estilizar via CSS.
- Prev/next no fim do artigo com título completo do post vizinho — o
  `components/pager.html` do Hextra já faz isso; só estilo.
- Busca vazia: usar a chave i18n `noResultsFound` do Hextra. O mecanismo
  atual (`data-empty-hint` + chave `searchEmpty`) é código morto — remover.

## Seção 4 — Micro-interações

- `:focus-visible` ring consistente (accent, offset 2px) em links, botões,
  cards, toggle, busca.
- Timing padronizado: 150–220ms, um único easing
  (`cubic-bezier(0.2, 0.8, 0.2, 1)`) via custom property.
- Botão copy de código: feedback visual de confirmação ao copiar (estado
  check já suportado pelo Hextra; garantir transição).
- Tudo coberto por `@media (prefers-reduced-motion: reduce)`.

## Seção 5 — Microcopy (PT + EN)

Voz: primeira pessoa, honesta, direta. Autodepreciação contida. EN espelha a
voz, não traduz literalmente.

| Onde | PT | EN |
|---|---|---|
| Hero eyebrow | Diário técnico | Tech journal |
| Hero título | Escrevo pra entender o que aprendi. | I write to understand what I learned. |
| Hero subtítulo | Aprendizados, opiniões e resumos do que estou estudando. Sem fingir que sei mais do que sei. | Learnings, opinions, and digests of what I'm studying. No pretending I know more than I do. |
| Explore title | Por onde começar | Start here |
| 404 título | Essa página não existe. | This page doesn't exist. |
| 404 mensagem | Talvez o link envelheceu, talvez eu tenha quebrado alguma coisa. Provavelmente fui eu. | Maybe the link aged, maybe I broke something. Probably me. |
| 404 ação | Voltar pro início | Back to start |
| Footer tagline | Um post por vez. | One post at a time. |
| Footer aside | Escrito por mim, revisado por mim. Os erros também são meus. | Written by me, reviewed by me. The mistakes are mine too. |
| Busca vazia | Nada por aqui. Ou escrevi pouco, ou o termo é outro. | Nothing here. Either I wrote too little, or try another term. |
| Read more | Continuar lendo | Keep reading |
| Tempo de leitura | {n} min de leitura | {n} min read |
| Badge aprendizado | aprendizado | learning |
| Badge opiniao | opinião | opinion |
| Badge resumo | resumo | digest |

Textos ficam onde já estão hoje: `params.microcopy` por idioma em `hugo.yaml`
e chaves em `i18n/pt-br.yaml` / `i18n/en.yaml` (badges e tempo de leitura
entram no i18n, pois são usados em templates).

## Arquivos afetados (estimativa)

- `assets/css/custom.css` — tokens, tipografia de leitura, badges, lista,
  progresso, focus rings, motion.
- `hugo.yaml` — `theme.default: light`, microcopy novo por idioma.
- `i18n/pt-br.yaml`, `i18n/en.yaml` — chaves novas (badges, tempo de leitura,
  read more) + reescrita das existentes.
- `layouts/` — override da lista de blog, header de artigo, prev/next
  (caminhos exatos do Hextra v0.12.3 definidos no plano).
- `layouts/_partials/custom/head-end.html` — JS da barra de progresso.
- `layouts/404.html` — já usa i18n; só textos mudam.
- `archetypes/` — `type` no front matter de post.
- `content/*/posts/bem-vindo/index.md` — ganha `type` para servir de exemplo.

## Tratamento de erros / degradação

- Post sem `postType`: sem badge, sem erro de build.
- `postType` desconhecido: badge neutra (cinza), sem cor especial.
- Sem JS: sem barra de progresso, resto intacto.
- `prefers-reduced-motion`: animações e transições desligadas.

## Teste / verificação

- `hugo build` limpo nos dois idiomas.
- Servidor local: conferir home, lista, artigo, 404, busca vazia em pt-br e
  en, light e dark.
- Checar focus rings via navegação por teclado.
- Simular `prefers-reduced-motion` no devtools.
