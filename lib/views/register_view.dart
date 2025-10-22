import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_snackbar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(67, 4, 137, 174),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,

            enableSuggestions: false,
            autocorrect: false,

            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email",
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,

            decoration: const InputDecoration(
              hintText: "Enter your password",
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showErrorSnackBar(context, 'Weak password');
                } else if (e.code == 'email-already-in-use') {
                  showErrorSnackBar(context, 'Email is already in use');
                } else if (e.code == 'invalid-email') {
                  showErrorSnackBar(context, 'Invalid email entered');
                } else {
                  showErrorSnackBar(context, "Error: ${e.code}");
                }
              } catch (e) {
                showErrorSnackBar(context, e.toString());
              }
            },

            child: const Text(
              "Register",
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(Loginroute, (route) => false);
            },
            child: const Text('Already have an account? Login here'),
          ),
        ],
      ),
    );
  }
}
