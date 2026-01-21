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

  List<String> _courseNames = [];
  List<String> get courseNames => _courseNames;

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

  Future<void> fetchCourses() async {
    _setLoading(true);
    try {
      // Accedemos a la colección 'course'
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('course').get();

      // Mapeamos los documentos para extraer solo el campo 'name'
      _courseNames =
          querySnapshot.docs.map((doc) => doc.get('name') as String).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al cargar cursos: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> uploadTest({
    required String title,
    required String course,
    required Timestamp? deadline,
  }) async {
    if (deadline == null) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('tests').add({
        'testTitle': title,
        'courseName': course,
        'deadline': deadline,
        'createdAt': Timestamp.now(),
        'authorId': user.uid,
      });

      _isLoading = false;
      notifyListeners();
      return docRef.id;
    } catch (e) {
      print("Error en uploadTest: $e");
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
