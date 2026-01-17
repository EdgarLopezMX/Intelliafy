import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  //---Login---
  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      _user = await _authService.signIn(email, password);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  //---SignUp---
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required File? imageFile,
  }) async {
    if (imageFile == null) {
      _errorMessage = "Por favor selecciona una imagen";
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      _user = await _authService.signUp(
        fullName: fullName,
        email: email,
        password: password,
        imageFile: imageFile,
      );
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  //---Imagen Selector---
  Future<File?> pickImage(ImageSource source) async {
    return await _authService.pickAndCropImage(source);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para cargar datos de Firestore
  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void signOut() {}
}
