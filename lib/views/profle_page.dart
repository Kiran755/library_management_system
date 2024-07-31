import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 170, 99, 1),
      appBar: AppBar(
        title: const Text("Profle"),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [Text("SapId:"), Text("Name:")],
        ),
      ),
    );
  }
}
