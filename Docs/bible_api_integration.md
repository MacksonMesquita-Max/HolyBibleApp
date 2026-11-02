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

O aplicativo usa a tradução `almeida` (João Ferreira de Almeida, em
português, domínio público).

O identificador padrão é declarado em um único lugar:

``` dart
// core/infrastructure/network/bible_api_endpoints.dart
static const String defaultTranslation = 'almeida';
```

> Observação: a camada de aplicação da feature `bible_screen` também
> define `PassageRequest.defaultTranslation = 'almeida'`, que é o valor
> padrão do formulário de busca. Hoje o mesmo identificador existe nos
> dois pontos.

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
| Exemplos | `/João 3:16`, `/jn 3:16`, `/matt 25:31-33,46`, `/john 1` |

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
| `passage(reference)` | `/{reference}` | `bible_screen` |
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
    │   ├── bible_screen_module.dart
    │   ├── application/
    │   │   ├── dto/passage_request.dart
    │   │   ├── ports/bible_repository.dart
    │   │   └── use_cases/get_passage_use_case.dart
    │   ├── data/
    │   │   ├── datasources/bible_remote_datasource.dart
    │   │   ├── mappers/bible_passage_mapper.dart
    │   │   ├── models/bible_passage_model.dart
    │   │   ├── models/bible_verse_model.dart
    │   │   └── repositories/bible_api_repository.dart
    │   ├── domain/
    │   │   ├── entities/bible_passage.dart
    │   │   ├── entities/bible_verse.dart
    │   │   └── exceptions/bible_api_exception.dart
    │   └── presentation/pages/bible_page.dart
    │
    └── home_screen/                       # versículo do dia
        ├── home_screen_module.dart
        ├── application/
        │   ├── ports/daily_verse_repository.dart
        │   └── use_cases/get_daily_verse_use_case.dart
        ├── data/
        │   ├── datasources/home_verse_remote_data_source.dart
        │   ├── mappers/daily_verse_mapper.dart
        │   ├── models/daily_verse_model.dart
        │   └── repositories/remote_daily_verse_repository.dart
        ├── domain/
        │   ├── entities/daily_verse.dart
        │   └── exceptions/daily_verse_exception.dart
        └── presentation/
            ├── pages/home_page.dart
            └── widgets/daily_verse_card.dart
```

Regras que essa organização garante:

1.  **Nenhuma URL solta em feature.** Toda rota vem de
    `BibleApiEndpoints`.
2.  **Nenhuma feature importa outra feature.** `home_screen` e
    `bible_screen` não se conhecem; cada uma tem seus próprios
    repositórios, exceções e datasources.
3.  **A composição acontece em `app/`**, via módulos e `AppDependencies`.

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
  static const String defaultTranslation = 'almeida';

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
            → GET /{referência}?translation=almeida
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

  static const String defaultTranslation = 'almeida';

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
    getter `label` (`"João 3:16"`).

### 6.4. Formato da resposta

``` json
{
  "reference": "João 3:16",
  "verses": [
    {
      "book_id": "JHN",
      "book_name": "João",
      "chapter": 3,
      "verse": 16,
      "text": "\nPorque Deus amou o mundo...\n\n"
    }
  ],
  "text": "Porque Deus amou o mundo...",
  "translation_id": "almeida",
  "translation_name": "João Ferreira de Almeida",
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
            → DioClient.get(BibleApiEndpoints.randomVerse('almeida'))
              → GET /data/almeida/random
```

### 7.2. Formato da resposta (diferente do `passage`)

Este endpoint responde em **outro formato**, com os dados aninhados:

``` json
{
  "translation": {
    "identifier": "almeida",
    "name": "João Ferreira de Almeida",
    "language": "Portuguese",
    "language_code": "por",
    "license": "Public Domain"
  },
  "random_verse": {
    "book_id": "2CH",
    "book": "2 Crônicas",
    "chapter": 28,
    "verse": 25,
    "text": "Também em cada cidade de Judá fez altos..."
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

O `DailyVerseCard` resolve os três estados da tela:

-   **carregando** → `CircularProgressIndicator`;
-   **erro** → ícone, mensagem e botão **"Tentar novamente"**;
-   **sucesso** → título "Versículo do dia", texto, referência, tradução
    e o botão **"Mostrar outro versículo"**.

Cada novo toque em "outro versículo" cria um novo `Future` e chama o
caso de uso novamente.

## 8. Fiação em `app/`

As features não se conhecem, então a composição fica no `app/`.

### 8.1. Módulos

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

O mesmo padrão vale para `HomeScreenModule` (`buildHomePage()`).

### 8.2. Injeção de dependência

``` dart
factory AppDependencies.create() {
  return AppDependencies._(
    authenticationModule: AuthenticationModule.create(),
    splashModule: SplashModule.create(),
    bibleModule: BibleScreenModule.create(),
    homeModule: HomeScreenModule.create(),
  );
}
```

### 8.3. Rotas

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
| `/bible` (`bibleRoute`) | Busca por referência |

## 9. Como adicionar um novo consumo

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

## 10. Tratamento de erros

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
| 404 na busca | `Referência não encontrada. Confira livro, capítulo e versículo.` |
| 404 no aleatório | `Nenhum versículo disponível para esta tradução.` |
| Falha de rede | `Não foi possível carregar o versículo. Verifique sua conexão.` |
| Resposta vazia | `Resposta vazia da API.` |

## 11. Requisitos de plataforma

-   **Pacote `dio`** (já declarado no `pubspec.yaml`, `^5.9.0`). Nenhuma
    outra dependência é necessária.
-   **Conexão com a internet** em tempo de execução.
-   **Android:** o arquivo `android/app/src/main/AndroidManifest.xml`
    **não** declara a permissão `android.permission.INTERNET`. As
    variantes `debug` e `profile` declaram, por isso o app funciona ao
    rodar com `flutter run`; já em um APK **release** as chamadas de rede
    falham. Para corrigir, é necessário adicionar dentro de `<manifest>`:

    ``` xml
    <uses-permission android:name="android.permission.INTERNET"/>
    ```

-   **iOS:** nenhuma permissão extra é necessária, pois a API usa HTTPS.

## 12. Validação

Checagem estática:

``` shell
dart analyze lib
```

Teste manual do fluxo completo:

1.  Abrir o app → splash → login.
2.  Na home, o card deve carregar um versículo aleatório.
3.  Tocar em "Mostrar outro versículo" deve trazer outro texto.
4.  "Abrir a Bíblia" → buscar `João 3:16` deve retornar o texto em
    português.
5.  Testar uma referência inexistente (ex.: `João 99:99`) para ver a
    mensagem de 404.

Também é possível validar a API isoladamente, sem o app:

``` shell
curl "https://bible-api.com/João 3:16?translation=almeida"
curl "https://bible-api.com/data/almeida/random"
```

## 13. Limitações e próximos passos

-   **Dependência de rede.** O app não funciona offline. Para uma Bíblia
    offline, o caminho é embarcar um dataset de domínio público
    (JSON/SQLite) e deixar a API como complemento.
-   **Dataset completo não é baixado pela API.** O projeto oficial
    disponibiliza os dados para download; a API tem limite de uso e não
    deve ser usada como fonte de download.
-   **Cliente HTTP por feature.** Hoje `bible_screen` e `home_screen`
    criam cada uma o seu próprio `DioClient`. Se surgir uma terceira,
    vale criar um único cliente em `app/di/` e injetá-lo nos módulos.
-   **Exceções duplicadas por design.** `BibleApiException` e
    `DailyVerseException` são distintas porque features não se enxergam.
    Se um terceiro consumidor da Bible API aparecer, vale promover uma
    exceção única para o `core`.
-   **Tradução padrão em dois lugares.** `BibleApiEndpoints` e
    `PassageRequest` declaram `'almeida'` separadamente.
