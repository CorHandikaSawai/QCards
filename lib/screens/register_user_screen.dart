import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:free_quizme/screens/login_user_screen.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final firstNameTxtFormController = TextEditingController();
  final lastNameTxtFormController = TextEditingController();
  final emailTxtFormController = TextEditingController();
  final passwordTxtFormController = TextEditingController();
  final confirmPasswordTxtFormController = TextEditingController();
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
                        controller: firstNameTxtFormController,
                        decoration: const InputDecoration(
                          label: Text('First Name'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Cannot Be Empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: lastNameTxtFormController,
                        decoration: const InputDecoration(
                          label: Text('Last Name'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Cannot Be Empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailTxtFormController,
                        decoration: const InputDecoration(
                          label: Text('Email'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
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
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Cannot Be Empty';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: confirmPasswordTxtFormController,
                        decoration: const InputDecoration(
                          label: Text('Confirm Password'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty ||
                              value == null ||
                              value != passwordTxtFormController.text) {
                            return 'Must Match Password';
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
                                    await authService.createUser(
                                        firstName:
                                            firstNameTxtFormController.text,
                                        lastName:
                                            lastNameTxtFormController.text,
                                        email: emailTxtFormController.text,
                                        password:
                                            passwordTxtFormController.text);
                                    if (mounted) {
                                      if (authService.response
                                          .contains('Success')) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.blue,
                                            content: Text(authService.response),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(authService.response),
                                          ),
                                        );
                                      }
                                      firstNameTxtFormController.clear();
                                      firstNameTxtFormController.clear();
                                      lastNameTxtFormController.clear();
                                      emailTxtFormController.clear();
                                      passwordTxtFormController.clear();
                                      confirmPasswordTxtFormController.clear();
                                    }
                                  }
                                },
                                child: const Text('Register'),
                              ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Login'),
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
