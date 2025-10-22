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
      appBar: AppBar(title:const Text('Verify email',style: TextStyle(color: Colors.black),),backgroundColor: const Color.fromARGB(67, 4, 137, 174),),
      body: Column(
        children: [
          const Text(
            "Verification email sent, check email to verify",
            style: TextStyle(color: Color.fromARGB(255, 135, 9, 0), fontSize: 25),
          ),
          const Text(
            "Press the button below to resend verification",
            style: TextStyle(color: Color.fromARGB(255, 135, 9, 0), fontSize: 25),
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
          TextButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/register', (route)=>false);
          }, child: Text('Back to register'))
        ],
      ),
    );
  }
}
