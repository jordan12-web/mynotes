import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_snackbar.dart';

class verifyEmailView extends StatefulWidget {
  const verifyEmailView({super.key});

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify email',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(67, 4, 137, 174),
      ),
      body: Column(
        children: [
          Center(
            child: const Text(
              "Press the button below to resend verification",
              style: TextStyle(
                color: Color.fromARGB(255, 135, 9, 0),
                fontSize: 25,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
              showErrorSnackBar(context, 'Verification email sent');
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/register', (route) => false);
            },
            child: Text('Back to register'),
          ),
        ],
      ),
    );
  }
}
