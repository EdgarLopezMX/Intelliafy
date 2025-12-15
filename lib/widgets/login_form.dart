import 'package:flutter/material.dart';
import 'package:intelliafy_app/screens/forget_password_screen.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onSubmit,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
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
                        decoration: const InputDecoration(hintText: "Email"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        focusNode: widget.passwordFocusNode,
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
                                  : Icons.visibility_off,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 280,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgetPassword()));
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: widget.onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: surfaceColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: surfaceColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: 'Inter',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
