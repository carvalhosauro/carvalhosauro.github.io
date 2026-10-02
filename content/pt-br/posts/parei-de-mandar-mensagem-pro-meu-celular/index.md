---
title: "Parei de mandar mensagem pro meu próprio celular"
date: 2026-10-01
draft: false
postType: "aprendizado"
translationKey: "whelx"
tags: ["whatsapp", "testes", "ia", "agentes", "open-source", "whelx"]
description: "Testar integração com WhatsApp exigia app na Meta, WABA, número de verdade e torcer pro webhook chegar. Usei o floci, pensei \"por que não pro WhatsApp?\", e dois dias depois o whelx existia. No primeiro dia ele achou um bug que derrubava 124 de 229 mensagens de uma campanha."
---

> Eu testava bot de WhatsApp mandando "oi" pro meu próprio celular.
> E torcendo pro webhook chegar.
> Isso não é teste. É ritual.

Quem já integrou com a WhatsApp Cloud API conhece o roteiro. Cria um app na Meta, pega um número de teste, sobe um ngrok, configura o webhook, manda mensagem pra você mesmo e fica olhando o log. Se chegou, ótimo. Se não chegou, você não sabe se o problema é no seu código, no túnel, no token ou na Meta.

Pra uma tela de chat, dá pra conviver. Pra infra de campanha, não dá.

---

## A burocracia que travava o teste

Na Pigz a gente estava evoluindo a infra de disparo de campanhas. Disparo em volume, várias lojas, cada uma com a sua conta de WhatsApp Business (a tal WABA) e os seus números.

Pra testar isso de verdade eu precisaria de:

- várias WABAs, com números de clientes reais ou de teste;
- um **segundo app na Meta só pra teste**, porque cada app tem um webhook só. Se eu apontar o webhook pro meu ambiente, produção para de receber;
- coragem pra disparar em volume sem queimar um número de verdade.

E pra provocar um erro específico? A janela de 24 horas fechada (`131047`) exige esperar 24 horas. O limite de 80 mensagens por segundo por número (`130429`) exige mandar mais de 80 mensagens por segundo num número de verdade e torcer pra Meta não sinalizar.

Ninguém testa assim. O que acontece na prática é que se testa o caminho feliz, um pouco na mão, e o resto vai pra produção na fé. Eu queria autonomia: testar o que eu quisesse, quantas vezes quisesse, sem pedir número pra ninguém e sem abrir chamado na Meta.

## A faísca

Pouco antes disso eu tinha conhecido o [floci](https://github.com/floci-io/floci). Ele faz pela AWS o que o LocalStack faz: sobe SQS, Lambda e companhia no seu computador. A própria lambda de disparo da campanha já rodava inteira em cima dele, fila FIFO, DLQ e tudo, sem tocar na AWS.

Só que a lambda falava com a Meta. E pra Meta eu tinha um mock escrito à mão, que respondia de acordo com o final do número de telefone: termina em 0400, devolve 400; termina em 0429, devolve 429. Funcionava. Ou eu achava que funcionava.

Aí veio a pergunta óbvia: se dá pra ter a AWS inteira no notebook, por que não o WhatsApp?

Dois dias depois o [whelx](https://github.com/carvalhosauro/whelx) existia.

---

## O que é o whelx

Uma cópia local e fiel da WhatsApp Cloud API. Mesmos endpoints, mesmo JSON, mesmos códigos de erro. A sua aplicação troca `https://graph.facebook.com` por `http://localhost:4000` e não percebe a diferença.

```bash
docker run -p 4000:4000 ghcr.io/carvalhosauro/whelx
```

O que tem dentro, resumindo:

- **Webhooks assinados** de verdade (`X-Hub-Signature-256`), com retry e o registro de cada entrega.
- **Status** `sent → delivered → read → failed` no formato atual da Meta.
- **Erros reais sob demanda**: `130429`, `131047`, `132001`, `131056`. A janela de 24 horas vence com um clique.
- **Limite de 80 msg/s por número** emulado: manda 200 requests, 80 passam e 120 voltam com `130429`.
- **Um chat estilo WhatsApp Web** em que *você* é o cliente. Texto, áudio, localização, botões, listas, card de pedido com Pix. Cada mensagem tem um inspetor com o JSON e os webhooks que ela gerou.
- **Caos determinístico**: webhook perdido, duplicado, fora de ordem, com seed. Mesma seed, mesmo resultado.
- **Um servidor MCP**, pra um agente de código fazer o papel do cliente.

E o que ele ainda não emula devolve erro com `whelx: not supported`. Nunca um sucesso silencioso. Isso foi decisão de projeto, e o motivo está logo abaixo.

---

## O que ele achou no primeiro dia

Coloquei a stack inteira no notebook: a API da Pigz rodando na mesma imagem de produção, a lambda de disparo no floci, e o whelx no lugar da Meta. Disparei uma campanha de ponta a ponta e deixei o agente rodando, medindo e lendo os logs.

**124 de 229 destinatários foram perdidos.**

O motivo: a função que classificava a resposta da Meta olhava só o status HTTP. Só que a Meta manda os erros de throughput, `130429` por número, `80007` por WABA e `4` por app, como **HTTP 400**, não como 429. Então todo limite de taxa virava falha permanente. Sem backoff, sem reduzir o ritmo, sem tentar de novo. O destinatário simplesmente sumia da campanha.

E o meu mock escrito à mão? Ele devolvia 429 pra simular rate limit. Ou seja, o mock concordava com o bug. Ele foi escrito com a mesma suposição errada do código, então os dois passavam juntos. Teste verde, campanha furada.

Eu já escrevi sobre isso [no texto anterior](/pt-br/posts/nao-e-so-tela-bonita/): ferramenta mente em silêncio, e verde não é prova de nada. Mock feito à mão é a versão mais traiçoeira disso, porque ele testa o que você *acha* que o serviço faz. Se você está errado sobre o serviço, o mock está errado do mesmo jeito.

Vinte minutos depois apareceu o segundo. Os limites de app e de WABA, que duram de minutos a uma hora, estavam caindo no mesmo caminho de retry do limite por número. Resultado: até 8 workers fazendo 4 tentativas cada, derrubando o ritmo da campanha pra 5 mensagens por segundo, só pra no fim adiar do mesmo jeito. Agora o primeiro hit devolve o lote pra fila e pronto.

Os dois bugs iam pra produção. Ninguém ia ver em teste manual, porque ninguém dispara 229 mensagens na mão. Ia aparecer como "a campanha não chegou pra metade da base", e alguém ia passar dias tentando entender.

---

## Agente em loop: o motivo de verdade

Isso tudo seria só uma ferramenta de teste útil. O que me deixou viciado foi outra coisa.

Um agente de código consegue ler, escrever e rodar teste de quase tudo no seu sistema. Banco ele sobe em container. Fila, agora, com o floci. A parte que sempre sobrava era o serviço externo. Pagamento, WhatsApp, e-mail. Ali o agente parava e devolvia pra você: "testa no seu celular e me diz o que aconteceu".

Com um simulador local, essa barreira some. O agente:

1. faz o papel do cliente e manda uma mensagem;
2. espera a resposta do bot (sem `sleep`, tem endpoint de espera);
3. responde, clica no botão, muda de ideia no meio;
4. liga o caos, repete, compara;
5. lê o código, corrige, roda tudo de novo.

Sem custo por conversa, sem risco de número sinalizado, sem esperar 24 horas. Ele pode ficar em loop a tarde inteira, e o pior que acontece é eu apagar o banco do whelx.

No repositório tem um bot de vendas de exemplo pra mostrar isso. Pedi pro Claude, pelo MCP do whelx, fazer o papel de três clientes: um que compra pizza com bebida, um que pergunta algo no meio do pedido e um que desiste na oferta da bebida. Ele rodou e voltou com isso:

> O caminho feliz funciona. O funil quebra quando o cliente digita uma pergunta no meio do pedido: o bot trata qualquer texto fora da saudação como desconhecido, zera o carrinho e manda o cardápio de novo. O Daniel perde a pizza quatro queijos.

O agente usou três ferramentas: mandar mensagem como contato, clicar numa opção e esperar. Ninguém mandou mensagem pro próprio celular.

## Simular o mundo é o novo teste

Eu não estou dizendo nada novo. LocalStack existe há anos. O que mudou foi quem testa.

Antes, simulador local era conforto pro dev. Agora é o que deixa um agente trabalhar sozinho. Cada serviço externo que você consegue rodar no notebook é uma parte do sistema que o agente consegue testar sem te chamar. E cada parte que ele não consegue é onde você vira o gargalo.

Por isso eu ando caçando essas ferramentas. floci pra AWS, whelx pra WhatsApp. E a regra que eu levo pra qualquer simulador, inclusive o meu: **fiel ou nada**. Um simulador que inventa o comportamento do serviço é só um mock mais caro, e eu acabei de contar o que um mock faz com você.

---

## Onde essa conta não fecha

- O whelx não substitui o teste final contra a Meta. Ele é fiel ao que está documentado e ao que eu vi em produção. A Meta muda, e ele vai atrasar.
- Nem tudo é emulado. Quando não é, ele avisa com erro em vez de fingir sucesso, mas avisar não é cobrir.
- A UI e a API de controle não têm autenticação. É ferramenta local. Não exponha a porta numa rede em que você não confia.
- Ele foi feito em dois dias, com IA. Tem teste de ponta a ponta e já pegou bug real, mas ainda é jovem.

---

## Testa aí

Se você tem um bot ou uma integração com WhatsApp, leva dois minutos:

```bash
docker run -p 4000:4000 ghcr.io/carvalhosauro/whelx
```

Aponta a sua aplicação pra `http://localhost:4000`, abre o navegador e manda um "oi". Se quiser que o seu agente teste por você:

```bash
claude mcp add --transport http whelx http://localhost:4000/_whelx/mcp
```

O código está em [github.com/carvalhosauro/whelx](https://github.com/carvalhosauro/whelx), MIT. Se ele te poupar de mandar mensagem pra você mesmo, deixa uma estrela. Se ele estiver errado sobre algum comportamento da Meta, abre uma issue. Fidelidade é a única coisa que importa num simulador, e eu prefiro saber.
