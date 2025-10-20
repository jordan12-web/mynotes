import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
class verifyEmailView extends StatefulWidget {
  const verifyEmailView({super.key});

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  bool _emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Verify eamil',style: TextStyle(color: Colors.black),),backgroundColor: const Color.fromARGB(67, 4, 137, 174),),
      body: Column(
        children: [
          const Text(
            "Please verify your email address",
            style: TextStyle(color: Color.fromARGB(255, 135, 9, 0), fontSize: 30),
          ),
          TextButton(
            onPressed: _emailSent
                ? null
                : () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null && !user.emailVerified) {
                      await user.sendEmailVerification();
                      devtools.log("📬 Verification email sent to ${user.email}");
                      setState(() {
                        _emailSent = true;
                      });
      
                      // Optional: You could show a snackbar or dialog here
                      // to inform the user visually, if needed.
                    }
                  },
            child: const Text('Send email verification'),
          ),
        ],
      ),
    );
  }
}
