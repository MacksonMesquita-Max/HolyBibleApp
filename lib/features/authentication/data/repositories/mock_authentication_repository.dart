import '../../application/ports/authentication_repository.dart';

class MockAuthenticationRepository implements AuthenticationRepository {
  @override
  Future<void> signIn({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
