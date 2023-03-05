import 'package:flutter/material.dart';
import 'package:free_quizme/services/auth_service.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<AuthenticationService>(context);
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              userService.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
