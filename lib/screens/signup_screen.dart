import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/screens/login_screen.dart';
import 'package:intelliafy_app/widgets/imagePicker_dialog.dart';
import 'package:intelliafy_app/widgets/signUp/signup_footer.dart';
import 'package:intelliafy_app/widgets/signUp/signup_form.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController =
      TextEditingController(text: '');
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');

  final _signUpFormKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  File? _imageFile;

  bool isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    Size size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.20;

    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        return Scaffold(
          body: Container(
            color: surfaceColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    SignupForm(
                      formKey: _signUpFormKey,
                      fullNameController: _fullNameController,
                      emailController: _emailTextController,
                      passwordController: _passTextController,
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passFocusNode,
                      onSubmit: () => _submitFormOnSignup(authNotifier),
                      onSelectImage: () => _showImageDialog(authNotifier),
                      imageFile: _imageFile,
                      isLoading: authNotifier.isLoading,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const SignupFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageDialog(AuthNotifier authNotifier) {
    showDialog(
      context: context,
      builder: (context) => ImagePickerDialog(
        onImageSelected: (File file) {
          setState(() => _imageFile = file);
        },
      ),
    );
  }

  void _submitFormOnSignup(AuthNotifier authNotifier) async {
    final isValid = _signUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      await authNotifier.signUp(
        fullName: _fullNameController.text,
        email: _emailTextController.text,
        password: _passTextController.text,
        imageFile: _imageFile,
      );

      if (authNotifier.errorMessage != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authNotifier.errorMessage!)),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      }
    }
  }
}
