import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            decoration: InputDecoration(
              hintText: "G.V KumBhojkar",
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("14 Searches"),
              Expanded(child: SizedBox()),
              const Text("Filters:Some Filter"),
            ],
          ),
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
