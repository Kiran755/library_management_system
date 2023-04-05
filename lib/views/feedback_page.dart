import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 170, 99, 1),
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [const Text("Give feedback to admin : ")],
      )),
    );
  }
}
