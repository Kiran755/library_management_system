import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firstapp/views/books_overdue_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class BooksOverdue extends StatefulWidget {
  const BooksOverdue({Key? key}) : super(key: key);

  @override
  State<BooksOverdue> createState() => _BooksOverdueState();
}

class _BooksOverdueState extends State<BooksOverdue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books OverDue"),
        backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(244, 223, 195, 1.0),
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
              List<DataSnapshot> dueBooks = [];
              List<DataSnapshot> childrens =
                  snapshot.child("BooksAssigned").children.toList();
              // var CurrentYear = DateTime.now().year;
              // var CurrentMonth = DateTime.now().month;
              // var CurrentDay = DateTime.now().day;
              for (DataSnapshot element in childrens) {
                var dueDate = element.child("Due Date").value.toString();
                var DueDay = int.parse(dueDate.substring(0, 2));
                var DueMonth = int.parse(dueDate.substring(3, 5));
                var DueYear = int.parse(dueDate.substring(6));
                var date = DateTime(DueYear, DueMonth, DueDay);

                if (DateTime.now().difference(date).inDays > 0) {
                  dueBooks.add(element);
                }
              }
              // childrens.forEach((element) => {
              //   print(element.child());
              // });
              // val++;

              // List<Map<dynamic, dynamic>> childrens =
              //     Map.fromIterable(snapshot.child("BooksAssigned").children);
              // log(childrens["BookURL"]);
              return Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: dueBooks.isEmpty
                              ? null
                              : Text("SAPID : ${snapshot.key}",
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Make text bold
                                    fontSize: 20.0, // Set the font size
                                  )),
                        ),
                      ],
                    ),
                    Column(
                      children: dueBooks.isEmpty
                          ? [const Text("No Books are Overdue!")]
                          : dueBooks
                              .map((Book) => BooksOverdueViewer(
                                  value: Book.child("BookURL").value.toString(),
                                  bookName:
                                      Book.child("BookName").value.toString(),
                                  bookAuthor:
                                      Book.child("BookAuthor").value.toString(),
                                  bookCode:
                                      Book.child("BookCode").value.toString(),
                                  DueDate:
                                      Book.child("Due Date").value.toString(),
                                  IssueDate: Book.child("Issued Date")
                                      .value
                                      .toString()))
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
