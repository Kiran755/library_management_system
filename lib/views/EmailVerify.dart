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
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              final user = AuthService.firebase().currentUser;
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send Verification Email!"),
          ),
          TextButton(
            onPressed: () {
              AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
