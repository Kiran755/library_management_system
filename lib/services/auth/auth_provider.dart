import "auth_user.dart";

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialze();
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}
