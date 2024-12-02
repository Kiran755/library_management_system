import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../views/books_overdue_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../constants/colors.dart';

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
        title: const Text(
          "Books Overdue",
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
            if (snapshot.hasChild("BooksAssigned")) {
              List<DataSnapshot> dueBooks = [];
              List<DataSnapshot> childrens =
                  snapshot.child("BooksAssigned").children.toList();

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

              String sapid = snapshot.key.toString();
              String studentName =
                  snapshot.child("Name").value?.toString() ?? '-';
              String studentEmail =
                  snapshot.child("Email").value?.toString() ?? '-';

              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dueBooks.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "SAPID : $sapid",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (dueBooks.isNotEmpty)
                      Text(
                        "Name: $studentName",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    if (dueBooks.isNotEmpty)
                      Text(
                        "Email: $studentEmail",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    const SizedBox(height: 10),
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
                    ),
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
