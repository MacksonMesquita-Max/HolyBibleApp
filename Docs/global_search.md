# Busca Global

## 1. Objetivo

A feature `search_screen` oferece uma entrada única para pesquisar
referências bíblicas e hinos da Harpa Cristã. Como as APIs têm capacidades
diferentes, a busca encaminha cada consulta somente aos endpoints
compatíveis e apresenta atalhos para abrir o conteúdo na feature
responsável.

## 2. Limites das APIs

### Bible API

A Bible API permite consultar passagens por referência, por exemplo
`John 3:16`. Ela não oferece busca textual livre por palavras em toda a
Bíblia. A aplicação só tenta a consulta bíblica se a pesquisa contiver
pelo menos um algarismo; essa é uma heurística simples para reconhecer
referências.

### Harpa API

A Harpa API permite pesquisar por título e trecho/estrofe. Quando a
consulta inteira pode ser interpretada como um número, a aplicação
também pesquisa pelo número do hino.

Os caminhos são montados por
`BibleApiEndpoints` e `HarpaApiEndpoints`, no `core`. A feature não
concatena URLs manualmente.

## 3. Fluxo da consulta

```text
SearchPage
  → SearchContentUseCase
    → SearchRepository (application/ports)
      → SearchApiRepository
        → SearchRemoteDataSource
          ├── Bible API: GET /{reference}?translation=kjv, se houver dígito
          └── Harpa API:
              ├── busca por título
              ├── busca por trecho
              └── busca por número, quando aplicável
```

O caso de uso remove espaços externos e rejeita consultas vazias. No
datasource, as pesquisas à Harpa são executadas em paralelo. Uma falha
em um endpoint não impede o processamento dos demais resultados.

As respostas da Harpa são convertidas em títulos e números, removendo
duplicatas por número do hino. A passagem bíblica é convertida em uma
referência, nome da tradução e contagem de versículos. A tela não exibe
o texto completo do resultado bíblico.

## 4. Atalhos e navegação

A tela exibe:

- um atalho bíblico com referência, quantidade de versículos e tradução;
- atalhos de hinos com título e número;
- mensagens distintas quando não há resultados ou uma API está
  indisponível.

Ao selecionar um atalho, a tela chama um callback fornecido pela
composição em `app/`. O `AppRouter` faz a navegação:

```text
Atalho bíblico → rota /bible, argumento String com a referência
Atalho de hino  → rota /harpa, argumento int com o número
```

`BibleScreenModule` cria a Bíblia com `initialReference`; a `BiblePage`
preenche o campo e consulta a passagem depois do primeiro frame.
`HarpaScreenModule` cria a Harpa com `initialHymnNumber`; a `HarpaPage`
carrega os detalhes desse hino. Assim, `search_screen` não importa
widgets, casos de uso ou repositórios internos das outras features.

## 5. Organização e dependências

```text
lib/features/search_screen/
├── search_screen_module.dart
├── application/
│   ├── ports/search_repository.dart
│   └── use_cases/search_content_use_case.dart
├── data/
│   ├── datasources/search_remote_data_source.dart
│   ├── models/search_results_model.dart
│   └── repositories/search_api_repository.dart
├── domain/entities/search_results.dart
└── presentation/pages/search_page.dart
```

O `SearchRemoteDataSource` recebe um `DioClient` para cada API. O
`SearchResultsModel` mantém o parsing da resposta da Bible API dentro da
feature de busca; ele tem estrutura semelhante a modelos da feature
Bíblia, mas não os importa. Essa duplicação mantém as features
independentes e pode ser reavaliada se surgir uma abstração realmente
transversal.

O campo de pesquisa visual é
`shared/widgets/inputs/search_input.dart`. Os componentes compartilhados
não conhecem as APIs nem a navegação.

## 6. Limitações e comportamento de falha

- A Bíblia não é pesquisada quando a consulta não contém algarismos.
- Uma consulta com algarismo pode provocar uma tentativa bíblica mesmo
  quando a intenção era pesquisar outro conteúdo.
- A disponibilidade da Bible API e da Harpa API é independente; a tela
  pode exibir resultados de uma enquanto informa falha na outra.
- A pesquisa apresenta atalhos, não o conteúdo integral. A feature de
  destino faz sua própria consulta ao abrir.

## 7. Testes

O comportamento dos atalhos e dos callbacks de navegação é coberto por
`test/search_page_test.dart`; o parsing de respostas é coberto por
`test/search_results_model_test.dart`.

Executar os testes relacionados:

```shell
flutter test test/search_page_test.dart test/search_results_model_test.dart
```

Para validar também o carregamento dos destinos:

```shell
flutter test test/bible_page_test.dart test/harpa_page_test.dart
```

Consulte também:

- [Integração com a Bible API](bible_api_integration.md)
- [Integração com a Harpa API](harpa_api_integration.md)
- [Arquitetura Feature-First](feature_first_architecture.md)
