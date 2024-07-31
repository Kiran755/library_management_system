import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firstapp/constants/colors.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class BooksInCirculation extends StatefulWidget {
  const BooksInCirculation({Key? key}) : super(key: key);

  @override
  State<BooksInCirculation> createState() => _BooksInCirculationState();
}

class _BooksInCirculationState extends State<BooksInCirculation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Books In Circulation",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: bgColour,
      ),
      backgroundColor: bgColour,
      body: Container(
        child: FirebaseAnimatedList(
          defaultChild: const Center(
            child: CircularProgressIndicator(),
          ),
          query: FirebaseDatabase.instance.ref("Database/SAPID"),
          itemBuilder: ((context, snapshot, animation, index) {
            // log(snapshot.child("BooksAssigned").toString());
            // var val = 1;
            if (snapshot.hasChild("BooksAssigned")) {
              log(snapshot.key.toString());
              // Map<dynamic,dynamic> books;
              List<DataSnapshot> childrens =
                  snapshot.child("BooksAssigned").children.toList();
              // childrens.forEach((element) => {
              //   print(element.child());
              // });
              // val++;

              // List<Map<dynamic, dynamic>> childrens =
              //     Map.fromIterable(snapshot.child("BooksAssigned").children);
              // log(childrens["BookURL"]);
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("SAPID : ${snapshot.key}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, // Make text bold
                              fontSize: 20.0, // Set the font size
                            )),
                      ],
                    ),
                    Column(
                      children: childrens
                          .map((Book) => BookViewer(
                              value: Book.child("BookURL").value.toString(),
                              bookName: Book.child("BookName").value.toString(),
                              bookAuthor:
                                  Book.child("BookAuthor").value.toString(),
                              bookCode: Book.child("BookCode").value.toString(),
                              DueDate: Book.child("Due Date").value.toString(),
                              IssueDate:
                                  Book.child("Issued Date").value.toString()))
                          .toList(),
                    )
                  ],
                ),
              );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
