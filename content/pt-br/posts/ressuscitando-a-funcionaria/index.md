---
title: "Vou ressuscitar a FuncionárIA"
date: 2026-11-02
draft: false
postType: "aprendizado"
translationKey: "funcionaria-revival"
tags: ["produto", "ia", "pigz", "funcionaria", "planejamento"]
description: "Poucos clientes, quase nenhum pagando e nada além de bug-fix. A FuncionárIA da Pigz estava morta, e eu assumi trazer ela de volta. Por que ela morreu, como planejei, onde estou e o número que ainda me falta."
---

> Poucos clientes desde o lançamento.
> Quase nenhum pagando.
> O último update relevante, eu nem lembro.

A FuncionárIA é a IA da Pigz pro lojista. A ideia é minha, e eu acho esse produto muito foda. Só que produto que ninguém usa e ninguém evolui está morto, mesmo com o servidor ligado.

O que eu aprendi tentando entender por que ela morreu: produto não morre de bug. Morre quando para de receber resposta do mundo.

Este post é o registro de como eu vou tentar trazer ela de volta. Escrevo agora, no meio do caminho, porque daqui a três meses eu vou contar essa história de um jeito mais bonito do que ela foi.

---

## Como ela morreu

A FuncionárIA tem duas frentes. A **Vendedora**, que vende pelo WhatsApp, 100% conversacional. E a **assistente**, que tira dúvida do lojista sobre a própria loja.

A minha leitura é que o primeiro tropeço foi preço. Restaurante conta margem no centavo, e o valor estava alto demais pra quem só queria testar uma IA.

Depois disso o ciclo fecha sozinho. Pouco cliente, pouco feedback. Sem feedback, ninguém sabe o que melhorar. Sem saber o que melhorar, ela não vira prioridade. E sem prioridade, o histórico virou uma fila de correção: bug-fix, bug-fix, bug-fix. Nenhuma funcionalidade nova que mudasse a vida do lojista.

O pedido que ela não sabia atender virava uma linha num JSON que ninguém abria. A FuncionárIA estava perguntando o que fazer, e não tinha ninguém escutando.

Ela ficou sem dono. Ninguém puxou. Então eu puxei.

## Por que eu assumi

A Pigz quer apostar mais em IA, e eu tinha um produto parado que eu sabia que podia ser muito mais.

Mas o que me fez pegar de verdade foi uma pergunta. Fui olhar o que o mercado faz, e o padrão é claro: o copiloto vem incluso no plano. Toast IQ, Shopify Sidekick, a Cris do iFood, grátis pelo WhatsApp pros parceiros. O que se cobra é o trabalho pesado ou autônomo.

Então a pergunta deixou de ser "quanto cobrar pela IA" e virou: **como cobrar sem que a pergunta simples do lojista pareça uma piora perto do concorrente que dá de graça?**

A minha aposta, por enquanto, é crédito com peso. Toda ação gasta crédito, ação mais complexa gasta mais, e cada rede recebe um saldo semanal grande o bastante pra quem só pergunta nunca sentir o limite. Quem usa muito o trabalho pesado (relatório personalizado, análise, aviso automático) chega no fim e aí, sim, faz upgrade. O básico nunca para por causa do pesado.

E o motivo pra alguém pagar em vez de usar a Cris de graça não pode ser a IA em si. Tem que ser o que ela enxerga. A Cris vê o canal do iFood. A FuncionárIA pode ver a operação inteira: PDV, comanda, caixa, delivery próprio, estoque.

Ainda é hipótese. O piloto existe pra testar justamente isso.

## Começar pelo problema medido

Muito do jeito que eu montei esse plano veio de assistir o [Product Gurus](https://www.youtube.com/@productgurus). Duas ideias de lá viraram regra aqui: atacar primeiro o que tira trabalho de alguém, e lançar uma fatia estreita pra aprender com uso real em vez de esperar o produto completo.

O "alguém", no caso, era o suporte. Eu comecei conversando com o pessoal do atendimento, e a mesma história aparecia toda hora: lojista pedindo pra mudar preço, pausar item, trocar descrição. Coisa que ele mesmo podia fazer, mas pedia.

Aí fui medir. Peguei dois meses de conversas do suporte e separei por assunto. Mais de uma em cada dez era o lojista pedindo pra mudar alguma coisa na loja. Só cardápio (preço, pausar, reativar, cadastrar) era quase uma em cada dez.

O detalhe que me pegou: nos chamados esses pedidos quase não aparecem. Eles se resolvem no primeiro atendimento e nunca escalam. Se eu tivesse olhado só os chamados, ia concluir que o problema não existe.

É o mesmo erro que matou a FuncionárIA, visto do outro lado. A demanda estava lá. Só não estava onde a gente olhava.

Daí saiu a primeira decisão de produto, e a fatia estreita: **a FuncionárIA volta mudando o cardápio pela conversa**. A página nova, o painel e o resto só vão ao ar junto com isso. Sem isso, ela seria só mais uma tela de chat bonita.

## O que ela não pode fazer

Uma IA mexendo no cardápio de um restaurante em produção é risco de verdade. Preço errado é prejuízo no mesmo dia. Então, antes dos objetivos, escrevi os anti-objetivos: as coisas que, se acontecerem, deu errado mesmo "funcionando".

- Mudar o cardápio sem o lojista ver o antes e o depois e clicar em Confirmar.
- O modelo executar qualquer coisa. Ele só propõe. Quem executa é a API, a partir de uma proposta guardada no servidor.
- Alteração sem rastro de quem confirmou.
- Mudar um campo que o lojista não pediu pra mudar.
- Dado de uma loja aparecendo pra outra.

E uma regra que vale pra tudo: número não vem do LLM. Lista de produtos pausados, total, faturamento, tudo sai da API. O modelo escreve a frase em volta. Se ele colocar um número que não está nos dados, a frase cai.

Essa lista pegou coisa que teste nenhum pegaria. Quando a FuncionárIA mudava o preço de um produto, o código reaproveitava uma rotina que já existia pra manter os combos sincronizados. Parecia certo. Os testes passavam. Quem pegou foi o agente de review: essa rotina reativava combos que o lojista tinha pausado. Ninguém pediu isso, e não ficava registrado em lugar nenhum.

Pela lista, isso quebrava dois anti-objetivos de uma vez. A decisão foi fácil: a rotina saiu do caminho da FuncionárIA.

Toda ideia nova passa pela mesma pergunta, nessa ordem: "isso quebra algum anti-objetivo?" antes de "isso é legal?".

## Rápido sem quebrar a lista

A FuncionárIA morreu parada. Então a pergunta que eu tinha que responder era: como andar rápido sem quebrar nenhum anti-objetivo?

Levei o plano pro CTO. Mostrei o protótipo, as specs e o que eu queria fazer: lançar em fatias, com um piloto de lojas reais, em vez de esperar o pacote inteiro ficar pronto. Ele topou.

O que tornou isso possível foi o jeito de trabalhar. Cada funcionalidade passa pelo mesmo caminho:

1. Converso com a IA até a ideia virar uma spec, com objetivos, não-objetivos e anti-objetivos.
2. A spec vira um plano por repositório.
3. Subagentes implementam uma tarefa de cada vez.
4. Um agente revisa cada tarefa antes da próxima começar. No fim, outro revisa a branch inteira.
5. Eu decido e faço o commit.

Foi assim que, em pouco mais de dez dias, saíram oito specs com os planos de cada uma. E foi esse passo 4 que pegou o combo sendo reativado sem ninguém pedir.

O cuidado não sumiu pra eu andar rápido. Ele mudou de lugar: saiu da fila de aprovação e foi pra lista de anti-objetivos e pra revisão de cada entrega.

## Onde estou agora

A primeira fatia está em homologação: a página própria da FuncionárIA, uma pílula no topo de todas as telas da loja e a mudança de cardápio pela conversa. Preço de um produto ou de vários, pausar, reativar, nome e descrição. Sempre com prévia, confirmação e desfazer.

O resto está desenhado e planejado, e a ordem não é por qual funcionalidade é mais legal. É por qual faz ela escutar primeiro.

Primeiro vem o **pedido não atendido**. Aquele JSON que ninguém abria vira um registro com tema e contagem por loja, numa tela que o time consegue triar. Depois, 👍 e 👎 em cada resposta, com o motivo. E o registro de uso e custo de cada chamada de IA, por loja, com um teto semanal de créditos. Esse último já está em construção.

Só depois disso vêm criar produto pelo chat (inclusive só pela foto), listar produtos, checar a configuração da loja e, por último, insights. Insight é o mais caro e o único em que um número errado machuca de verdade.

## O que está pendente

Duas perguntas que eu ainda não sei responder: **o lojista usa?** e **quanto custa?**

Pra isso existe o piloto. Algumas dezenas de lojas, em três perfis (delivery, salão e autoatendimento, rede), por uma ou duas semanas. Pra começar, falta terminar o registro de custo e o teto de créditos, e escolher as lojas.

## Até onde eu quero chegar

Aqui eu vou ser honesto: não defini meta além do que está nas specs.

Eu sei o que eu quero ver. O lojista resolvendo sozinho, conversando, o que hoje ele pede pro suporte. Menos "muda o preço do X-Salada pra mim" na caixa de ajuda. Mais loja pagando porque usa, não porque ganhou desconto.

Transformar isso em número e prazo é uma coisa que eu ainda estou aprendendo. O piloto vai me dar a linha de base. Sem ela, qualquer meta que eu escrever aqui é chute.

Nem o critério pra desistir eu tenho ainda. E isso me incomoda mais do que não ter meta, porque foi exatamente a falta dele que deixou a FuncionárIA morrer devagar da primeira vez. Ninguém olhou e disse "acabou". Ela só foi parando.

Então esse é o primeiro número que eu vou tirar do piloto. Não o de sucesso. O de desistir.

> Da primeira vez, ela morreu sem ninguém perceber.
> Se morrer de novo, vai ser com número na mesa.
