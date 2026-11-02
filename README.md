# Verbum - Bíblia Sagrada

Aplicativo mobile de leitura da Bíblia Sagrada, desenvolvido em **Flutter**,
com busca de passagens por referência e um versículo do dia na tela inicial.

## Sobre

O app consome a [Bible API](https://bible-api.com/) para exibir o texto
bíblico em português (tradução João Ferreira de Almeida, domínio público).
A autenticação é **mockada** nesta fase: não há backend próprio nem
integração real de login.

## Stack

| Item | Versão / pacote |
|---|---|
| Flutter | SDK estável |
| Dart | `^3.12.2` |
| HTTP | [`dio`](https://pub.dev/packages/dio) `^5.9.0` |
| Tipografia | [`google_fonts`](https://pub.dev/packages/google_fonts) `^8.2.1` |
| Ícones vetoriais | [`flutter_svg`](https://pub.dev/packages/flutter_svg) `^2.3.0` |
| Animações | [`lottie`](https://pub.dev/packages/lottie) `^3.7.0` |

## Arquitetura

O projeto segue **Feature-First + Clean Architecture + DDD leve**, com o
código organizado por funcionalidade de negócio:

``` text
lib/
├── app/        # inicialização, DI, rotas, tema, constantes
├── core/       # recursos compartilhados e contratos transversais
├── shared/     # widgets e utilitários genéricos (sem regra de negócio)
└── features/   # funcionalidades, cada uma com suas camadas
```

Cada feature mantém sua própria fatia vertical:

``` text
features/<feature>/
├── <feature>_module.dart   # ponto de entrada público
├── presentation/           # telas, widgets, cubits
├── application/            # casos de uso, ports, DTOs
├── domain/                 # entidades, value objects, exceções
└── data/                   # datasources, models, mappers, repositórios
```

Regras principais:

-   Direção de dependência: `presentation` → `application` → `domain`.
-   **Uma feature não acessa arquivos internos de outra feature.** A
    comunicação entre features acontece via módulos, compostos em `app/`.
-   Inversão de dependência (DIP): os contratos ficam em `application` /
    `domain` e as implementações em `data`.
-   Constantes centralizadas em classes com construtor privado.

O documento completo está em
[Docs/feature_first_architecture.md](Docs/feature_first_architecture.md).

## Features

| Feature | Descrição |
|---|---|
| `splash_screen` | Animação de entrada, exibida antes do login |
| `authentication_screen` | Login (autenticação mockada) |
| `home_screen` | Tela inicial com o versículo do dia |
| `bible_screen` | Busca de passagens por referência |

## Consumo da API

### Qual API usamos

[**Bible API**](https://bible-api.com/) --- `https://bible-api.com`

-   Sem autenticação: nenhuma API key ou token.
-   HTTPS com CORS habilitado, respostas em JSON.
-   Tradução padrão do app: `almeida` (português, domínio público).
-   Limite de uso: **15 requisições a cada 30 segundos por IP**.
-   Sem SLA: é um projeto de código aberto mantido por hobby.

### Endpoints usados

| Uso | Endpoint |
|---|---|
| Busca por referência | `GET /{referência}?translation=almeida` |
| Versículo do dia | `GET /data/almeida/random` |

Exemplos:

``` shell
curl "https://bible-api.com/João 3:16?translation=almeida"
curl "https://bible-api.com/data/almeida/random"
```

### Como o consumo está organizado

-   As URLs ficam centralizadas em
    `core/infrastructure/network/bible_api_endpoints.dart`; nenhuma
    feature monta URL manualmente.
-   O cliente HTTP é o `DioClient`, em
    `core/infrastructure/network/dio_client.dart`.
-   Cada feature implementa sua própria fatia (`data` → `application` →
    `presentation`) e recebe os casos de uso por injeção de dependência
    através do seu módulo.

Fluxo de uma requisição:

``` text
Tela → UseCase → Port (application) → Repository (data)
     → DataSource → DioClient → Bible API
```

### Requisitos

-   Conexão com a internet em tempo de execução.
-   Em builds **release** para Android, garanta que a permissão
    `android.permission.INTERNET` esteja declarada no
    `AndroidManifest.xml`.

> O app ainda **não funciona offline**. Para isso, o caminho previsto é
> embarcar um dataset de domínio público (JSON/SQLite) e manter a API
> como complemento.

A documentação detalhada da integração está em
[Docs/bible_api_integration.md](Docs/bible_api_integration.md).

## Como executar

``` shell
flutter pub get
flutter run
```

Gerar APK:

``` shell
flutter build apk --debug     # desenvolvimento
flutter build apk --release   # produção
```

O APK é gerado em `build/app/outputs/flutter-apk/`.

Verificação estática:

``` shell
dart analyze lib
```

## Documentação

-   [Arquitetura Feature-First](Docs/feature_first_architecture.md)
-   [Integração com a Bible API](Docs/bible_api_integration.md)
