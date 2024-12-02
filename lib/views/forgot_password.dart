import 'package:firebase_auth/firebase_auth.dart';
import '../utilities/ErrorDialog.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email_controller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("FORGOT PASSWORD"),
          backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
        ),
        backgroundColor: bgColour,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  enableSuggestions: false,
                  cursorHeight: 16,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24)),
                    contentPadding: const EdgeInsets.all(14),
                    isDense: true,
                  ),
                  controller: email_controller,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () async {
                  try {
                    await auth.sendPasswordResetEmail(
                        email: email_controller.text.toString());
                    showError(
                        context,
                        "We have sent the email to reset your password. Please check the inbox or spam folder of your email",
                        false);
                  } on FirebaseAuthException {
                    showError(
                        context,
                        "Error Occured Please Try again after some time!",
                        false);
// show the snackbar here
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Forgot Password")),
          ],
        ));
  }
}
