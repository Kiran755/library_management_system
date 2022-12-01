import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
                child: Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
              color: Color.fromARGB(150, 12, 11, 11),
            )),
            Text(
              "HISTORY",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Expanded(
                child: Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
              color: Color.fromARGB(150, 12, 11, 11),
            )),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  BookViewer(
                    value: "assets/Book2.png",
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  BookViewer(value: "assets/Book2.png", color: Colors.white),
                  SizedBox(height: 20),
                  BookViewer(value: "assets/Book2.png", color: Colors.white),
                  SizedBox(height: 20),
                  BookViewer(value: "assets/Book2.png", color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
