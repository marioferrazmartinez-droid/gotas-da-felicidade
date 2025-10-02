import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _rememberMe = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  bool get isLoggedIn => _user != null;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular login
      await Future.delayed(const Duration(seconds: 2));

      _user = User(
        id: '1',
        email: email,
        name: 'Usuário',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular cadastro
      await Future.delayed(const Duration(seconds: 2));

      _user = User(
        id: '1',
        email: email,
        name: name,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular login com Google
      await Future.delayed(const Duration(seconds: 2));

      _user = User(
        id: '1',
        email: 'usuario@gmail.com',
        name: 'Usuário Google',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simular reset de senha
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    _rememberMe = false;
    notifyListeners();
  }
}