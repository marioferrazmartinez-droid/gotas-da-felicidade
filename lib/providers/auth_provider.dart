import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart' as app_model;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  app_model.UserModel? _user;
  bool _isLoading = false;
  bool _rememberMe = false;

  app_model.UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedName = prefs.getString('user_name');

    if (savedEmail != null && _rememberMe) {
      _user = app_model.UserModel(
        id: '1',
        email: savedEmail,
        name: savedName ?? 'Usuário',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Login bem-sucedido: ${userCredential.user?.uid}');
      _user = _userFromFirebase(userCredential.user!);

      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', _user!.name!);
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('❌ Erro no login: ${e.message}');
      _isLoading = false;
      notifyListeners();
      throw e.message ?? 'Erro no login';
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🔄 Iniciando cadastro para: $email');

      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Usuário criado no Firebase: ${userCredential.user?.uid}');

      // Criar usuário localmente sem usar _userFromFirebase
      final firebaseUser = userCredential.user!;
      _user = app_model.UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        name: name,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        lastLogin: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
      );

      print('✅ Usuário local criado: ${_user!.name}');

      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', name);
        print('✅ Dados salvos localmente');
      }

      _isLoading = false;
      notifyListeners();
      print('🎉 Cadastro concluído com sucesso! Usuário autenticado: ${_user != null}');

    } on FirebaseAuthException catch (e) {
      print('❌ Erro Firebase no cadastro: ${e.code} - ${e.message}');
      _isLoading = false;
      notifyListeners();

      // Mensagens mais amigáveis
      String errorMessage = 'Erro no cadastro';
      if (e.code == 'weak-password') {
        errorMessage = 'A senha é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este email já está em uso';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Email inválido';
      } else {
        errorMessage = e.message ?? 'Erro ao criar conta';
      }

      throw errorMessage;
    } catch (e) {
      print('❌ Erro geral no cadastro: $e');
      _isLoading = false;
      notifyListeners();
      throw 'Erro ao criar conta. Tente novamente.';
    }
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Login cancelado');

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      _user = _userFromFirebase(userCredential.user!);

      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', _user!.email!);
        await prefs.setString('user_name', _user!.name!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e.message ?? 'Erro ao enviar email de recuperação';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    _rememberMe = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    notifyListeners();
  }

  app_model.UserModel _userFromFirebase(User firebaseUser) {
    // Método mais seguro para evitar nulls
    final String userEmail = firebaseUser.email ?? 'email@nao.informado';
    final String userName = firebaseUser.displayName ?? userEmail.split('@').first;
    final DateTime userCreated = firebaseUser.metadata.creationTime ?? DateTime.now();
    final DateTime userLastLogin = firebaseUser.metadata.lastSignInTime ?? DateTime.now();

    return app_model.UserModel(
      id: firebaseUser.uid,
      email: userEmail,
      name: userName,
      createdAt: userCreated,
      lastLogin: userLastLogin,
    );
  }
}