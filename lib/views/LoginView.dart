import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/constants/routes.dart';
import 'package:firstapp/services/auth/auth_exceptions.dart';
import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/utilities/ErrorDialog.dart';
import 'package:firstapp/views/NotesView.dart';
import 'package:firstapp/views/SearchTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

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
      backgroundColor: const Color.fromRGBO(244, 223, 195, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: FutureBuilder(
            future: AuthService.firebase().initialze(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Padding(
                    padding: const EdgeInsets.only(top: 0.01),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SvgPicture.asset('assets/RegisterView.svg'),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                ),
                                controller: _email,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                ),
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: _password,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;

                                try {
                                  await AuthService.firebase()
                                      .logIn(email: email, password: password);
                                  final user =
                                      AuthService.firebase().currentUser;
                                  // final userUid = user?.uid;
                                  // DatabaseReference db_ref = FirebaseDatabase
                                  //     .instance
                                  //     .ref("Database/Names");
                                  // final snapShot =
                                  //     await db_ref.child("$userUid").get();
                                  // if (!snapShot.exists) {
                                  //   db_ref.set({userUid: sapID});
                                  // }
                                  if (email ==
                                          "chetan159devadiga159@gmail.com" &&
                                      password == "123456789") {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            adminPage, (route) => false);
                                  } else if (user?.isEmailVerified ?? false) {
                                    final userUid = user?.uid;
                                    DatabaseReference db_ref = FirebaseDatabase
                                        .instance
                                        .ref("Database/Names");
                                    final snapShot =
                                        await db_ref.child("$userUid").get();
                                    if (snapShot.exists) {
                                      final sapID = snapShot
                                          .child("SapId")
                                          .value
                                          .toString();
                                      final Name = snapShot
                                          .child("Name")
                                          .value
                                          .toString();
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => NotesView(
                                                    Name: Name,
                                                    SapID: sapID,
                                                  )));
                                    }
                                    // Navigator.of(context)
                                    //     .pushNamedAndRemoveUntil(
                                    //   notesRoute,
                                    //   (route) => false,
                                    // );
                                  } else {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      loginRoute,
                                      (route) => false,
                                    );
                                  }
                                } on UserNotFoundException {
                                  await showError(context, "User Not Found!");
                                } on WrongPasswordAuthExcpetion {
                                  await showError(context, "Wrong Credentials");
                                } on GenericAuthException {
                                  await showError(
                                      context, "Authentication Error");
                                } catch (e) {
                                  await showError(context, e.toString());
                                }
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor:
                                    const Color.fromRGBO(158, 90, 100, 1.0),
                                minimumSize: const Size(250, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text("Login"),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      registerRoute, (route) => false);
                                },
                                child: const Text(
                                  "Not registered yet? Click here!",
                                  style: TextStyle(
                                    color: Color.fromRGBO(158, 90, 100, 1.0),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
