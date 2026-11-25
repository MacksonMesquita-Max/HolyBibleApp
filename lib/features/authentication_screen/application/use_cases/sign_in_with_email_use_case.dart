import '../../../../core/utils/validators/full_name_validator.dart';
import '../../../../core/utils/validators/password_validator.dart';
import '../dto/login_request.dart';
import '../ports/authentication_repository.dart';

class SignInUseCase {
  const SignInUseCase(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;

  Future<void> execute(LoginRequest request) async {
    final fullNameError = FullNameValidator.validate(request.fullName);
    if (fullNameError != null) {
      throw ArgumentError(fullNameError);
    }

    final passwordError = PasswordValidator.validate(request.password);
    if (passwordError != null) {
      throw ArgumentError(passwordError);
    }

    await _authenticationRepository.signIn(
      fullName: request.fullName.trim(),
      password: request.password.trim(),
    );
  }
}
