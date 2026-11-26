# Persistência Local de Sessão e Dados do Usuário

## 1. Objetivo

Este documento define como o **Verbum - Bíblia Sagrada** deverá manter
localmente a sessão e os dados mínimos do usuário entre execuções do
aplicativo, sem depender de autenticação em servidor.

O comportamento esperado é:

- Após um login local bem-sucedido, o app mantém o nome informado no
  dispositivo.
- Ao fechar e abrir o app novamente, a pessoa continua na sessão e segue
  para a Home sem precisar preencher o login outra vez.
- Ao selecionar **Sair do app** na Biblioteca, o app remove os dados da
  sessão local e retorna para o login.
- A senha nunca é salva.

Este documento descreve a arquitetura planejada. **A persistência local
descrita aqui ainda não está implementada.**

## 2. Estado Atual

Atualmente, o login é mockado:

- `LoginPage` valida nome completo e senha.
- `MockAuthenticationRepository` aguarda brevemente e considera o login
  concluído, sem validar credenciais contra um servidor.
- O nome é encaminhado ao `AppRouter` por um callback e mantido apenas em
  memória.
- O encerramento do processo do app perde esse nome.
- A splash navega diretamente para a tela de login.
- O botão de saída da Biblioteca retorna para o login, mas ainda não
  remove uma sessão persistida.
- O card “Sua jornada” na Home usa valores demonstrativos fixos; o
  progresso de leitura ainda não é salvo nem restaurado.

Portanto, a funcionalidade futura será uma **restauração de sessão local
para conveniência**, não uma autenticação real nem uma barreira de
segurança.

## 3. Escopo e Decisões

### 3.1. Dados da sessão

Na primeira implementação, a sessão persistida terá somente o nome
completo necessário para personalizar a Home.

| Dado | Persistir? | Remover ao sair? | Motivo |
|---|---:|---:|---|
| Nome completo | Sim | Sim | Restaurar a saudação e identificar a sessão local |
| Senha | Não | Não se aplica | Não é necessária para restaurar a sessão e não deve ser armazenada |
| Estado de sessão | Derivado do nome válido salvo | Sim | Evita manter um indicador duplicado que possa divergir do perfil |
| Cache de conteúdo bíblico público | Não faz parte da sessão | Não por padrão | O conteúdo não pertence a uma identidade local |
| Preferências globais do app | Não faz parte da sessão | Não por padrão | Devem sobreviver ao logout, salvo decisão futura |
| Versículos ou outros dados pessoais futuros | A definir por feature | A definir | A política de retenção deverá ser documentada antes da implementação |

Uma sessão é considerada válida quando o nome salvo existe, não está vazio
e atende às regras de validação de nome completo. Se o valor estiver
ausente ou inválido, o app deverá tratar a pessoa como desconectada.

### 3.2. Armazenamento

Para o nome e outros valores pequenos e não sensíveis, será usado o pacote
`shared_preferences`.

Esse armazenamento:

- Persiste valores entre encerramentos e reinicializações do app.
- Não sincroniza dados entre dispositivos.
- É removido quando os dados do app são apagados ou quando ele é
  desinstalado.
- Não é armazenamento criptografado nem deve ser usado para senhas,
  tokens ou segredos.

Embora seja comum chamar isso de “cache”, a sessão será tratada como
**preferência/estado local persistente**, e não como cache temporário que
pode ser descartado pelo sistema operacional.

### 3.3. Limite de segurança

Como o login continua mockado, os dados locais podem ser modificados ou
removidos por alguém com acesso ao dispositivo. A presença do nome salvo
apenas permite restaurar a experiência da sessão.

Este mecanismo não deve ser usado para proteger dados confidenciais ou
autorizar operações em serviços remotos. Se o app passar a usar
autenticação real, tokens e credenciais deverão seguir uma estratégia
segura própria; a senha não deve ser persistida.

## 4. Responsabilidades na Arquitetura

A persistência pertence à feature `authentication_screen`, porque os
dados descrevem a sessão e o perfil autenticado localmente. Não será
criada uma feature separada de sessão nesta etapa.

Estrutura planejada:

```text
lib/features/authentication_screen/
  application/
    ports/
      authentication_repository.dart
    use_cases/
      sign_in_use_case.dart
      restore_session_use_case.dart
      sign_out_use_case.dart
  data/
    datasources/
      local_session_data_source.dart
    repositories/
      local_authentication_repository.dart
  domain/
    entities/
      user_session.dart
```

Os nomes são uma proposta de organização e poderão ser ajustados para
manter consistência com a implementação existente.

No código atual, o caso de uso é a classe `SignInUseCase`, recebe um
`LoginRequest` com nome completo e senha e vive no arquivo legado
`sign_in_with_email_use_case.dart`. O nome do arquivo deverá ser alinhado
ao fluxo por nome durante a implementação ou uma limpeza dedicada.

Responsabilidades:

- **Presentation:** coleta os dados do formulário e apresenta os estados
  de carregamento e erro. Não lê nem grava `SharedPreferences`
  diretamente.
- **Application:** define as operações de entrar, restaurar e encerrar a
  sessão através de casos de uso e contratos.
- **Domain:** representa a sessão local com os dados necessários à
  aplicação, sem conhecer a biblioteca de armazenamento.
- **Data:** implementa o acesso local e o contrato do repositório.
- **App:** compõe os módulos, coordena a navegação global e entrega
  callbacks entre telas. Não deixa uma feature acessar os arquivos
  internos de outra.

O `LocalSessionDataSource` deverá encapsular as chaves e operações do
armazenamento. Uma chave possível é
`verbum.auth.session.full_name`. A chave deverá ficar centralizada no
datasource, sem strings repetidas pela aplicação.

## 5. Operações Planejadas

### 5.1. Criar sessão após o login

1. A pessoa informa nome completo e senha na tela de login.
2. Os validadores atuais verificam os campos.
3. O caso de uso executa o fluxo de login mockado.
4. Após sucesso, o repositório salva somente o nome completo normalizado.
5. A tela sinaliza o sucesso ao nível `app`.
6. O router mantém o usuário atual em memória e abre a Home.

O app só deverá navegar para a Home depois que a gravação local terminar
com sucesso. A senha pode permanecer na memória apenas durante o envio do
formulário e não deverá ser escrita no armazenamento local ou em logs.

### 5.2. Restaurar sessão ao iniciar

1. O app apresenta a splash.
2. Ao concluir a animação, o nível `app` solicita a restauração da sessão.
3. O repositório lê o nome salvo e valida o valor.
4. Se houver uma sessão válida, o router atualiza o usuário em memória e
   navega para a Home.
5. Se não houver sessão válida, navega para o login.
6. Se houver dados incompletos ou inválidos, o app remove esses dados
   inválidos e segue para o login, sem interromper a inicialização.

A splash deve continuar responsável pela apresentação da animação. A
decisão de navegação deve ser coordenada pelo `app` usando o resultado do
caso de uso, sem fazer a splash acessar diretamente o datasource.

### 5.3. Encerrar sessão

1. O botão **Sair do app** continua apresentado na Biblioteca.
2. A Biblioteca dispara um callback recebido pela composição do app.
3. O `app` chama o caso de uso de encerramento de sessão.
4. O repositório remove o nome salvo.
5. Após a remoção, o `app` limpa o nome mantido em memória e navega para
   o login, removendo as rotas anteriores.

A lógica de persistência não deverá ficar dentro do botão compartilhado
nem fazer a Biblioteca importar a implementação interna da feature de
autenticação. Se a remoção falhar, a sessão não deverá ser apresentada
como encerrada; o app deve informar o erro e permitir uma nova tentativa.

## 6. Contrato de Repositório

O contrato de autenticação existente deverá evoluir para representar as
operações locais. A forma final poderá variar, mas deverá cobrir:

```dart
abstract interface class AuthenticationRepository {
  Future<void> signIn({
    required String fullName,
    required String password,
  });

  Future<String?> restoreSession();

  Future<void> signOut();
}
```

`restoreSession` retorna o nome salvo somente quando houver uma sessão
válida. O contrato não expõe `SharedPreferences` nem outros detalhes de
implementação.

O datasource local deverá oferecer operações equivalentes a:

```dart
Future<void> saveFullName(String fullName);
Future<String?> readFullName();
Future<void> clearSession();
```

Os exemplos são ilustrativos; a implementação deve seguir os tipos e o
padrão `Result<T>` adotados no restante do projeto quando aplicável.

## 7. Composição e Navegação

`AppDependencies` deverá construir o datasource, repositório e casos de
uso uma única vez e injetá-los nos módulos necessários.

O `AppRouter` ou um coordenador no nível `app` deverá:

- Executar a restauração após a splash.
- Manter o nome atual em memória para alimentar as telas que precisam
  dele.
- Abrir a Home quando a restauração tiver sucesso.
- Abrir o login quando não houver sessão.
- Fornecer à Biblioteca uma ação de logout que execute o caso de uso e
  depois faça a navegação.

As features não devem navegar para arquivos ou páginas internas umas das
outras. A navegação e a comunicação entre `authentication_screen`,
`splash_screen` e `library_screen` continuam sendo coordenadas em `app/`.

## 8. Retenção dos Dados

O logout deverá remover apenas os dados definidos como pertencentes à
sessão local.

Na primeira entrega:

- **Remover:** nome completo salvo e qualquer estado local que represente
  a sessão.
- **Não remover por padrão:** preferências globais e conteúdo bíblico
  público em cache.
- **Não há ainda dados pessoais persistidos:** favoritos e outros dados da
  Biblioteca ainda não têm uma política de retenção nesta implementação.

Antes de persistir favoritos, progresso de leitura ou outras informações
pessoais, deverá ser decidido se esses dados pertencem à sessão e se o
logout deve removê-los. Essa decisão não deve ser implícita em um comando
genérico de limpar todo o armazenamento do app.

## 9. Tratamento de Falhas

- **Chave ausente:** interpretar como sessão inexistente e abrir o login.
- **Nome vazio ou inválido:** limpar a entrada inválida e abrir o login.
- **Falha ao ler durante a inicialização:** não travar o app; tratar como
  sessão não restaurada e seguir para o login.
- **Falha ao salvar após o login:** não abrir a Home como se a sessão
  persistida tivesse sido criada; apresentar uma mensagem recuperável.
- **Falha ao remover durante o logout:** manter a pessoa na tela atual,
  informar o erro e não afirmar que o logout foi concluído.

Erros técnicos podem ser registrados para diagnóstico sem incluir senha
ou outros dados sensíveis.

## 10. Testes Planejados

### Datasource

- Salva e lê o nome completo.
- Retorna ausência quando a chave não existe.
- Remove os dados da sessão sem limpar outras preferências do app.
- Trata valores vazios ou inválidos.

### Repositório e casos de uso

- Um login válido persiste o nome depois do sucesso mockado.
- Um login inválido não cria sessão.
- A restauração retorna o nome salvo.
- O logout remove a sessão.
- Nenhum fluxo persiste a senha.
- Falhas de leitura, escrita e remoção são propagadas ou convertidas para
  o resultado definido pela aplicação.

### Navegação

- Primeira abertura, sem sessão, segue da splash para o login.
- Reabertura com sessão válida segue da splash para a Home.
- Sessão inválida segue para o login.
- Logout pela Biblioteca limpa a sessão e retorna ao login.
- A Home recebe o nome restaurado e apresenta a saudação corretamente.

## 11. Etapas de Implementação

1. Adicionar `shared_preferences` ao projeto e definir o datasource local.
2. Introduzir a representação da sessão e evoluir o contrato de
   `AuthenticationRepository`.
3. Implementar a gravação após login e os casos de uso de restauração e
   logout.
4. Registrar dependências e casos de uso em `AppDependencies`.
5. Alterar o fluxo da splash para consultar a sessão e decidir o destino.
6. Injetar a ação de logout na Biblioteca através do nível `app`.
7. Criar testes unitários e de navegação para os cenários descritos.
8. Atualizar esta documentação se as decisões ou os nomes finais
   divergirem do plano.

## 12. Critérios de Aceite

- O app continua abrindo o login na primeira execução, sem sessão salva.
- Um login mockado bem-sucedido persiste o nome, mas nunca a senha.
- Fechar e reabrir o app com uma sessão válida leva à Home.
- A Home mostra o nome restaurado.
- O botão da Biblioteca encerra a sessão, limpa os dados definidos e
  retorna ao login.
- Falhas de persistência não deixam a navegação em um estado inconsistente.
- A camada de apresentação não acessa diretamente `SharedPreferences`.
- As features permanecem desacopladas e a composição continua em `app/`.

## 13. Referências

- `Docs/feature_first_architecture.md`
- `lib/features/authentication_screen/`
- `lib/features/splash_screen/`
- `lib/features/library_screen/`
- `lib/app/di/app_dependencies.dart`
- `lib/app/router/app_router.dart`
