---
title: "Tela bonita não é feature pronta"
date: 2026-09-24
draft: false
postType: "aprendizado"
translationKey: "nao-e-so-tela-bonita"
tags: ["react-native", "mobile", "ios", "performance", "debito-tecnico", "ia"]
description: "Primeira feature num app React Native, uma stack que eu não conhecia, e uma caçada a travadas num sistema de balcão. Nos dois casos a tela estava bonita e o teste estava verde. E nos dois casos travava na mão de quem usa."
---

> Eu tratava performance como sobremesa.
> Primeiro fazia funcionar, depois, se sobrasse tempo, fazia rápido.
> Nunca sobrou tempo. E o cliente nunca esperou.

Vou começar com a frase que eu gostaria de ter ouvido uns anos atrás: **se trava na máquina do cliente, não funciona**. Não importa se passou no review, se o teste está verde, se ficou idêntico ao Figma. O cliente não abre o seu código. Ele abre a tela, toca, e espera. Se ela não responde, pra ele o sistema está quebrado, e ele está certo.

Nas últimas semanas eu apanhei disso de dois lados ao mesmo tempo.

De um lado, minha primeira feature no App da empresa. React Native, uma stack que eu nunca tinha colocado em produção. De outro, o Gestão, o sistema que fica no balcão das lojas, travando em loja que chega perto de mil pedidos em poucas horas. Travando em computador OK, não em carroça.

São dois assuntos diferentes, com a mesma lição. Não é tutorial de nada. É o relato de quem saiu da própria caixinha e descobriu que a tela bonita era a parte fácil.

---

## O App: o iOS não quer saber se você é novo na stack

A feature era a avaliação de pedido. O pedido chega, o app pergunta como foi. Estrelas, um rostinho que muda com a nota, umas tags pra escolher, comentário obrigatório quando a nota é baixa, um agradecimento no fim. No Figma, uma tela e meia. Na branch, uns 120 commits em dez dias.

E a maior parte desses commits não é tela.

### O teclado que comia o botão

No Android, quando o teclado abre, a tela encolhe e o botão "Enviar avaliação" sobe junto. Eu testava no Android, dava certo, e ia pra próxima.

No iOS não. O teclado abria por cima do botão. O usuário escrevia o comentário inteiro e não tinha como enviar. Uma tela linda que não deixava fazer a única coisa que ela existia pra fazer.

Corrigi o botão, e aí o campo de comentário é que ficou escondido. Corrigi o campo, e a tecla de "enter" do iOS resolveu quebrar linha em vez de enviar. Cada correção abria a próxima. Nada disso aparece quando você testa num aparelho só.

E teve o build. Uma atualização do Xcode simplesmente parou de compilar o projeto, e quem destravou foi um colega. Registro porque é verdade e porque é exatamente o tipo de coisa que eu ainda não tenho no sangue. E o iPhone 8, o aparelho fraco, que é justamente o que importa pra medir, nem aceitava instalar pelo caminho normal.

### As ferramentas mentem, e mentem em silêncio

Isso foi o que mais me pegou, vindo de web e backend.

A checagem de tipos do projeto terminava sem erro nenhum. Parece limpo, né? Não checava nada. Estava quebrada e ninguém tinha percebido, porque silêncio parece sucesso. Um mock nos testes se comportava diferente da biblioteca de verdade, e o teste passava por um caminho que o app real nunca percorre. E medir performance em modo de desenvolvimento dá número inflado: em outra entrega, a gente perdeu horas olhando pra números que não valiam nada.

Três vezes em dez dias a evidência verde mentiu pra mim. Depois da terceira eu parei de confiar em verde por padrão.

### Linda e travando

Aí chega a parte que dá nome ao texto. A tela estava bonita. E travava.

Cada letra que o usuário digitava no comentário fazia o app redesenhar a tela inteira, estrelas incluídas. Em aparelho fraco, digitar engasgava. No cardápio da loja, marcar um filtro travava o app por **quase meio segundo**, medido no aparelho. Uma aba disparava 12 requisições que ninguém pediu. A lista buscava a mesma página três, quatro vezes quando o usuário rolava rápido, e mostrava card duplicado.

Tudo resolvido, e nada disso está no Figma. É justamente o que o usuário sente na mão.

### Como medi sem ter o aparelho do lado

Sendo transparente sobre o método: eu buildava no macOS, baixava os arquivos de profiling e trazia pra cá pra analisar junto com a IA. Uma parte do diagnóstico foi leitura de perfil, outra foi leitura de código, e uma parte, confesso, foi no feeling. Uma das correções entrou assim, e o commit diz com todas as letras que o ganho ainda precisa ser confirmado em campo.

Escrever no commit o que eu **não** medi virou regra.

---

## O Gestão: um débito que cobrava juros a cada 15 segundos

Enquanto isso, no balcão.

O relato era vago do jeito que relato de cliente sempre é: "a tela engasga quando chega pedido" e "de vez em quando trava, mesmo parada". Parece pouco até você imaginar o operador olhando pra uma tela congelada no meio do movimento. E em loja de alto volume, perto de mil pedidos num turno, travava mesmo em computador bom.

A resposta preguiçosa estava pronta: "o computador do cliente é fraco". Eu já usei essa desculpa. Dessa vez fui medir antes.

### Medir antes de mexer em qualquer coisa

Montei um ambiente que simula uma máquina de balcão fraca e lojas de teste com volume crescente, de zero até 1.800 pedidos. Foram nove rodadas de medição. Nenhuma otimização entrou sem número de antes e depois.

Se você otimiza sem medir, está chutando com mais confiança.

### O culpado não era o que aparecia

O sistema demorava pra abrir, e todo mundo olhava pra isso. Mas o que mais doía no balcão era uma coisa bem mais quieta.

A cada 15 segundos, mesmo com a tela parada, e a cada pedido novo, o sistema salvava no navegador **o catálogo inteiro da loja e a lista inteira de pedidos**. Quase 2MB gravados de uma vez, e enquanto gravava, a tela congelava. O dia inteiro.

Débito técnico no sentido mais literal que eu já vi. Ninguém errou. Quando o sistema tinha pouco dado, isso não fazia diferença. O sistema cresceu e a configuração ficou lá, cobrando juros a cada 15 segundos, de todo mundo.

A correção de maior impacto do projeto inteiro foi **uma linha**: parar de salvar o catálogo. O que era gravado caiu de ~1,7MB pra ~150KB.

Uma linha. E um débito antigo pra caramba.

Depois veio a faxina: o sistema carregava praticamente o app inteiro na primeira tela, inclusive telas que o usuário nem ia abrir. Tinha 8MB de imagem de tutorial embutida no código, sendo lida como se fosse programa. Uma animação de loading gastava CPU justamente na hora de abrir. Cada uma dessas saiu.

### O cache que atrasava

Esse é o meu achado favorito.

Existia um cache da lista de pedidos, feito justamente pra abrir mais rápido. Medi. **Sem cache nenhum, a lista aparecia 3,3 segundos mais rápido.**

O cache que existia pra acelerar estava atrasando, e ninguém sabia porque ninguém tinha medido. Todo mundo "sabia" como aquilo funcionava. É o mesmo buraco que eu contei no [texto sobre monitoramento](/pt-br/posts/eu-corrigia-e-torcia-agora-monitoro/), só que em outro lugar.

### Os mil pedidos

Pra loja de alto volume o problema era outro: a tela montava **todos** os pedidos de uma vez, mesmo os que não cabiam no monitor. Com 1.800 pedidos, eram 54 mil elementos na tela. A solução foi desenhar só o que está visível.

| com 1.800 pedidos | antes | depois |
|---|---|---|
| trocar de visão | 127s | 0,3s |
| atualizar um pedido | 8,9s | 0,15s |
| memória | 859MB | 358MB |

Leu direito: **127 segundos** pra trocar de visão. Em máquina simulada lenta, sim. Mesmo assim são dois minutos de tela congelada por causa de um clique.

No dia a dia, com uns 300 pedidos, as travadas longas com a tela parada foram de 52 em meio minuto pra zero.

E tinha a ideia de trocar a tecnologia base do app pra resolver a lentidão. Os números dizem que não ia resolver. **O problema era software. Não era hardware, e não era a tecnologia.** Máquina mais rápida só encurta a travada.

---

## Onde essa conta não fecha

Seria hipócrita escrever um texto inteiro sobre desconfiar de evidência e não mostrar onde a minha é fraca.

- A máquina fraca é simulada. Ainda não rodei os mesmos testes num computador de balcão de verdade, então todo número do Gestão é relativo até eu fazer isso.
- A memória quase não baixou no dia a dia. Pra cair de verdade, o app precisa carregar menos coisa, e isso é trabalho grande, não ajuste.
- O teste mais longo durou uns 20 minutos. Um turno de loja tem 12 horas. Isso eu ainda não medi.
- No App, parte do diagnóstico foi no feeling, e o comportamento do teclado no iOS só dá pra validar no aparelho.

Nada disso invalida o resto. Mas quem me lê merece saber o que é número e o que é aposta.

---

## E a IA nisso tudo

Quase todos os commits da feature mobile têm co-autoria de IA. O ambiente de medição do Gestão, as nove rodadas, a leitura dos profilings: tudo feito em par com IA.

Sem ela, eu não entregaria uma feature numa stack que não conhecia em dez dias, e muito menos rodaria nove rodadas de medição em paralelo com isso. Não tem como fingir que não.

Só que a IA não sabia o que eu queria. Eu sabia. Cada prompt tinha o problema, a métrica que ia provar a correção, o que não podia quebrar e o que eu já tinha descartado. Eu não sabia React Native, mas sabia o que é uma tela travando porque faz trabalho demais, e sabia comparar antes e depois do jeito certo. A IA traduziu a stack. O critério continuou sendo meu.

Eu já escrevi sobre isso [antes](/pt-br/posts/eu-achava-que-era-a-ferramenta-sempre-fui-eu/): a ferramenta amplifica quem está usando. Se você pede mal, ela te entrega o erro mais rápido.

---

## Chega de entregar meia boca

E aqui eu vou ser mais duro do que costumo ser.

Hoje, com IA, dá pra fazer praticamente qualquer coisa. Basta saber pedir. Eu entreguei uma feature numa stack que não conhecia e rodei nove rodadas de medição num sistema legado nas mesmas semanas. Então eu não aceito mais, nem de mim, a feature que "funciona" mas trava, a tela que fica linda no Figma e engasga no aparelho do cliente, o "depois a gente otimiza".

Eu me recuso a entregar feature que não funciona de verdade. E funcionar de verdade é funcionar na máquina do cliente, no volume do cliente, não na minha.

Só que tem um padrão que eu vejo muito, e que é inegável: dev aceitando entregar coisa meia boca, ou adiando indefinidamente. As duas coisas têm a mesma raiz. Uma entrega sem pensar, a outra pensa tanto que nunca entrega. "E se quebrar outra tela?", "e se o cliente reclamar?", "e se tiver um caso que a gente não previu?". Enquanto isso, o catálogo inteiro continuava sendo salvo de novo a cada 15 segundos. A correção era uma linha, e ficou lá sei lá quanto tempo.

Ficar eternamente pensando nas dificuldades e nos "e se" é o jeito mais garantido de manter o sistema em que você trabalha uma merda. Começa. Melhora o que dá pra melhorar hoje. Mede. Sobe.

**Se quebrar, corrige.**

Agora, se você não sabe se a sua aplicação está quebrando ou não, ou se leva mais tempo pra subir a correção do que pra escrever a correção, aí o problema é outro. Não é cautela. É incompetência. Sem monitoramento você não enxerga o erro (já contei como eu aprendi isso [do jeito difícil](/pt-br/posts/eu-corrigia-e-torcia-agora-monitoro/)), e com um deploy que demora mais que o fix, todo fix vira um evento. Nesse cenário o medo de mexer faz sentido, só que o que precisa de conserto é o processo, e ficar parado não conserta nada. O [Akita escreveu sobre isso essa semana](https://akitaonrails.com/2026/09/22/parem-de-inventar-desculpas-e-facam-mais-deploy-a-premissa-mudou/) melhor do que eu: a premissa mudou. Corrigir ficou barato. Continuar fingindo que é caro é escolha.

---

## Então, expandir horizonte

Aprender React Native foi o de menos. O que eu levei desses dias é que o mesmo problema mora em todo lugar. No celular, é o teclado cobrindo o botão e a estrela que engasga quando você digita. No balcão, é a tela congelando a cada 15 segundos pra gravar um catálogo que ninguém pediu pra gravar. Em nenhum dos dois casos a tela era feia, e em nenhum dos dois o teste estava vermelho.

Se você ainda trata performance como coisa pra depois, como eu tratava, faz o teste: pega o aparelho mais fraco que o seu cliente usa, builda em produção, e usa o seu sistema do jeito que ele usa, no volume que ele tem. Se travar, sua feature não está pronta. Ela só está bonita.

O que ficou pra mim, nos dois lados, foi um jeito de trabalhar: medir no aparelho mais fraco, em build de produção, com o mesmo estado nas duas pontas da comparação. Confirmar que o teste falha antes do fix. E escrever com todas as letras o que ainda não foi medido.
