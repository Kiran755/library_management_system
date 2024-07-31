import 'package:flutter/material.dart';
import 'package:firstapp/constants/colors.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: const SingleChildScrollView(
          child: Column(
        children: [Text("Give feedback to admin : ")],
      )),
    );
  }
}
