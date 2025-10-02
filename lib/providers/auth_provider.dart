import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar usuário: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithGoogle();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Erro no login com Google: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithFacebook() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithFacebook();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Erro no login com Facebook: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmail(email, password);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Erro no login com email: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInAnonymously() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInAnonymously();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Erro no login anônimo: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao fazer logout: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String displayName, String? photoURL) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.updateUserProfile(displayName, photoURL);

      // Atualizar usuário local
      if (_currentUser != null) {
        _currentUser = UserModel(
          uid: _currentUser!.uid,
          email: _currentUser!.email,
          displayName: displayName,
          photoURL: photoURL,
          provider: _currentUser!.provider,
          createdAt: _currentUser!.createdAt,
          lastLogin: _currentUser!.lastLogin,
          isPremium: _currentUser!.isPremium,
          dailyMessageCount: _currentUser!.dailyMessageCount,
          favoriteMessages: _currentUser!.favoriteMessages,
        );
      }

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar perfil: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para atualizar email (usando a nova API)
  Future<bool> updateEmail(String newEmail) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Usando a nova API recomendada
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        _errorMessage = 'Email de verificação enviado para $newEmail';
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar email: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool get isLoggedIn => _currentUser != null;
}