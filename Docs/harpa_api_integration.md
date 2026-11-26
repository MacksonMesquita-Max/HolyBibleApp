# Integração com a Harpa API

## 1. Objetivo

Este documento descreve como o Verbum consome a
[Harpa API](https://github.com/ronisdev/harpa-api), onde os endpoints ficam
centralizados, quais fluxos já estão conectados e como a integração
respeita o isolamento entre features.

## 2. Serviço e configuração

- **Base URL:** `https://harpa-api.onrender.com`
- **Cliente HTTP:** `DioClient`, criado com a base URL recebida por
  construtor.
- **Autenticação:** o app não configura API key nem token.
- **Endpoints:** centralizados em
  `lib/core/infrastructure/network/harpa_api_endpoints.dart`.

O `DioClient` é infraestrutura genérica. Os caminhos e parâmetros da
Harpa ficam na classe `HarpaApiEndpoints`; as features não devem montar
URLs manualmente.

## 3. Endpoints declarados

| Método | Caminho | Parâmetros de paginação |
|---|---|---|
| `hymns()` | `GET /hymns` | `page`, `limit`, `sortOrder` |
| `hymnByNumber(number)` | `GET /hymns/{number}` | Nenhum |
| `searchByTitle(query)` | `GET /hymns/search/title/{query}` | `page`, `limit`, `sortOrder` |
| `searchByVerse(query)` | `GET /hymns/search/verse/{query}` | `page`, `limit`, `sortOrder` |
| `searchByNumber(number)` | `GET /hymns/search/number/{number}` | `page`, `limit`, `sortOrder` |
| `randomHymn()` | `GET /hymns/random` | Nenhum |

Os valores padrão são página `1`, limite `10` e ordenação `asc`. O limite
aceito pelo cliente é de `1` a `50`; a ordenação aceita `asc` ou `desc`.
As buscas codificam o texto do caminho com `Uri.encodeComponent`.

Declarar um endpoint não significa que ele já esteja conectado a uma
tela: `hymns()` está disponível em `HarpaApiEndpoints`, mas ainda não tem
consumidor no app.

## 4. Endpoints atualmente consumidos

| Fluxo | Endpoint | Resultado usado |
|---|---|---|
| Sugestão na Home | `GET /hymns/random` | Título do hino aleatório |
| Abrir hino na Harpa | `GET /hymns/{number}` | Número, título, autor e estrofes |
| Busca global | Endpoints de título e trecho | Título e número para montar atalhos |
| Busca global numérica | Endpoint de número, além de título e trecho | Título e número para montar atalhos |

A Home mostra um hino aleatório e permite tentar novamente quando ocorre
falha. A tela Harpa recebe opcionalmente um número inicial. Sem número,
mostra uma orientação para pesquisar; com número, carrega a letra. A
listagem completa de hinos ainda não está ligada à tela.

## 5. Integração por feature

Cada feature mantém seu próprio fluxo e não importa os arquivos internos
de outra feature.

### 5.1. Home

```text
HymnSuggestionCard
  → GetRandomHymnUseCase
    → RandomHymnRepository
      → RandomHymnRemoteDataSource
        → DioClient + HarpaApiEndpoints.randomHymn()
          → GET /hymns/random
```

O model atual lê `hymn.title` e expõe um `RandomHymn`. A sugestão da Home
não depende da feature `harpa_screen`.

### 5.2. Tela Harpa

```text
HarpaPage
  → GetHymnByNumberUseCase
    → HymnRepository (application/ports)
      → HarpaApiRepository
        → HarpaRemoteDataSource
          → DioClient + HarpaApiEndpoints.hymnByNumber(number)
            → GET /hymns/{number}
```

O módulo público `HarpaScreenModule` compõe essas dependências e cria a
`HarpaPage`. O número inicial é encaminhado pelo `AppRouter`.

A resposta detalhada esperada pelo model contém um objeto `hymn` com
`number`, `title`, `author` e `verses`. Cada estrofe usa `sequence`,
`lyrics` e `chorus`:

```json
{
  "hymn": {
    "number": 13,
    "title": "Exemplo de título",
    "author": "Autor",
    "verses": [
      {
        "sequence": 1,
        "lyrics": "Texto da estrofe",
        "chorus": false
      }
    ]
  }
}
```

O exemplo representa os campos lidos pelo model da aplicação; não é uma
garantia de disponibilidade do serviço ou uma resposta validada em
tempo real.

### 5.3. Busca global

`search_screen` possui seu próprio `SearchRemoteDataSource` e um
`DioClient` configurado para a Harpa API. Ele consulta título e trecho
em paralelo. Se a pesquisa inteira puder ser convertida para número,
também consulta o endpoint de número.

Os resultados são convertidos em atalhos com título e número do hino.
Ao selecionar um atalho, o `AppRouter` abre a rota da Harpa passando o
número; a tela Harpa realiza então sua própria consulta de detalhes.
Consulte [global_search.md](global_search.md) para o fluxo completo.

## 6. Tratamento de respostas e erros

Para detalhes de um hino, `HarpaRemoteDataSource`:

- rejeita respostas vazias ou com a chave `error`;
- converte HTTP 404 em “Hino não encontrado.”;
- apresenta uma mensagem de conexão para outras falhas HTTP;
- valida os campos obrigatórios ao construir `HymnModel`.

Na busca global, respostas sem dados válidos não produzem atalhos. A
indisponibilidade de uma API é representada na entidade de resultados e
apresentada separadamente para Bíblia e Harpa.

## 7. Organização dos arquivos

```text
lib/
├── core/infrastructure/network/
│   ├── dio_client.dart
│   └── harpa_api_endpoints.dart
└── features/
    ├── home_screen/       # hino aleatório da Home
    ├── harpa_screen/      # consulta dos detalhes por número
    └── search_screen/     # buscas e atalhos
```

A composição dos módulos é responsabilidade de `app/di/`; as rotas e a
passagem do número do hino são responsabilidade de `app/router/`.

## 8. Validação

Verificar a análise estática:

```shell
flutter analyze
```

Executar os testes:

```shell
flutter test
```

Fluxo manual da integração:

1. Abrir a Home e confirmar a apresentação do hino aleatório ou do estado
   de erro.
2. Fazer uma busca de hino e abrir um atalho.
3. Confirmar que o número foi encaminhado à tela Harpa e que título,
   autor e estrofes são apresentados.
4. Testar um número inexistente e confirmar a mensagem de hino não
   encontrado.

## 9. Limitações conhecidas

- A API depende de conectividade e disponibilidade do serviço remoto.
- A tela Harpa carrega detalhes por número; a listagem completa ainda
  não está conectada.
- O fluxo de busca apresenta atalhos e carrega a letra somente depois da
  navegação.
- `HarpaApiEndpoints.hymns()` está declarado, mas não é consumido
  atualmente.
