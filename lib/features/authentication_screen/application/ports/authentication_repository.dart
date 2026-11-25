abstract interface class AuthenticationRepository {
  Future<void> signIn({required String fullName, required String password});
}
