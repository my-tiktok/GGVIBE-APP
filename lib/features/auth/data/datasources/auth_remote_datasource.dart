import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('Login failed');
      }
      return UserModel.fromFirebaseUser(credential.user!);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signup(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw Exception('Signup failed');
      }
      return UserModel.fromFirebaseUser(credential.user!);
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw Exception('Get current user failed: ${e.toString()}');
    }
  }
}
