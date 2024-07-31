import 'package:firstapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 223, 195, 1.0),
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  final user = AuthService.firebase().currentUser;
                  AuthService.firebase().sendEmailVerification();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Send Verification Email!"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Restart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
