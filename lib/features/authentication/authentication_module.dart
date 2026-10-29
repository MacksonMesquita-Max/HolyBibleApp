import 'application/use_cases/sign_in_with_email_use_case.dart';
import 'data/repositories/mock_authentication_repository.dart';
import 'presentation/pages/login_page.dart';

class AuthenticationModule {
  AuthenticationModule._({required this.signInWithEmailUseCase});

  factory AuthenticationModule.create() {
    final authenticationRepository = MockAuthenticationRepository();

    return AuthenticationModule._(
      signInWithEmailUseCase: SignInWithEmailUseCase(authenticationRepository),
    );
  }

  final SignInWithEmailUseCase signInWithEmailUseCase;

  LoginPage buildLoginPage() {
    return LoginPage(signInWithEmailUseCase: signInWithEmailUseCase);
  }
}
