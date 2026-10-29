import '../../../../core/utils/validators/email_validator.dart';
import '../../../../core/utils/validators/password_validator.dart';
import '../dto/login_request.dart';
import '../ports/authentication_repository.dart';

class SignInWithEmailUseCase {
  const SignInWithEmailUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<void> execute(LoginRequest request) async {
    final emailError = EmailValidator.validate(request.email);
    if (emailError != null) {
      throw ArgumentError(emailError);
    }

    final passwordError = PasswordValidator.validate(request.password);
    if (passwordError != null) {
      throw ArgumentError(passwordError);
    }

    await _authenticationRepository.signIn(
      email: request.email.trim(),
      password: request.password.trim(),
    );
  }
}
