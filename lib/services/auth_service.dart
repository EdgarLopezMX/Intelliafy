import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Sign In
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      //Authentication Execution
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      //If successful, it returns the User object
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Capture and report Firebase errors
      throw e;
    } catch (e) {
      // 4. Capture other errors
      rethrow;
    }
  }

  // Future<void> signUp()
  // Future<void> signOut()
}
