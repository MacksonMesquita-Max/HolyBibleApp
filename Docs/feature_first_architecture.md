# Documentação --- Feature-First Architecture

## 1. Objetivo da arquitetura

A Feature-First Architecture organiza o código-fonte por funcionalidades
de negócio (*features*), em vez de agrupar todos os arquivos
exclusivamente pelo tipo técnico.

Combinada com Clean Architecture e DDD leve, ela permite que cada
funcionalidade concentre sua apresentação, aplicação, domínio e
infraestrutura, mantendo responsabilidades bem definidas e reduzindo o
acoplamento.

A estrutura proposta considera uma aplicação Flutter/Dart com três áreas
principais:

-   `core/`: recursos arquiteturais e conceitos compartilhados que podem
    incluir regras de negócio transversais.
-   `shared/`: componentes e utilitários genéricos, sem regras de
    negócio.
-   `features/`: funcionalidades de negócio organizadas em módulos
    independentes.

**A reutilização, por si só, não determina onde um arquivo deve ficar.**
O critério principal é sua responsabilidade.

## 2. Estrutura principal do projeto

``` text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   ├── theme/
│   └── config/
│
├── core/
│   ├── domain/
│   │   ├── entities/
│   │   ├── value_objects/
│   │   ├── exceptions/
│   │   ├── failures/
│   │   └── contracts/
│   ├── application/
│   │   ├── contracts/
│   │   ├── services/
│   │   └── policies/
│   ├── infrastructure/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── messaging/
│   │   ├── logging/
│   │   └── security/
│   └── utils/
│       ├── result/
│       └── validators/
│
├── shared/
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── inputs/
│   │   ├── dialogs/
│   │   ├── cards/
│   │   └── loading/
│   ├── extensions/
│   ├── formatters/
│   ├── helpers/
│   └── constants/
│
└── features/
    ├── autenticacao/
    │   ├── presentation/
    │   ├── application/
    │   ├── domain/
    │   └── data/
    ├── usuarios/
    │   ├── presentation/
    │   ├── application/
    │   ├── domain/
    │   └── data/
    └── produtos/
        ├── presentation/
        ├── application/
        ├── domain/
        └── data/
```

A árvore é uma referência inicial. Nem toda pasta precisa existir desde
o começo: crie subpastas quando elas melhorarem a organização e a
clareza do módulo.

## 3. Pasta `core/`

A pasta `core/` reúne recursos transversais que possuem responsabilidade
arquitetural ou representam conceitos e regras compartilhados por
diferentes funcionalidades.

``` text
core/
├── domain/
│   ├── entities/
│   ├── value_objects/
│   ├── exceptions/
│   ├── failures/
│   └── contracts/
├── application/
│   ├── contracts/
│   ├── services/
│   └── policies/
├── infrastructure/
│   ├── network/
│   │   ├── api_client.dart
│   │   └── interceptors/
│   ├── storage/
│   │   ├── secure_storage.dart
│   │   └── local_storage.dart
│   ├── messaging/
│   │   ├── event_bus.dart
│   │   └── message_handler.dart
│   ├── logging/
│   └── security/
└── utils/
    ├── result/
    └── validators/
```

### Responsabilidades

  -----------------------------------------------------------------------
  Diretório                           Responsabilidade
  ----------------------------------- -----------------------------------
  `domain/`                           Conceitos, contratos e regras
                                      genuinamente transversais ao
                                      domínio.

  `application/`                      Serviços e políticas de aplicação
                                      reutilizados por diferentes
                                      módulos, quando necessário.

  `infrastructure/`                   Implementações técnicas comuns,
                                      como cliente HTTP, armazenamento
                                      seguro e mensageria.

  `utils/`                            Utilitários independentes e
                                      resultados padronizados, sem regras
                                      específicas de uma feature.
  -----------------------------------------------------------------------

### Exemplos

-   Um objeto de valor `Money`, se diferentes módulos compartilharem a
    mesma semântica monetária.
-   Um tipo `Result` para representar sucesso ou falha de operações.
-   Um contrato comum de armazenamento seguro.
-   Um cliente HTTP configurado para a aplicação.
-   Uma política transversal de autorização, caso suas regras sejam
    realmente compartilhadas.

**Atenção:** não coloque automaticamente todas as entidades, interfaces
e regras de negócio em `core/`. Entidades como `Produto`, `Pedido` e
`Fatura` devem permanecer nas respectivas features quando pertencem
exclusivamente a esses contextos.

## 4. Pasta `shared/`

A pasta `shared/` reúne componentes visuais e recursos genéricos que
podem ser utilizados por diferentes telas sem conhecer as regras de
negócio.

``` text
shared/
├── widgets/
│   ├── buttons/
│   │   ├── primary_button.dart
│   │   └── secondary_button.dart
│   ├── inputs/
│   │   ├── app_text_field.dart
│   │   └── search_field.dart
│   ├── dialogs/
│   │   ├── confirmation_dialog.dart
│   │   └── error_dialog.dart
│   ├── cards/
│   │   └── app_card.dart
│   └── loading/
│       ├── loading_indicator.dart
│       └── loading_overlay.dart
├── extensions/
│   ├── string_extensions.dart
│   └── date_time_extensions.dart
├── formatters/
│   ├── currency_formatter.dart
│   └── date_formatter.dart
├── helpers/
│   ├── debounce.dart
│   └── responsive_helper.dart
└── constants/
    ├── spacing.dart
    └── dimensions.dart
```

### Responsabilidades

-   `widgets/`: componentes visuais reutilizáveis.
-   `extensions/`: extensões genéricas de tipos da linguagem.
-   `formatters/`: formatação de datas, valores e textos para
    apresentação.
-   `helpers/`: funções auxiliares independentes de contexto.
-   `constants/`: espaçamentos, dimensões e constantes de apresentação.

Por exemplo, `PrimaryButton` deve receber texto, estado de carregamento
e callback por parâmetros. Ele não deve consultar um repositório de
produtos nem decidir se um pedido pode ser faturado.

**Regra prática:** se o componente pode ser usado em diferentes
funcionalidades sem conhecer o negócio, provavelmente pertence a
`shared/`.

## 5. Pasta `features/`

Cada feature representa uma funcionalidade ou um contexto de negócio.
Ela concentra o código relacionado àquela responsabilidade, evitando que
seus elementos específicos se espalhem por pastas globais.

Exemplo de uma feature de produtos:

``` text
features/
└── produtos/
    ├── presentation/
    │   ├── pages/
    │   │   ├── produtos_page.dart
    │   │   └── produto_detalhe_page.dart
    │   ├── widgets/
    │   │   ├── produto_card.dart
    │   │   └── produto_form.dart
    │   ├── cubit/
    │   │   ├── produtos_cubit.dart
    │   │   └── produtos_state.dart
    │   └── mappers/
    │
    ├── application/
    │   ├── use_cases/
    │   │   ├── listar_produtos.dart
    │   │   ├── cadastrar_produto.dart
    │   │   └── excluir_produto.dart
    │   ├── services/
    │   ├── ports/
    │   │   └── produto_repository.dart
    │   └── dto/
    │
    ├── domain/
    │   ├── entities/
    │   │   └── produto.dart
    │   ├── value_objects/
    │   │   └── preco.dart
    │   ├── repositories/
    │   ├── services/
    │   ├── policies/
    │   └── exceptions/
    │
    └── data/
        ├── datasources/
        │   ├── produto_remote_datasource.dart
        │   └── produto_local_datasource.dart
        ├── models/
        │   └── produto_model.dart
        ├── repositories/
        │   └── produto_repository_impl.dart
        └── mappers/
```

Essa divisão combina Feature-First com Clean Architecture. Os nomes das
pastas podem variar, desde que as responsabilidades e a direção das
dependências sejam preservadas.

## 6. Camadas internas: DDD + Clean Architecture

Cada feature organiza seu código em camadas com responsabilidades bem
definidas. A Clean Architecture orienta a separação das
responsabilidades, enquanto o DDD ajuda a modelar conceitos, restrições
e regras do negócio.

### 6.1. Apresentação --- `presentation/`

É a camada responsável pela interação com o usuário ou com um ponto de
entrada externo, como uma API HTTP.

**Responsabilidades:**

-   Exibir telas, formulários e componentes.
-   Gerenciar estados de interface com Cubit ou Bloc.
-   Capturar entradas e validar aspectos básicos de apresentação.
-   Converter entradas externas em comandos ou DTOs apropriados.
-   Invocar casos de uso da aplicação.
-   Converter resultados em estados, respostas ou modelos de saída.
-   Serializar e desserializar dados de transporte quando isso fizer
    parte do ponto de entrada.

**Subpastas possíveis:**

``` text
presentation/
├── pages/
├── widgets/
├── cubit/
├── bloc/
├── controllers/
├── dto/
├── mappers/
└── validators/
```

Não é necessário criar todas as pastas em toda feature. Em Flutter,
`pages/`, `widgets/` e `cubit/` podem ser suficientes para a
apresentação.

**Regra:** a apresentação não deve implementar regras de negócio nem
acessar diretamente o banco de dados.

### 6.2. Aplicação --- `application/`

A camada de aplicação coordena a execução dos processos de negócio. Ela
define o que precisa acontecer e em qual sequência, delegando as
decisões de negócio ao domínio.

**Responsabilidades:**

-   Implementar casos de uso.
-   Orquestrar chamadas a entidades, serviços de domínio e repositórios.
-   Definir portas (interfaces) para recursos externos necessários.
-   Coordenar transações quando aplicável.
-   Controlar o fluxo de execução e tratar resultados de operações.
-   Definir DTOs de aplicação quando necessários para entrada e saída
    dos casos de uso.

**Subpastas possíveis:**

``` text
application/
├── use_cases/
├── ports/
├── dto/
├── services/
├── policies/
└── mappers/
```

Exemplo: `CadastrarProduto` recebe os dados de cadastro, solicita ao
domínio a criação válida do produto e utiliza o contrato de repositório
para persistir o resultado.

O caso de uso não precisa conhecer o tipo de banco, a biblioteca HTTP ou
a implementação concreta do repositório.

### 6.3. Núcleo --- `domain/`

O domínio é o centro das regras de negócio. Ele define os conceitos, as
restrições e as operações que determinam o comportamento válido do
sistema.

**Responsabilidades:**

-   Representar entidades e seus ciclos de vida.
-   Definir objetos de valor (*Value Objects*).
-   Garantir invariantes e consistência das regras de negócio.
-   Implementar serviços de domínio quando uma regra não pertence
    naturalmente a uma única entidade.
-   Definir políticas e exceções específicas do domínio.
-   Declarar contratos de repositório quando estes representarem
    necessidades do domínio.

**Subpastas possíveis:**

``` text
domain/
├── entities/
├── value_objects/
├── repositories/
├── services/
├── policies/
├── exceptions/
└── specifications/
```

Exemplo: um `Preco` pode impedir valores negativos, enquanto uma
entidade `Produto` pode garantir que um produto ativo tenha os dados
obrigatórios.

As invariantes devem ser protegidas pelo próprio domínio, e não apenas
por validações na tela.

**Regra fundamental:** o domínio não deve importar Flutter, Bloc, Dio,
bibliotecas de banco de dados, ORM ou SDKs externos.

### 6.4. Dados e mensagens --- `data/` e infraestrutura

Essa camada conecta as regras internas aos recursos externos. Em uma
estrutura Feature-First, é comum usar `data/` dentro de cada feature e
`core/infrastructure/` para implementações técnicas genuinamente
compartilhadas.

**Responsabilidades:**

-   Consultar e persistir dados.
-   Implementar contratos de repositórios.
-   Consumir APIs HTTP.
-   Converter JSON em modelos externos e modelos em entidades.
-   Integrar bancos de dados, filas, mensageria e SDKs.
-   Gerenciar detalhes técnicos de comunicação e armazenamento.

**Subpastas possíveis:**

``` text
data/
├── datasources/
│   ├── produto_remote_datasource.dart
│   └── produto_local_datasource.dart
├── models/
├── repositories/
└── mappers/
```

Em projetos que usam mensageria, também podem existir adaptadores
específicos para produtores, consumidores e handlers de mensagens.

Os modelos de persistência e de API não devem ser confundidos
automaticamente com as entidades do domínio. Cada um possui uma
responsabilidade distinta, mesmo quando seus campos são semelhantes.

## 7. Regra de dependência --- DIP

O *Dependency Inversion Principle* (Princípio da Inversão de
Dependência) determina que módulos de alto nível não devem depender
diretamente de módulos de baixo nível. Ambos devem depender de
abstrações.

Na arquitetura proposta, as regras de negócio não dependem dos detalhes
técnicos de infraestrutura.

### 7.1. Direção das dependências

A direção das setas representa quem conhece ou importa quem, não
necessariamente a ordem em que o código é executado.

``` text
Presentation
     |
     v
Application
     |
     v
Domain

Infrastructure / Data
     |
     └──> implementa contratos definidos internamente
```

Em termos simplificados:

-   `Presentation → Application`
-   `Application → Domain`
-   `Infrastructure → contratos internos`
-   `Domain → não depende de frameworks ou infraestrutura`

A infraestrutura pode implementar uma interface declarada em
`application/ports/` ou `domain/repositories/`, conforme a
responsabilidade desse contrato.

### 7.2. Exemplo prático de inversão

Imagine que o caso de uso precise salvar um produto. Primeiro, a
aplicação ou o domínio define um contrato:

``` dart
abstract interface class ProdutoRepository {
  Future<void> salvar(Produto produto);
}
```

O caso de uso depende dessa abstração:

``` dart
class CadastrarProduto {
  final ProdutoRepository repository;

  CadastrarProduto(this.repository);

  Future<void> executar(Produto produto) async {
    // As regras do domínio devem estar válidas
    // antes de persistir o produto.
    await repository.salvar(produto);
  }
}
```

A infraestrutura implementa o contrato:

``` dart
class ProdutoRepositoryImpl implements ProdutoRepository {
  final ProdutoRemoteDataSource dataSource;

  ProdutoRepositoryImpl(this.dataSource);

  @override
  Future<void> salvar(Produto produto) async {
    final model = ProdutoModel.fromEntity(produto);
    await dataSource.salvar(model);
  }
}
```

O `ProdutoRemoteDataSource` pode utilizar Dio, HTTP ou outro SDK para
realizar a comunicação externa.

O ponto essencial é que `CadastrarProduto` não conhece
`ProdutoRepositoryImpl`, Dio ou o formato JSON da API. A implementação
concreta é conectada por meio da configuração de dependências da
aplicação.

### 7.3. Como aplicar o DIP corretamente

1.  Defina os contratos na camada interna que necessita do recurso.
2.  Implemente esses contratos na camada de dados ou infraestrutura.
3.  Injete as implementações por construtor ou por um mecanismo de
    injeção de dependência.
4.  Evite importar implementações concretas nas camadas internas.
5.  Mantenha as dependências entre módulos explícitas.

Não é obrigatório criar uma interface para toda classe. O DIP é mais
importante nos limites entre regras de negócio e detalhes externos, onde
a inversão realmente reduz o acoplamento.

## 8. Como decidir entre `core`, `shared` e `features`

  ----------------------------------------------------------------------------------------
  Elemento                Local recomendado                        Motivo
  ----------------------- ---------------------------------------- -----------------------
  Botão reutilizável      `shared/widgets/`                        Componente visual
                                                                   genérico.

  Campo de texto          `shared/widgets/`                        Não conhece regras de
  padronizado                                                      negócio.

  Formatador de moeda     `shared/formatters/`                     Formata valores para
                                                                   apresentação.

  Objeto de valor         `core/domain/` ou feature proprietária   Contém semântica e
  monetário com                                                    regras de negócio.
  invariantes                                                      

  Cliente HTTP            `core/infrastructure/`                   Integração técnica
  compartilhado                                                    comum.

  Contrato de repositório `features/produtos/application/ports/`   Pertence à necessidade
  de produtos             ou `domain/repositories/`                do módulo.

  Entidade `Produto`      `features/produtos/domain/`              Conceito específico do
                                                                   negócio.

  Tela de cadastro de     `features/produtos/presentation/`        Interface de uma
  produtos                                                         funcionalidade.

  Caso de uso de          Feature responsável pelo faturamento     Orquestra um processo
  faturamento                                                      de negócio específico.

  Política de autorização `core/`, se genuinamente compartilhada   Regra comum a
  transversal                                                      diferentes módulos.
  ----------------------------------------------------------------------------------------

Uma regra de uma feature não deve ser movida para `core` apenas porque
duas telas precisam utilizá-la. Primeiro, verifique se ambas pertencem
ao mesmo contexto de negócio. Se pertencerem, mantenha a regra na
feature e reutilize-a internamente.

## 9. Regras de organização e boas práticas

-   **Organização por funcionalidade:** cada feature concentra o código
    necessário para sua responsabilidade.
-   **Domínio independente:** nenhuma regra de negócio depende de
    Flutter, banco de dados ou serviços externos.
-   **Infraestrutura substituível:** APIs, bancos e SDKs podem ser
    trocados sem reescrever os casos de uso.
-   **Compartilhamento consciente:** `core` e `shared` recebem apenas
    recursos com responsabilidade realmente transversal.
-   **Baixo acoplamento:** uma feature não deve acessar diretamente os
    arquivos internos de outra feature.
-   **Contratos explícitos:** integrações entre módulos devem ocorrer
    por interfaces ou APIs internas bem definidas.
-   **Complexidade proporcional:** crie subpastas e abstrações quando
    trouxerem clareza; não é necessário preencher toda a árvore desde o
    início.
-   **Testabilidade:** domínio e casos de uso devem ser testáveis sem
    inicializar widgets, banco de dados ou conexões reais.
-   **DTOs e entidades separados:** formatos de entrada e saída não
    devem obrigar o domínio a conhecer detalhes de transporte ou
    persistência.

## 10. Resumo da arquitetura

-   `app/`: inicialização, configuração, navegação e composição geral.
-   `core/`: recursos arquiteturais, contratos e regras transversais
    reutilizáveis.
-   `shared/`: componentes genéricos, extensões, formatadores e helpers
    sem regras de negócio.
-   `features/`: funcionalidades organizadas por domínio, cada uma com
    apresentação, aplicação, domínio e dados.

**O princípio central é manter as regras de negócio no centro e os
detalhes técnicos nas bordas.** A Feature-First define como o código é
agrupado; a Clean Architecture define a separação das responsabilidades;
o DDD ajuda a modelar os conceitos e as regras do negócio; e o DIP
garante que esses conceitos não fiquem presos a frameworks ou
implementações externas.
