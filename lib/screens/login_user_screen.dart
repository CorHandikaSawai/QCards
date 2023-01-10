import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_quizme/screens/homepage_screen.dart';
import 'package:free_quizme/screens/register_user_screen.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({super.key});

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  final emailTxtFormController = TextEditingController();
  final passwordTxtFormController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      body: Form(
        key: formKey,
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: size.width * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'QCard',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTxtFormController,
                        decoration: const InputDecoration(
                          label: Text('Email'),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Cannot Be Empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordTxtFormController,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Cannot Be Empty';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: authService.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await authService.login(
                                        email: emailTxtFormController.text,
                                        password:
                                            passwordTxtFormController.text);
                                  }
                                  if (mounted) {
                                    if (authService.response
                                        .contains('Failed')) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(authService.response),
                                        ),
                                      );
                                    } else if (authService.response
                                        .contains('Success')) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePageScreen(),
                                          ),
                                          (route) => false);
                                    }
                                  }
                                },
                                child: const Text('Login'),
                              ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterUserScreen(),
                              ),
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
