import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/screens/login_screen.dart';
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
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'Selecciona una opción:',
              style: TextStyle(
                fontSize: 18,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final file =
                        await authNotifier.pickImage(ImageSource.gallery);
                    if (file != null) {
                      setState(() => _imageFile = file);
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera,
                          color: accentColor,
                          size: 30,
                        ),
                      ),
                      Text(
                        'Camara',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final file =
                        await AuthNotifier().pickImage(ImageSource.gallery);
                    if (file != null) {
                      setState(() => _imageFile = file);
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.image,
                          color: accentColor,
                          size: 30,
                        ),
                      ),
                      Text(
                        'Galeria',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
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
          // Mostrar SnackBar de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authNotifier.errorMessage!)),
          );
        }
      } else {
        // Éxito
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
