---
title: "Eu achava que era a ferramenta. Sempre fui eu."
date: 2026-06-21
draft: false
postType: "aprendizado"
translationKey: "sempre-fui-eu"
tags: ["ia", "ferramentas", "processo", "carreira"]
description: "Em pouco mais de um ano, troquei de ferramenta de IA umas seis vezes. Cada uma parecia a virada definitiva. A única coisa que precisava mudar era eu."
---

> Em pouco mais de um ano, troquei de ferramenta de IA umas seis vezes. Cada uma parecia a virada definitiva. A única coisa que, no fim, precisava mudar era eu.

Janeiro de 2025. Eu era estagiário, e a IA era uma aba a mais no meu navegador. Abria o ChatGPT, perguntava, copiava o trecho de código, colava no projeto e torcia pra funcionar. Quando funcionava, parecia mágica. Quando não, eu pedia outra resposta, colava de novo e torcia mais um pouco.

Olhando pra trás, é quase absurdo comparar aquele fluxo com o de hoje. Atualmente escrevo muito menos código manualmente e nunca me senti tão produtivo. Mas demorei pra entender uma coisa: as ferramentas melhoraram muito — e foi justamente isso que escancarou o gargalo. Quando a ferramenta era fraca, ela era o limite. Quando ficou boa, sobrou só uma coisa me limitando: eu.

Essa foi uma ideia que demorei a aceitar. Doeu admitir que o gargalo era eu. A cada fase, eu trocava de ferramenta achando que a anterior era o limite — Copilot, Cursor, Antigravity, Mythos. Cada uma parecia explicar por que eu ainda não era tão bom quanto queria. Por um tempo, me recusei a encarar a hipótese mais incômoda: talvez fosse só *skill issue*. Talvez, com a ferramenta já boa o bastante, o único gargalo que sobrava fosse o meu processo.

Este texto não é um review de ferramentas. É a história de como eu descobri isso — me empolgando, quebrando a cara, estudando e amadurecendo, uma fase de cada vez. E cada fase me ensinou um pedaço da mesma habilidade: pensar no problema antes de pedir, dar contexto, questionar se a solução é mesmo a melhor, validar o resultado e — o mais difícil — saber o que **não** delegar.

## O mapa da jornada

Não foi uma linha reta. Foi uma sequência de estados de cabeça, e a ferramenta da vez era só o cenário:

- **Inocência** — ChatGPT: a IA numa aba do navegador.
- **Empolgação** — Copilot, Windsurf e Cursor: a IA dentro do editor.
- **Escala** — Antigravity: agentes em volume, subsidiados pela empresa.
- **Obsessão** — Claude Max: orquestração com `tmux`, hooks, skills e MCPs.
- **Queda** — Mythos: o modelo mais avançado do momento.
- **Maturidade** — agora.

## Inocência: "funcionou uma vez" não é "está certo"

Naquela época, eu tinha uma régua simples pra saber se um código estava pronto: se parecia certo e passava no teste que eu fazia — um teste só, o happy path — então estava resolvido. Não me ocorria perguntar o que aconteceria fora daquele caminho feliz.

E, dentro dessa régua, o ChatGPT era incrível. Ele me salvava demais nos DTOs, por exemplo. Eu sempre esquecia uma validação, ou ficava na dúvida sobre qual usar, e ele resolvia isso numa fração do tempo que eu levaria sozinho. Pra esse tipo de coisa, o ganho era real e imediato.

O problema é que a mesma régua que me acelerava também me deixava cego. Um dia, pedi pra ele uma consulta SQL pra buscar transações por um campo específico. Colei, funcionou no meu teste, segui em frente. O que eu não contei pra ele — porque nem passou pela minha cabeça que importava — era o que tinha do outro lado: uma tabela de transações com mais de 30 milhões de linhas, um `WHERE` numa coluna sem índice e sem paginação nenhuma. Na prática, um full scan na tabela inteira a cada chamada, numa rota muito usada. No meu teste, com pouca massa de dados, voava. Dias depois, com o volume real, a CPU do banco foi ao teto e ele caiu.

Doeu. E o pior é que a culpa era minha. Não do ChatGPT, não da consulta — minha. Eu tinha pedido a coisa errada, sem dar o contexto que importava — o tamanho da tabela, a frequência da chamada — e tinha validado de menos. Eu era estagiário, sim, mas isso não muda o diagnóstico: a ferramenta fez exatamente o que eu pedi. Eu é que não sabia pedir, nem conferir.

Foi a primeira rachadura na ideia de que bastava ter a resposta. A IA me dava velocidade, mas velocidade em cima de um pedido ruim só me levava mais rápido pro buraco. O que faltava não estava no modelo. Estava em mim.

## Empolgação: a IA mudou de lugar, e o atrito caiu

Veio o hype do Copilot. Todo mundo falava dele e eu não queria ficar de fora — só que não tinha como pagar. Fui atrás de uma alternativa gratuita e caí no Windsurf. Foi meu primeiro gostinho de ter IA dentro do editor, e a diferença era de lugar: ela tinha saído da aba do navegador e entrado onde o trabalho acontecia de verdade. O atrito caiu, e eu achei genial.

A ficha caiu numa demanda sem muita importância: eu estava adicionando umas validações extras de segurança e regra de negócio. Eram várias funções de permissão — `temAcesso`, `pode` isso, `pode` aquilo — que ainda não existiam e eu tinha que criar. Escrevi as duas primeiras na mão. Da terceira em diante, o autocomplete já completava sozinho: tinha sacado o padrão e previa o que eu ia escrever antes de eu escrever. Foi o meu primeiro "pseudo flow-state". Parecia que a ferramenta lia minha mente.

Até que, na mesma demanda, precisei de um loop com uma regra um pouco diferente da anterior. E o autocomplete sugeriu com o pensamento antigo — repetiu o padrão de antes, ignorando que a intenção tinha mudado. Aí ficou claro o que aquilo era: autocomplete com esteroides. Brilhante na repetição, cego para a mudança de intenção. Ele enxergava o arquivo aberto, mas não o projeto, e muito menos o que eu estava de fato tentando fazer.

Foi aí que entendi a diferença entre estar no lugar certo e entender o problema. O Windsurf tinha matado o atrito — eu não precisava mais trocar de janela, explicar tudo do zero, voltar. Mas reduzir atrito não é entender contexto. Eu continuava sendo o único que enxergava o projeto inteiro. E comecei a querer uma IA que enxergasse junto.

## Cursor: quando achei que o mérito era da ferramenta

Comecei a ver os vídeos do Lucas Montano falando de uma tal de Cursor e fiquei maravilhado. A ferramenta escrevia, refatorava, buscava contexto no projeto e fazia tudo com uma naturalidade absurda. De novo, me recusei a ficar de fora. Assinei em 12 de janeiro de 2026, por três meses. Era o plano de US$ 20, que vinha uns R$ 120 — eu achava um absurdo: era a primeira vez que eu pagaria pra trabalhar.

Na maior parte do tempo, eu era um usuário ok. Pensava numa funcionalidade, descrevia as classes, os padrões, os nomes, e a IA escrevia muito mais rápido do que eu escreveria na mão. Já era um ganho enorme, e reforçava a minha crença daquele momento: se eu descrevesse bem a solução, meu trabalho estava praticamente feito — o resto era com a ferramenta.

Mas teve uma demanda que, olhando pra trás, foi diferente de todas. Precisávamos reduzir custo com a API do Google Maps. A ideia era parar de chamar a API toda hora e montar uma engine de busca de endereço interna, porque a gente já tinha registrado os endereços de onde mais saíam pedidos. Se o dado já existe, não precisa pagar pra buscar de novo.

E o que eu fiz, quase sem perceber, foi processo. Pesquisei como resolver. Fiz um brainstorm com a IA atrás da melhor abordagem, explicando o caso, as limitações e as regras. Validei com o time antes de escrever uma linha. Desenhei um diagrama de como ia funcionar e quais seriam as entidades. Só depois de tudo isso entreguei pra IA — e ela implementou rápido demais. Eu só testei. Foi a primeira demanda que lembro de ter acertado em cheio.

Na hora, dei o crédito todo pro Cursor. "Olha como essa ferramenta é boa." Hoje enxergo o contrário: o que fez aquilo dar certo não foi o Cursor, foi a pesquisa, o brainstorm, a validação com o time, o diagrama. O Cursor só digitou rápido o que eu já tinha pensado com cuidado. E onde eu pulei o processo, ele me cobrou — não escrevi testes unitários e tive que compensar com uma montanha de testes manuais.

Foi o primeiro lampejo do que viraria o meu jeito de trabalhar. Só que eu não percebi. Ainda achava que o mérito era da ferramenta, e que a próxima, mais inteligente, seria a verdadeira virada. Não ajudava que o limite do plano acabava rápido demais: eu usava com medo, só quando tinha algo muito bem definido, pra não gastar token à toa. E, enquanto eu me preocupava, tinha devs na empresa que não precisava se preocupar com isso.

## Antigravity: escala demais, cuidado de menos

Dois desenvolvedores mais antigos ganharam acesso ao plano Google Ultra pra rodar um piloto e validar se aquilo valia a pena. Eu ficava abismado. Lembro de pontos que a gente sempre quis fazer e que viviam ficando pra depois, por serem trabalhosos demais ou por falta de tempo. Com IA — em especial com o Claude Opus 4.5 disponível no Antigravity — essas coisas começaram a sair do papel.

Eu perguntava: como vocês fizeram isso? Quanto tempo levou? Quanto custou? Quando descobri que eles tinham uma cota massiva, renovando a cada cinco horas, fiquei com inveja. Era muito poder na mão. E minha crença daquele momento cabia numa frase: o que me destravava era escala. Com cota e agentes o suficiente, eu entregaria mais.

Um tempo depois o subsídio chegou pra mim e pra outros devs. Foi incrível. Eu abria várias abas, cada uma com um agente tocando uma parte diferente. Cancelei o Cursor na hora — tinha um brinquedo novo. E o mais curioso é como a gente se acostuma rápido: um volume de entrega que antes pareceria absurdo virou o novo normal. Aí mora o perigo. Quando a régua sobe, você esquece o quanto aquilo ainda é fora da curva, e começa a confiar demais.

Foi numa entrega de um novo tipo de pedido que a conta chegou. Eu não tinha tanto tempo pra esse projeto, mas mexia numa parte do código que eu conhecia bem — estava tudo na minha cabeça. Então deleguei pesado: era quase só escrever, citar exemplos e explicar como seguir o padrão. A qualidade não foi das melhores, mas dava pro prazo. No fim, o código só existe por causa do produto, e do cliente que paga por ele.

O problema é que, dessa vez, eu deleguei mais do que digitação — deleguei pedaços de arquitetura. E vieram os bugs. Pra caçá-los, usei mais IA ainda, e me peguei levemente perdido no meu próprio código: sabia mais ou menos onde estava o problema, mas não exatamente o que era. Esse é o preço de delegar o pensamento junto com o trabalho. Sob volume, eu tinha trocado o cuidado que tive na engine de endereços por pura velocidade. Tinha mais poder e mais responsabilidade — e menos controle.

Ainda tentei culpar a ferramenta. Vendo o Montano usar o Claude Code, resolvi configurar o Antigravity do mesmo jeito. Só que fui ajustar minha ferramenta esperando que ela fosse outra — e saí mais frustrado do que se tivesse feito algo simples e decente. O Antigravity tinha cota de sobra e era poderoso, mas eu o tratava como se fosse o Claude Code. A frustração não era só dele ser meio cego. Era, de novo, expectativa errada da minha parte. Mas a essa altura uma ideia já tinha grudado: se era o Claude Code que o Montano usava, talvez fosse hora de parar de improvisar e ir direto na fonte.

## Claude Code Pro: a ferramenta certa, usada do jeito errado

Assinei o Claude Code Pro, o plano de US$ 20, em 30 de março. E fiz o que parece óbvio em retrospecto, mas que era a minha cara na época: usei esperando que viesse tudo pronto. Não parei pra entender a ferramenta, não configurei nada, não estudei como melhorar o fluxo. Só usei.

Tem uma coisa que pode estar distorcendo essa memória: eu era — e ainda sou — muito enviesado pelo Montano, e admiro demais essa ferramenta, que hoje uso pra quase tudo. Então é difícil dizer se no começo eu de fato performei melhor, ou se parte disso é memória afetiva. Desconfiar do próprio encanto é chato, mas é necessário.

Tirando o encanto, ainda sobrava uma diferença real em relação ao Antigravity, e ela estava no effort que o Claude Code colocava pra entender o que eu pedia. Demorava um pouco mais, mas enxergava justamente os pontos que eu deixava ambíguos — em vez de adivinhar e seguir, ele batia na minha falta de clareza. No fundo, ele me devolvia o meu próprio problema: quando eu pedia mal, ele me mostrava que eu tinha pedido mal.

Foi nessa fase também que descobri o quanto ele é bom pra caçar bug. Inclusive achou alguns daqueles que eu tinha deixado pra trás na demanda do Antigravity — os tais que eu sabia mais ou menos onde estavam, mas não exatamente o que eram.

O problema continuava sendo a cota. Eu usava pouco, com medo de gastar, tentando fazer cada interação valer. Tinha a ferramenta certa nas mãos e ainda a tratava como artigo de luxo — sem nunca parar pra construir um jeito de trabalhar em cima dela. Isso só mudou pouco depois, quando comecei a dividir uma conta Max 20x com um colega. Aí a coisa ficou séria.

## Claude Max com o Emerson: quando parei de perguntar qual ferramenta é melhor

Nas primeiras semanas, eu e o Emerson usamos o Claude Code insistentemente. Eu vivia com múltiplos agentes rodando em paralelo — como uso `tmux`, era comum ter várias abas abertas, cada uma tocando uma parte diferente. Mesmo assim, no fim da semana, a gente não batia nem 50% da cota.

Fiquei indignado. A Anthropic estava lucrando comigo e eu estava deixando dinheiro na mesa. Decidi mudar isso. Só que, tentando usar mais, descobri o contrário do que esperava: o ganho não vinha de usar mais. Vinha de usar melhor. E "melhor", pra mim, ainda não tinha processo nenhum por trás.

Devo muito ao Emerson. Todo dia ele trazia vídeo, leitura, conversa sobre IA — e isso é muito foda. Foi ele que mais me fez evoluir em skill e em prompt. Ferramenta boa ajuda, mas conversar diariamente com alguém que também está testando, errando e refinando acelera de um jeito que nenhuma cota compra. Boa parte do que eu sei hoje saiu dessas trocas.

Foi nessa fase que comecei a montar um jeito de trabalhar que se sustentava: orquestrador de agentes, skills que usam modelos diferentes, hooks pra carregar a skill certa na hora certa, mais MCPs e, com o tempo, os meus próprios MCPs. Não foi um plano grandioso. Foi um pedaço por vez.

Um exemplo de como essa troca virava prática: numa demanda que juntava WhatsApp com um chat em tempo real, a gente não tinha a menor ideia de por onde começar. Foi o Emerson que me mostrou o plugin `superpowers`, e a gente passou a usar ele principalmente pra escrever os planos de ação e tocar a implementação com sub-agentes. Depois de uma sessão longa de brainstorm com a IA, só pra tirar aquilo do papel, o resultado foi bizarro: começamos numa sexta ou num sábado e, na segunda, já estava em homologação. Não era o código nem a arquitetura perfeita — mas se adequava ao cenário em que a gente estava e atendia as expectativas. Eu nunca vou esquecer o quão rápido e insano aquilo foi. E não foi o processo sozinho nem a ferramenta sozinha: foi a ferramenta certa destravando um processo que, na mão, eu não daria conta de rodar.

Olhando de fora, podia parecer que eu tinha um mega setup e sabia muito. A real é que não. Eu só estava melhorando um pedaço de cada vez. E talvez esse seja o aprendizado mais importante de toda a jornada: o fluxo fica melhor quando você entende como trabalha e aplica IA em partes específicas — não quando tenta automatizar a vida inteira de uma vez.

Foi também quando a pergunta que guiava tudo finalmente mudou:

> Meu fluxo começou a mudar quando parei de perguntar: "qual ferramenta é melhor?"
>
> E comecei a perguntar: "qual parte do meu trabalho essa ferramenta melhora?"

## Mythos: o modelo que me deixou parar de pensar

Então veio o Mythos, o modelo mais avançado da Anthropic naquele momento. Pra debug, ele era diferente de tudo que eu tinha usado: achava coisas que outros modelos não achavam — e, pior, coisas que eu nem tinha pensado em procurar.

A ficha caiu num projeto paralelo, no dia em que deleguei 100% do raciocínio pra ele. Dei um prompt genérico, dos preguiçosos, e o resultado foi bizarro: ele apontou todos os pontos ambíguos, as regras de negócio que faltavam, os trechos frágeis. Tudo o que eu deveria ter pensado antes de pedir, e não pensei, ele pensou por mim. Era mais autônomo e mais incisivo que qualquer coisa que eu tinha visto.

E foi exatamente aí que morava o veneno. O vício não era velocidade — era poder parar de pensar. Eu só precisava responder o que ele me perguntava. Pela primeira vez, a ferramenta não exigia o meu processo: ela substituía. Entrei em delírio e usei pra tudo. Em três dias, nossa cota semanal bateu 91%.

Aí, no dia em que deveria acontecer o reset, veio o anúncio: o Mythos seria bloqueado pra não americanos. Balde de água fria. Mas o que doeu não foi bem perder a ferramenta — foi o que a falta dela revelou.

A ficha caiu de vez quando bati numa opinião dura do Akita. A ideia era mais ou menos essa: o Mythos e o Opus são mais parecidos do que o hype fazia parecer, e em vários casos o Opus é até melhor. Dá pra chegar no mesmo resultado com os dois — a diferença é que, com o Opus, você precisa colocar mais esforço em prompt, em estrutura e em raciocínio. Não dá pra terceirizar o pensamento.

Foi um soco. Porque significava que o Mythos nunca tinha me feito melhor. Ele só tinha me deixado pular a parte difícil — que era justamente a minha parte. Fiz meu papel de engenheiro de software: questionei o Akita, questionei o Montano e, principalmente, questionei o que eu tinha feito durante todo aquele tempo. A conclusão era incômoda: passei tempo demais encantado com ferramenta e de menos estruturando processo. Sem o Mythos, percebi que tinha desaprendido a pensar sozinho por alguns dias. E foi aí que voltei pro começo desta história — porque, no fundo, sempre foi skill issue.

## O que ficou

Hoje me considero um usuário mais maduro. Não porque sei tudo — mas porque, pela primeira vez, tenho um processo, e ele é quase o oposto daquele estagiário que copiava, colava e torcia. E sim, eu era só um estagiário virando júnior — talvez por isso o gargalo fosse tão obviamente eu. Mas desconfio que vale em qualquer nível: o teto sempre é a pessoa, só muda de altura.

Quando pego uma demanda, costumo ter duas ou três abas abertas no `tmux`, mas não começo por nenhuma delas. Começo pensando: o que precisa ser feito e como eu faria. Só então abro um brainstorm com o Claude Code pra dar contexto — a demanda, o objetivo, as limitações e como eu imagino a solução. Depois pergunto a ele por alternativas, pra checar se o caminho que pensei é mesmo o melhor. Com isso, monto um plano de ação, reviso e, se precisar, refino. Só quando o plano está de pé é que deixo a IA implementar no modo automático — e volto quando está "pronto", pra revisar e polir.

Repare no que eu não delego: as regras, os objetivos e os critérios de pronto. Esse é o meu papel, e é o único pedaço que não terceirizo por nada. A IA escreve, investiga, sugere — mas quem decide o que é "certo" sou eu. Foi essa a lição que me custou a jornada inteira: dá pra delegar o fazer, nunca o decidir. A regra que eu queria ter tido no começo é mais prática que isso: delegue o que você consegue verificar; não delegue o que define o que é "certo". Se você não sabe dizer se a saída tá certa, não tem o que terceirizar — tem o que aprender.

E o sinal mais concreto de que isso virou trabalho de verdade não é um prompt bonito. É o que eu construo. Hoje mantenho um MCP ligado ao banco de dados da empresa que tem me ajudado de um jeito insano no debug — porque nem todo erro está no código; muita vez é um valor no banco que não bate. Estou refinando ele pra subir num servidor e o time inteiro usar, de dev a produto, já que IA virou ferramenta de todo mundo aqui.

Olhando pra trás, tem uma ironia boa nisso. Comecei essa história derrubando o banco com uma query que eu não entendia. Hoje, construo uma ferramenta pra enxergar esse mesmo banco antes que ele caia. O banco é o mesmo. Quem mudou fui eu.
