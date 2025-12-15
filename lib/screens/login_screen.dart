import 'package:flutter/material.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:intelliafy_app/widgets/login_header.dart';
import 'package:intelliafy_app/widgets/login_form.dart';
import 'package:intelliafy_app/widgets/login_footer.dart';
import 'package:provider/provider.dart';

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

  final _loginFormKey = GlobalKey<FormState>();

  void _submitFormOnLogin(BuildContext context) async {
    final isValid = _loginFormKey.currentState!.validate();

    if (isValid) {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

      await authNotifier.signIn(
        email: _emailTextController.text,
        password: _passTextController.text,
      );
      if (authNotifier.errorMessage != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(authNotifier.errorMessage!)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.25;

    return Scaffold(
        body: Container(
      color: surfaceColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 80,
            ),
            LoginHeader(
              logoSize: logoSize,
              firstText: 'Hello!',
              secondText: 'Sign In',
            ),
            const SizedBox(
              height: 60,
            ),
            Consumer<AuthNotifier>(
              builder: (context, auth, child) {
                if (auth.isLoading) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoginForm(
                      formKey: _loginFormKey,
                      emailController: _emailTextController,
                      passwordController: _passTextController,
                      passwordFocusNode: _passwordFocusNode,
                      onSubmit: () => _submitFormOnLogin(context),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const LoginFooter(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
