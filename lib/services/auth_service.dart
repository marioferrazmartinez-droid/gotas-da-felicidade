import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getCurrentUser() async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        // Criar usuário se não existir
        return await _createUserFromFirebaseUser(firebaseUser);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Login com Google cancelado');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Erro ao obter usuário do Firebase');
      }

      return await _getOrCreateUser(firebaseUser, 'google');
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        throw Exception('Login com Facebook cancelado ou falhou');
      }

      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Erro ao obter usuário do Firebase');
      }

      return await _getOrCreateUser(firebaseUser, 'facebook');
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Erro ao obter usuário do Firebase');
      }

      return await _getOrCreateUser(firebaseUser, 'email');
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signUpWithEmail(String email, String password, String displayName) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Erro ao criar usuário no Firebase');
      }

      // Atualizar display name
      await firebaseUser.updateDisplayName(displayName);

      return await _getOrCreateUser(firebaseUser, 'email', displayName: displayName);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signInAnonymously() async {
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Erro ao criar usuário anônimo');
      }

      return await _getOrCreateUser(firebaseUser, 'anonymous');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> _getOrCreateUser(User firebaseUser, String provider, {String? displayName}) async {
    try {
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists) {
        // Atualizar último login
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        return UserModel.fromMap(doc.data()!);
      } else {
        return await _createUserFromFirebaseUser(firebaseUser, provider: provider, displayName: displayName);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> _createUserFromFirebaseUser(User firebaseUser, {String provider = 'email', String? displayName}) async {
    final userModel = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: displayName ?? firebaseUser.displayName ?? 'Usuário',
      photoURL: firebaseUser.photoURL,
      provider: provider,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      preferences: {
        'language': 'pt',
        'notificationTime': '08:00',
        'categories': ['motivacional', 'inspiracao'],
      },
    );

    await _firestore.collection('users').doc(firebaseUser.uid).set(userModel.toMap());

    return userModel;
  }
}