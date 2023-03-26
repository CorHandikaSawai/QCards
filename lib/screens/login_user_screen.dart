import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:free_quizme/screens/register_user_screen.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({super.key});

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  final emailTxtFormController = TextEditingController();
  final passwordTxtFormController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthenticationService>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'QCard',
                      style: TextStyle(fontSize: 24),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
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
                          obscureText: obscurePassword,
                          controller: passwordTxtFormController,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: obscurePassword
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
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
                                      if (authService.error.isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(authService.error),
                                          ),
                                        );
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
                        SizedBox(
                          height: 50,
                        ),
                        SocialLoginButton(
                          buttonType: SocialLoginButtonType.google,
                          onPressed: () async {
                            if (defaultTargetPlatform ==
                                TargetPlatform.android) {
                              await authService.signInWithGoogle();
                            } else if (defaultTargetPlatform ==
                                TargetPlatform.iOS) {
                              // TODO: Implement login for IOS
                            } else if (kIsWeb) {
                              print('object');
                              await authService.signInWithGoogleWeb();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
