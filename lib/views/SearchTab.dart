import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SingleChildScrollView(
            child: Column(
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
                      "BOOKS ASSIGNED",
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
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(234, 223, 209, 0.6),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: const Color.fromRGBO(158, 90, 100, 1.0),
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: const [
                      BookViewer(
                        value: "assets/Book2.png",
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 5,
                        color: Color.fromRGBO(158, 90, 100, 1.0),
                      ),
                      BookViewer(
                        value: "assets/Books.png",
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
