import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';


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
              context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: Text('Back to register'),
          ),
        ],
      ),
    );
  }
}
