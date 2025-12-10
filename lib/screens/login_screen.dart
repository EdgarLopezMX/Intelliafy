import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/config/app_theme.dart';
import 'package:intelliafy_app/screens/profile_screen.dart';
import 'package:intelliafy_app/services/auth_service.dart';
import 'package:intelliafy_app/widgets/login_header.dart';
import 'package:intelliafy_app/widgets/login_form.dart';
import 'package:intelliafy_app/widgets/signup_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  final FocusNode _passwordFocusNode = FocusNode();

  final AuthService _authService = AuthService();
  final _loginFormKey = GlobalKey<FormState>();

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();

    if (isValid) {
      setState(() {});
      try {
        final User? user = await _authService.signIn(
          email: _emailTextController.text,
          password: _passTextController.text,
        );
        if (user != null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          }
        }
      } on FirebaseAuthException {
        setState(() {});
      } catch (error) {
        setState(() {});
        if (kDebugMode) {
          print('error occurred $error');
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.25;

    return Scaffold(
        body: Container(
      color: kBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListView(
          children: [
            LoginHeader(logoSize: logoSize),
            const SizedBox(
              height: 60,
            ),
            LoginForm(
              formKey: _loginFormKey,
              emailController: _emailTextController,
              passwordController: _passTextController,
              passwordFocusNode: _passwordFocusNode,
              onSubmit: () => _submitFormOnLogin(),
            ),
            const SizedBox(
              height: 8,
            ),
            const SignUpFooter(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ));
  }
}
