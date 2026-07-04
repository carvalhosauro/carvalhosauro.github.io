---
title: "Bem-vindo ao blog"
date: 2026-07-03
draft: false
translationKey: welcome
tags: ["meta", "hugo"]
description: "Primeiro post — bootstrap do blog com Hugo, Hextra e i18n."
---

Este é o primeiro artigo do blog — a **fundação** de algo que quero levar a referência técnica.

O site está configurado com:

- **Hugo** como gerador estático
- **Hextra** como tema
- **i18n** em português e inglês
- **GitHub Actions** para deploy no GitHub Pages

Para criar um novo post:

```bash
hugo new content posts/meu-artigo/index.md --lang pt-br
hugo new content posts/my-article/index.md --lang en
```

Tradução em inglês: use o mesmo `translationKey` em `content/en/posts/...`.
