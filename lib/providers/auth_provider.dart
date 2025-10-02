import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required this.authService});

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await authService.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro ao inicializar auth: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await authService.signInWithGoogle();
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro no login com Google: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await authService.signInWithFacebook();
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro no login com Facebook: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await authService.signInWithEmail(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro no login com email: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await authService.signUpWithEmail(email, password, displayName);
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro no cadastro com email: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInAnonymously() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await authService.signInAnonymously();
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro no login anônimo: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.signOut();
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Erro ao fazer logout: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}