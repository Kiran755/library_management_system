import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/constants/routes.dart';
import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/views/EmailVerify.dart';
import 'package:firstapp/views/FirstScreen.dart';
import 'package:firstapp/views/IssueBook.dart';
import 'package:firstapp/views/LoginView.dart';
import 'package:firstapp/views/NotesView.dart';
import 'package:firstapp/views/RegisterView.dart';
import 'package:firstapp/views/admin_page.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme:
        ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat-Black'),
    home: const FirstScreen(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => NotesView(
            Name: "",
            SapID: "",
          ),
      emailVerify: (context) => const EmailVerify(),
      adminPage: (context) => const AdminPage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialze(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              print(user);
              if (user != null) {
                if (user.isEmailVerified) {
                  return NotesView(Name: "", SapID: "");
                } else {
                  return const EmailVerify();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

Future<bool> ShowPopUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Logout"))
        ],
      );
    },
  ).then((value) => value ?? false);
}
// This widget is the root of your application

