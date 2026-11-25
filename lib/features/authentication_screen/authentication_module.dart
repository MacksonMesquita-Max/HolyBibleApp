import 'application/use_cases/sign_in_with_email_use_case.dart';
import 'data/repositories/mock_authentication_repository.dart';
import 'presentation/pages/login_page.dart';

class AuthenticationModule {
  AuthenticationModule._({required this.signInUseCase});

  factory AuthenticationModule.create() {
    final authenticationRepository = MockAuthenticationRepository();

    return AuthenticationModule._(
      signInUseCase: SignInUseCase(authenticationRepository),
    );
  }

  final SignInUseCase signInUseCase;

  LoginPage buildLoginPage() {
    return LoginPage(signInUseCase: signInUseCase);
  }
}
