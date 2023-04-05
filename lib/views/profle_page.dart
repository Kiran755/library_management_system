import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [const Text("SapId:"), const Text("Name:")],
        ),
      ),
    );
  }
}
