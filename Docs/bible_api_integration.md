# Documentação --- Integração com a Bible API

## 1. Objetivo

Esta documentação descreve como o aplicativo **Verbum - Bíblia Sagrada**
consome a **Bible API** (`https://bible-api.com`): quais endpoints são
usados, o que é necessário para funcionar, onde a integração vive na
estrutura de pastas e como adicionar um novo consumo seguindo o mesmo
padrão.

Ela complementa o `feature_first_architecture.md` e assume que o leitor
conhece a separação em camadas (`presentation` → `application` →
`domain`) e a regra de que **uma feature não acessa arquivos internos de
outra feature**.

## 2. A API

### 2.1. Características

-   **Base URL:** `https://bible-api.com`
-   **Sem autenticação:** nenhuma API key, token ou header obrigatório.
-   **HTTPS** com **CORS** habilitado.
-   Respostas em **JSON**.
-   Projeto de código aberto, mantido por hobby.

### 2.2. Tradução usada

O aplicativo usa a tradução `kjv` (**King James Version**, em inglês).
A Bible API identifica essa tradução como domínio público.

O identificador da tradução padrão fica centralizado em
`BibleApiEndpoints`:

``` dart
// core/infrastructure/network/bible_api_endpoints.dart
static const String defaultTranslation = 'kjv';
```

> A `PassageRequest` também declara `defaultTranslation = 'kjv'` para o
> caso de uso. O valor está repetido entre o endpoint e o DTO; manter
> ambos sincronizados é uma pendência de centralização.

### 2.3. Limites e riscos

-   Limite de **15 requisições a cada 30 segundos por IP**.
-   **Não** deve ser usada para baixar a Bíblia inteira (para isso
    existem os datasets oficiais do projeto).
-   **Sem SLA**: não há garantia de disponibilidade nem de estabilidade.
-   Ela complementa, mas **não substitui** uma base offline.

## 3. Endpoints

Todos os caminhos abaixo estão centralizados em
`core/infrastructure/network/bible_api_endpoints.dart`. Nenhuma feature
monta URL manualmente.

### 3.1. Busca por referência livre

| | |
|---|---|
| Endpoint | `GET /{reference}` |
| Parâmetros de query | `translation={id}` |
| Exemplos | `/John 3:16`, `/John 1:1-5`, `/matt 25:31-33,46`, `/john 1` |

Aceita um versículo, um intervalo, uma lista de versículos ou um capítulo
inteiro. O espaço em branco da referência é normalizado para `+`.

### 3.2. API parametrizada (`/data`)

| Descrição | Endpoint |
|---|---|
| Traduções disponíveis | `GET /data` |
| Livros de uma tradução | `GET /data/{translation}` |
| Capítulos de um livro | `GET /data/{translation}/{bookId}` |
| Versículos de um capítulo | `GET /data/{translation}/{bookId}/{chapter}` |

### 3.3. Versículo aleatório

| Descrição | Endpoint |
|---|---|
| Aleatório da tradução | `GET /data/{translation}/random` |
| De livros específicos | `GET /data/{translation}/random/{bookIds}` |

`bookIds` aceita uma lista separada por vírgula (ex.: `MAT,MRK`) ou os
valores especiais `OT` (Antigo Testamento) e `NT` (Novo Testamento).

### 3.4. Métodos disponíveis no código

| Método | Endpoint gerado | Consumido por |
|---|---|---|
| `passage(reference)` | `/{reference}` | `bible_screen`, `search_screen` |
| `randomVerse(translation, {bookIds})` | `/data/{t}/random[/{ids}]` | `home_screen` |
| `translations()` | `/data` | --- (declarado) |
| `books(translation)` | `/data/{translation}` | --- (declarado) |
| `chapters(translation:, bookId:)` | `/data/{t}/{bookId}` | --- (declarado) |
| `verses(translation:, bookId:, chapter:)` | `/data/{t}/{bookId}/{chapter}` | --- (declarado) |

## 4. Visão geral da integração

A integração segue o princípio: **o `core` conhece o serviço; cada feature
mantém a sua própria fatia vertical.**

``` text
lib/
├── core/
│   └── infrastructure/
│       └── network/
│           ├── dio_client.dart            # cliente HTTP genérico
│           └── bible_api_endpoints.dart   # URLs do serviço
│
└── features/
    ├── bible_screen/                      # busca por referência
    │   ├── application/                   # PassageRequest e GetPassageUseCase
    │   ├── data/                          # datasource, models, mapper e repository
    │   ├── domain/                        # passagem, versículo e exceção
    │   └── presentation/pages/bible_page.dart
    ├── home_screen/                       # versículo do dia e sugestão de hino
    │   ├── application/                   # casos de uso e ports
    │   ├── data/                          # datasources, models, mappers e repositories
    │   ├── domain/                        # entidades e exceções
    │   └── presentation/
    │       ├── pages/home_page.dart
    │       └── widgets/                   # cards da Home
    └── search_screen/                     # atalhos de busca por referência
        ├── application/
        ├── data/                          # consulta às APIs e modelos de resultado
        ├── domain/
        └── presentation/pages/search_page.dart
```

Regras que essa organização garante:

1.  **Nenhuma URL solta em feature.** Toda rota vem de
    `BibleApiEndpoints`.
2.  **Nenhuma feature importa arquivos internos de outra feature.**
    `search_screen` consulta a Bible API e a Harpa API pelos endpoints
    centrais e mantém seus próprios modelos de resultado; ela não chama
    casos de uso nem repositórios de `bible_screen` ou `harpa_screen`.
3.  **A composição e a navegação acontecem em `app/`**, via módulos,
    `AppDependencies` e `AppRouter`.

## 5. Camada compartilhada --- `core/infrastructure/network/`

### 5.1. `DioClient`

Cliente HTTP central da aplicação, construído sobre o pacote `dio`.

``` dart
class DioClient {
  DioClient({required String baseUrl}) : _dio = _buildDio(baseUrl);

  final Dio _dio;

  Dio get dio => _dio;
}
```

Configuração aplicada em `_buildDio`:

-   `baseUrl` recebido por parâmetro (o core não conhece fornecedor);
-   `connectTimeout`, `receiveTimeout` e `sendTimeout` de **15 segundos**;
-   `ResponseType.json`;
-   `LogInterceptor` com corpo de requisição e resposta (útil em
    desenvolvimento).

### 5.2. `BibleApiEndpoints`

Fonte única de verdade das URLs. É uma classe com construtor privado e
apenas membros estáticos, seguindo a convenção do projeto.

``` dart
class BibleApiEndpoints {
  const BibleApiEndpoints._();

  static const String baseUrl = 'https://bible-api.com';
  static const String defaultTranslation = 'kjv';

  static String passage(String reference) { ... }
  static String randomVerse(String translation, {List<String> bookIds = const []}) { ... }
  static String translations() { ... }
  static String books(String translation) { ... }
  static String chapters({required String translation, required String bookId}) { ... }
  static String verses({required String translation, required String bookId, required int chapter}) { ... }
}
```

## 6. Feature `bible_screen` --- busca por referência

### 6.1. Fluxo

``` text
BiblePage
  → GetPassageUseCase.execute(PassageRequest)
    → BibleRepository (port)
      → BibleApiRepository (implementação)
        → BibleRemoteDataSource
          → DioClient.get(BibleApiEndpoints.passage(ref))
            → GET /{reference}?translation=kjv
```

### 6.2. Contratos

**Port** (`application/ports/bible_repository.dart`):

``` dart
abstract interface class BibleRepository {
  Future<BiblePassage> getPassage({
    required String reference,
    required String translation,
  });
}
```

**DTO de entrada** (`application/dto/passage_request.dart`): mantém a
camada de aplicação independente de detalhes de transporte.

``` dart
class PassageRequest {
  const PassageRequest({required this.reference, this.translation = defaultTranslation});

  static const String defaultTranslation = 'kjv';

  final String reference;
  final String translation;
}
```

**Caso de uso**: valida a entrada (referência vazia) e delega ao port.

``` dart
Future<BiblePassage> execute(PassageRequest request) {
  final reference = request.reference.trim();
  if (reference.isEmpty) {
    throw ArgumentError('Informe uma referência bíblica.');
  }

  return _repository.getPassage(reference: reference, translation: request.translation);
}
```

### 6.3. Entidades

-   `BiblePassage`: `reference`, `verses`, `translationId`,
    `translationName`.
-   `BibleVerse`: `bookId`, `bookName`, `chapter`, `verse`, `text` e o
    getter `label` (`"John 3:16"`).

### 6.4. Formato da resposta

``` json
{
  "reference": "John 3:16",
  "verses": [
    {
      "book_id": "JHN",
      "book_name": "John",
      "chapter": 3,
      "verse": 16,
      "text": "\nFor God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.\n"
    }
  ],
  "text": "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.",
  "translation_id": "kjv",
  "translation_name": "King James Version",
  "translation_note": "Public Domain"
}
```

O campo `text` chega com quebras de linha nas extremidades; o model
normaliza com `trim()`.

## 7. Feature `home_screen` --- versículo do dia

### 7.1. Fluxo

``` text
HomePage
  → DailyVerseCard (stateful)
    → GetDailyVerseUseCase.execute()
      → DailyVerseRepository (port)
        → RemoteDailyVerseRepository (implementação)
          → HomeVerseRemoteDataSource
            → DioClient.get(BibleApiEndpoints.randomVerse('kjv'))
              → GET /data/kjv/random
```

### 7.2. Formato da resposta (diferente do `passage`)

Este endpoint responde em **outro formato**, com os dados aninhados:

``` json
{
  "translation": {
    "identifier": "kjv",
    "name": "King James Version",
    "language": "English",
    "language_code": "eng",
    "license": "Public Domain"
  },
  "random_verse": {
    "book_id": "PSA",
    "book": "Psalms",
    "chapter": 109,
    "verse": 27,
    "text": "That they may know that this\nis thy hand;\nthat\n thou, LORD, hast done it."
  }
}
```

Diferenças que o model precisa absorver:

-   os dados ficam em `random_verse`, não na raiz;
-   o nome do livro vem em `book` (no `passage` é `book_name`);
-   a tradução vem como objeto em `translation`, não em
    `translation_id` / `translation_name`.

### 7.3. Entidade e apresentação

`DailyVerse` guarda `bookId`, `bookName`, `chapter`, `verse`, `text`,
`translationId`, `translationName` e expõe o getter `reference`
(`"2 Crônicas 28:25"`).

O `DailyVerseCard` resolve os estados do carregamento:

-   **carregando** → `CircularProgressIndicator`;
-   **erro** → ícone, mensagem e botão **"Tentar novamente"**;
-   **sucesso** → texto e referência do versículo.

O callback para recarregar é usado no estado de erro. A Home não oferece
atualmente um botão de sucesso para solicitar outro versículo. O
`ScriptureVerseCard` aceita callbacks de salvar e compartilhar, mas a
Home ainda não os conecta.

## 8. Busca global como consumidora

`search_screen` consulta a Bible API diretamente pelo endpoint central
`BibleApiEndpoints.passage`, usando a tradução `kjv`. A feature só tenta
consultar a Bíblia quando a pesquisa contém pelo menos um algarismo, como
em `John 3:16`. Essa decisão é uma heurística para referências, não uma
busca textual livre.

O datasource da busca mantém modelos próprios para apresentar um atalho
com a referência e a quantidade de versículos. Ao selecionar esse
atalho, o `AppRouter` abre `bible_screen`, passa a referência como
argumento e a tela da Bíblia executa sua própria consulta. A busca não
importa nem reutiliza entidades, casos de uso ou repositórios internos
de `bible_screen`.

O fluxo completo e a integração paralela com a Harpa API estão em
[`Docs/global_search.md`](global_search.md).

## 9. Fiação em `app/`

As features não se conhecem, então a composição fica no `app/`.

### 9.1. Módulos

Cada feature expõe um ponto de entrada público:

``` dart
class BibleScreenModule {
  factory BibleScreenModule.create() {
    final repository = BibleApiRepository(
      BibleRemoteDataSource(DioClient(baseUrl: BibleApiEndpoints.baseUrl)),
    );

    return BibleScreenModule._(getPassageUseCase: GetPassageUseCase(repository));
  }

  BiblePage buildBiblePage() => BiblePage(getPassageUseCase: getPassageUseCase);
}
```

O mesmo padrão vale para `HomeScreenModule` (`buildHomePage()`) e
`SearchScreenModule` (`buildSearchPage()`).

### 9.2. Injeção de dependência

``` dart
factory AppDependencies.create() {
  return AppDependencies._(
    appNavigationBarModule: AppNavigationBarModule.create(),
    authenticationModule: AuthenticationModule.create(),
    splashModule: SplashModule.create(),
    bibleModule: BibleScreenModule.create(),
    homeModule: HomeScreenModule.create(),
    harpaModule: HarpaScreenModule.create(),
    libraryModule: LibraryScreenModule.create(),
    searchModule: SearchScreenModule.create(),
  );
}
```

### 9.3. Rotas

O router só conhece o módulo, nunca a página diretamente:

``` dart
case homeRoute:
  return MaterialPageRoute<void>(
    builder: (_) => _dependencies.homeModule.buildHomePage(),
    settings: settings,
  );
```

| Rota | Tela |
|---|---|
| `/` (`splashRoute`) | Splash (animação de entrada) |
| `/login` (`loginRoute`) | Login |
| `/home` (`homeRoute`) | Home com o versículo do dia |
| `/bible` (`bibleRoute`) | Consulta por referência |
| `/harpa` (`harpaRoute`) | Harpa Cristã |
| `/library` (`libraryRoute`) | Biblioteca |
| `/search` (`searchRoute`) | Busca global |

As rotas `/home`, `/bible`, `/harpa` e `/library` usam o `AppShell`, que
mantém a barra superior e a navegação inferior. Splash, login e busca não
usam esse shell. A busca abre a Bíblia com uma referência inicial ou a
Harpa com um número de hino por argumentos do router.

## 10. Como adicionar um novo consumo

Receita para plugar um endpoint em uma nova tela:

1.  **Confirme o formato da resposta** com uma chamada real antes de
    modelar. Endpoints diferentes da mesma API usam formatos diferentes.
2.  **`domain/entities/`** --- crie a entidade com os dados que a tela
    precisa.
3.  **`domain/exceptions/`** --- crie a exceção da feature (uma feature
    não importa a exceção de outra).
4.  **`data/models/`** --- crie o model com `fromJson`.
5.  **`data/mappers/`** --- crie a extensão `toEntity()`.
6.  **`data/datasources/`** --- receba o `DioClient`, monte a URL com
    `BibleApiEndpoints` e traduza `DioException` em exceção de domínio.
7.  **`application/ports/`** --- declare o contrato.
8.  **`data/repositories/`** --- implemente o contrato usando o
    datasource + mapper.
9.  **`application/use_cases/`** --- crie o caso de uso (validação de
    entrada fica aqui).
10. **`presentation/`** --- a tela/widget recebe o caso de uso por
    construtor.
11. **`<feature>_module.dart`** --- exponha a construção e o
    `buildXxxPage()`.
12. **`app/di/app_dependencies.dart`** --- registre o módulo.
13. **`app/router/app_router.dart`** --- aponte a rota para o módulo.

## 11. Tratamento de erros

O padrão é sempre o mesmo:

1.  O **datasource** captura `DioException` e lança uma exceção de
    domínio com mensagem amigável:

    ``` dart
    } on DioException catch (error) {
      throw BibleApiException(_describe(error));
    }
    ```

2.  Se a API responder um corpo com a chave `error`, a mensagem dela é
    propagada.

3.  A **apresentação** decide como exibir:
    -   `bible_page`: `try/catch` para `ArgumentError` (entrada inválida)
        e `BibleApiException` (falha na API);
    -   `daily_verse_card`: `FutureBuilder` + verificação de
        `DailyVerseException` para extrair a mensagem.

Mensagens atuais:

| Situação | Mensagem |
|---|---|
| Referência vazia | `Informe uma referência bíblica.` |
| 404 da API | Mensagem `error` fornecida pela API, prefixada com `Bible API:`; há mensagem genérica se o corpo não a informar |
| Falha de rede na consulta de passagem | `Não foi possível consultar a Bíblia agora. Verifique sua conexão.` |
| Falha de rede no versículo aleatório | `Não foi possível carregar o versículo. Verifique sua conexão.` |
| Resposta vazia | `Resposta vazia da API.` |

## 12. Requisitos de plataforma

-   **Pacote `dio`** (já declarado no `pubspec.yaml`, `^5.9.0`). Nenhuma
    outra dependência é necessária.
-   **Conexão com a internet** em tempo de execução.
-   **Android:** a permissão `android.permission.INTERNET` já está
    declarada em `android/app/src/main/AndroidManifest.xml`, permitindo
    chamadas de rede também em builds **release**:

    ``` xml
    <uses-permission android:name="android.permission.INTERNET"/>
    ```

-   **iOS:** nenhuma permissão extra é necessária, pois a API usa HTTPS.

## 13. Validação

Checagem estática:

``` shell
flutter analyze
```

Teste manual do fluxo completo:

1.  Abrir o app → splash → login.
2.  Na home, o card deve carregar um versículo aleatório.
3.  Abrir a aba Bíblia na navegação inferior e buscar `John 3:16`; a tela
    deve retornar o texto em
    inglês na King James Version.
4.  Testar uma referência inexistente (ex.: `John 99:99`) para ver a
    mensagem de 404.
5.  Na busca global, procurar `John 3:16`, abrir o atalho bíblico e
    confirmar que a tela da Bíblia carrega a referência.

Também é possível validar a API isoladamente, sem o app:

``` shell
curl "https://bible-api.com/John 3:16?translation=kjv"
curl "https://bible-api.com/data/kjv/random"
```

## 14. Limitações e próximos passos

-   **Dependência de rede.** O app não funciona offline. Para uma Bíblia
    offline, o caminho é embarcar um dataset de domínio público
    (JSON/SQLite) e deixar a API como complemento.
-   **Dataset completo não é baixado pela API.** O projeto oficial
    disponibiliza os dados para download; a API tem limite de uso e não
    deve ser usada como fonte de download.
-   **Cliente HTTP por módulo.** Os módulos criam seus próprios
    `DioClient`, inclusive a busca, que usa um cliente para cada API.
    Se for necessário compartilhar configuração ou interceptors, a
    composição pode ser centralizada em `app/di/`.
-   **Exceções duplicadas por design.** `BibleApiException` e
    `DailyVerseException` são distintas porque features não se enxergam.
    Se um terceiro consumidor da Bible API aparecer, vale promover uma
    exceção única para o `core`.
-   **Tradução padrão em dois lugares.** `BibleApiEndpoints` e
    `PassageRequest` declaram `'kjv'` separadamente.
