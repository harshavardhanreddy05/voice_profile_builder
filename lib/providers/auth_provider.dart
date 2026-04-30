import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _userModel;

  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _firebaseUser != null;

  AuthProvider() {
    _listenToAuthChanges();
  }
  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _firebaseUser = user;

      if (user != null) {
        await _loadUserFromFirestore(user.uid);
      } else {
        _userModel = null;
      }

      notifyListeners();
    });
  }
  Future<void> _loadUserFromFirestore(String uid) async {
    try {
      final data = await _firestoreService.getUser(uid);

      if (data != null) {
        _userModel = UserModel.fromMap(data);
      } else {
        _userModel = null;
      }
    } catch (e) {
      _error = "Failed to load profile";
    }
  }
  Future<void> loginWithGoogle() async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _authService.googleSignIn();

      if (user != null) {
        await _createOrUpdateUser(user);
      } else {
        _error = "Google sign-in cancelled";
      }
    } catch (e) {
      _error = "Google sign-in failed";
    }

    _setLoading(false);
  }

  Future<void> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
    } catch (_) {
      _error = "Something went wrong";
    }

    _setLoading(false);
  }
  Future<void> register(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        await user.sendEmailVerification();
        await _createOrUpdateUser(user);
      }
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
    } catch (_) {
      _error = "Registration failed";
    }

    _setLoading(false);
  }

  Future<void> _createOrUpdateUser(User user) async {
    final existing = await _firestoreService.getUser(user.uid);

    if (existing == null) {
      final newUser = UserModel(
        name: user.displayName ?? "",
        skills: [],
        experience: "",
        education: "",
        interests: "",
        language: "en",
        isOnboardingCompleted : false, 
      );

      await _firestoreService.saveUser(user.uid, newUser.toMap());
      _userModel = newUser;
    } else {
      _userModel = UserModel.fromMap(existing);
    }

    notifyListeners();
  }
  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (_firebaseUser == null) return;

    await _firestoreService.saveUser(_firebaseUser!.uid, data);
    await _loadUserFromFirestore(_firebaseUser!.uid);

    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await FirebaseAuth.instance.signOut();      
    } catch (e) {
      _error = "Logout failed: ${e.toString()}";
    } finally {
      _setLoading(false);
    }
  }
  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return "User not found";
      case 'wrong-password':
        return "Incorrect password";
      case 'email-already-in-use':
        return "Email already registered";
      case 'weak-password':
        return "Password too weak";
      case 'invalid-email':
        return "Invalid email format";
      default:
        return "Authentication failed";
    }
  }
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
