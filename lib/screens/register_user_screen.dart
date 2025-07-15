import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qcards/services/auth_service.dart';

/// A registration screen where new users can sign up with their first name,
/// last name, email, and password.
class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  // Form input controllers
  final firstNameTxtFormController = TextEditingController();
  final lastNameTxtFormController = TextEditingController();
  final emailTxtFormController = TextEditingController();
  final passwordTxtFormController = TextEditingController();
  final confirmPasswordTxtFormController = TextEditingController();

  // Key to validate form input
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Access the AuthenticationService using Provider
    final authService = Provider.of<AuthenticationService>(context);

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width * 0.8, // Make form responsive to screen width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo displayed above form fields
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: const CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage('assets/images/QCard_logo.png'),
                      ),
                    ),

                    // Form fields
                    Column(
                      children: [
                        TextFormField(
                          controller: firstNameTxtFormController,
                          decoration: const InputDecoration(
                            label: Text('First Name'),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Cannot Be Empty' : null,
                        ),
                        TextFormField(
                          controller: lastNameTxtFormController,
                          decoration: const InputDecoration(
                            label: Text('Last Name'),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Cannot Be Empty' : null,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTxtFormController,
                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Cannot Be Empty' : null,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passwordTxtFormController,
                          decoration: const InputDecoration(
                            label: Text('Password'),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Cannot Be Empty' : null,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: confirmPasswordTxtFormController,
                          decoration: const InputDecoration(
                            label: Text('Confirm Password'),
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                value != passwordTxtFormController.text) {
                              return 'Must Match Password';
                            }
                            return null;
                          },
                        ),

                        // Register button or loading spinner
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: authService.isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Validate form before sending data
                                      if (formKey.currentState!.validate()) {
                                        await authService.createUser(
                                          firstName:
                                              firstNameTxtFormController.text,
                                          lastName:
                                              lastNameTxtFormController.text,
                                          email: emailTxtFormController.text,
                                          password:
                                              passwordTxtFormController.text,
                                        );

                                        if (mounted) {
                                          // Show error if user creation fails
                                          if (authService.error.isNotEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content:
                                                    Text(authService.error),
                                              ),
                                            );
                                          }

                                          // Clear the fields
                                          firstNameTxtFormController.clear();
                                          lastNameTxtFormController.clear();
                                          emailTxtFormController.clear();
                                          passwordTxtFormController.clear();
                                          confirmPasswordTxtFormController
                                              .clear();
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                        ),

                        // Login button (navigates back to login screen)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),
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
