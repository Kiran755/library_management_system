import 'package:firebase_database/firebase_database.dart';
import '../constants/routes.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utilities/ErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _sapID;
  late final TextEditingController _Name;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _sapID = TextEditingController();
    _Name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _sapID.dispose();
    _Name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                            const SizedBox(height: 20),
                            const Text(
                              "WELCOME!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                enableSuggestions: false,
                                cursorHeight: 16,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: "Enter your Full Name",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                ),
                                controller: _Name,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                enableSuggestions: false,
                                cursorHeight: 16,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: "Enter your SAP ID",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  contentPadding: const EdgeInsets.all(14),
                                  isDense: true,
                                ),
                                controller: _sapID,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                enableSuggestions: false,
                                cursorHeight: 16,
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
                                style: const TextStyle(fontSize: 14),
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
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: () async {
                                  final email = _email.text;
                                  final password = _password.text;
                                  final sapid = _sapID.text;
                                  final Name = _Name.text;
                                  try {
                                    final userCredentials =
                                        await AuthService.firebase().createUser(
                                            email: email, password: password);
                                    final uid = userCredentials.uid;
                                    DatabaseReference dbRef = FirebaseDatabase
                                        .instance
                                        .ref("Database/Names");
                                    final snapShot =
                                        await dbRef.child(uid).get();
                                    if (!snapShot.exists) {
                                      dbRef
                                          .child(uid)
                                          .set({"Name": Name, "SapId": sapid});
                                    }
                                    Navigator.of(context)
                                        .pushNamed(emailVerify);
                                  } on InvalidEmailException {
                                    await showError(
                                        context, "invalid Email", false);
                                  } on WeakPasswordAuthException {
                                    await showError(
                                        context, "Weak Password", false);
                                  } catch (e) {
                                    await showError(
                                        context, e.toString(), false);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(158, 90, 100, 1.0),
                                  minimumSize: const Size(250, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text("Register")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      loginRoute, (route) => false);
                                },
                                child: const Text(
                                    "Have an account? Click here to Login!",
                                    style: TextStyle(
                                      color: Color.fromRGBO(158, 90, 100, 1.0),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  );
                default:
                  return const Text("Loading...");
              }
            }),
      ),
    );
  }
}
