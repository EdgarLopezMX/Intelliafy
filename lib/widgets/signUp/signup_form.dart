import 'dart:io';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;
  final VoidCallback onSelectImage;
  final File? imageFile;
  final bool isLoading;

  const SignupForm(
      {super.key,
      required this.formKey,
      required this.fullNameController,
      required this.emailController,
      required this.passwordController,
      required this.emailFocusNode,
      required this.passwordFocusNode,
      required this.onSubmit,
      required this.onSelectImage,
      this.imageFile,
      required this.isLoading});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    Size size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageBoxSize = screenWidth * 0.32;
    final logoSize = screenWidth * 0.20;
    const double horizontalPadding = 48.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 75),
                        child: GestureDetector(
                          onTap: () {
                            widget.onSelectImage();
                          },
                          child: Container(
                            width: size.width * 0.32,
                            height: size.width * 0.32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: accentColor,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: widget.imageFile == null
                                  ? Icon(
                                      Icons.camera_enhance_sharp,
                                      color: accentColor,
                                      size: 30,
                                    )
                                  : Image.file(
                                      widget.imageFile!,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(widget.emailFocusNode),
                        keyboardType: TextInputType.name,
                        controller: widget.fullNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a valid name';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(widget.passwordFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: widget.emailController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        controller: widget.passwordController,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Enter a valid password';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  // ignore: dead_code
                                  : Icons.visibility_off,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: SizedBox(
                          width: 250,
                          child: widget.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    widget.onSubmit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accentColor,
                                    foregroundColor: surfaceColor,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsGeometry.symmetric(
                                        vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: surfaceColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
