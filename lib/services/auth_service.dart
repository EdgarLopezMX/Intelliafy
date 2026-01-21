import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //---SignUp---
  Future<User?> signIn(String email, String password) async {
    final creds = await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    return creds.user;
  }

  //---Register---
  Future<User?> signUp({
    required String fullName,
    required String email,
    required String password,
    required File imageFile,
  }) async {
    //Create user
    final creds = await _auth.createUserWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
    final User user = creds.user!;

    //Upload Image
    final ref = _storage.ref().child('userImages').child('${user.uid}.jpg');
    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    //---Save in firestore---
    await _firestore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'name': fullName,
      'email': email,
      'userImage': imageUrl,
      'createdAt': Timestamp.now(),
    });

    return user;
  }

  //---Image---
  Future<File?> pickAndCropImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return null;

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    return croppedImage != null ? File(croppedImage.path) : null;
  }
}
