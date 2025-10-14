import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        backgroundColor: const Color.fromARGB(255, 11, 153, 236),
        title: const Text("Login"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                        print("heloo");
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                        print("✅ Logged in: ${userCredential.user?.email}");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found' ) {
                          print(" No user found for that email.");
                        } else if (e.code == 'wrong-password') {
                          print(" Wrong password provided for that user.");
                        } else if( e.code == 'invalid-credential'){
                          print('Invalid credintials(likely captcha)');

                        }
                        else {
                          print("Firebase Auth error: ${e.code}");
                        }
                      } catch (e) {
                        print("Unexpected error: $e");
                      }
                    },

                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ),
                ],
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
