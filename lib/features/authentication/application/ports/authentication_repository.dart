abstract interface class AuthenticationRepository {
  Future<void> signIn({required String email, required String password});
}
