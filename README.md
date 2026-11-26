# Verbum - Bíblia Sagrada

Aplicativo mobile de leitura bíblica e hinos cristãos, desenvolvido em
**Flutter**, com busca por referência, conteúdo da Harpa Cristã e um
versículo aleatório na tela inicial.

## Sobre

O app consome a [Bible API](https://bible-api.com/) para exibir o texto
bíblico em inglês na tradução King James Version (KJV, domínio público).
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
| Animação de entrada | Flutter nativo |

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
├── presentation/           # telas e widgets
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
-   Widgets genéricos ficam em `shared/`; componentes exclusivos de uma
    funcionalidade permanecem dentro da feature proprietária.
-   Os botões visuais usam `PrimaryButton`, `SecondaryButton`,
    `TextActionButton` ou `IconActionButton`, em
    `shared/widgets/buttons/`.

O documento completo está em
[Docs/feature_first_architecture.md](Docs/feature_first_architecture.md).

## Features

| Feature | Descrição |
|---|---|
| `splash_screen` | Animação de entrada, exibida antes do login |
| `authentication_screen` | Login mockado, sem servidor de autenticação |
| `app_navigation_bar` | Navegação entre Início, Bíblia, Harpa Cristã e Biblioteca |
| `home_screen` | Saudação, versículo aleatório, sugestão de hino e progresso demonstrativo |
| `bible_screen` | Consulta de passagens por referência |
| `harpa_screen` | Exibição da letra de um hino selecionado |
| `search_screen` | Busca integrada e atalhos para Bíblia ou Harpa |
| `library_screen` | Biblioteca e ação para sair do app |

O progresso exibido em “Sua jornada” é demonstrativo e ainda não é
persistido. O nome do usuário também não é restaurado após reiniciar o
app. O plano de persistência local está em
[Docs/local_session_persistence.md](Docs/local_session_persistence.md).

## Consumo das APIs

### Qual API usamos

[**Bible API**](https://bible-api.com/) --- `https://bible-api.com`

-   Sem autenticação: nenhuma API key ou token.
-   HTTPS com CORS habilitado, respostas em JSON.
-   Tradução padrão do app: `kjv` (King James Version, inglês, domínio público).
-   Limite de uso: **15 requisições a cada 30 segundos por IP**.
-   Sem SLA: é um projeto de código aberto mantido por hobby.

### Endpoints usados

| Uso | Endpoint |
|---|---|
| Busca por referência | `GET /{reference}?translation=kjv` |
| Versículo do dia | `GET /data/kjv/random` |

Exemplos:

``` shell
curl "https://bible-api.com/John 3:16?translation=kjv"
curl "https://bible-api.com/data/kjv/random"
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

### Harpa Cristã

O app também consome a
[Harpa API](https://github.com/ronisdev/harpa-api), hospedada em
`https://harpa-api.onrender.com`. A Home busca um hino aleatório; a tela
Harpa carrega os detalhes por número; a busca consulta título e trecho e,
quando a entrada é numérica, também pesquisa pelo número do hino. O app
não configura API key.

Os endpoints ficam em
`core/infrastructure/network/harpa_api_endpoints.dart`. Os resultados da
busca são atalhos; o texto completo do hino é carregado na tela Harpa.
Detalhes em [Docs/harpa_api_integration.md](Docs/harpa_api_integration.md).

### Busca global

A Bible API permite buscar por referência, como `John 3:16`, mas não
oferece busca textual livre em toda a Bíblia. A pesquisa de hinos usa os
endpoints de título, trecho e número da Harpa API. Ao tocar em um
resultado, o `AppRouter` abre a tela correspondente com a referência ou
número do hino.

Veja [Docs/global_search.md](Docs/global_search.md).

## Interface e plataforma

O app usa uma animação de entrada nativa em Flutter. Em `main.dart`, a
interface configura o modo `immersiveSticky` e barras de sistema
transparentes. O sistema operacional pode exibi-las temporariamente após
um gesto do usuário; a tela de login define a aparência da barra de
status enquanto está ativa.

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

Análise estática e testes:

``` shell
flutter analyze
flutter test
```

## Documentação

-   [Arquitetura Feature-First](Docs/feature_first_architecture.md)
-   [Integração com a Bible API](Docs/bible_api_integration.md)
-   [Integração com a Harpa API](Docs/harpa_api_integration.md)
-   [Busca global](Docs/global_search.md)
-   [Plano de persistência local](Docs/local_session_persistence.md)
