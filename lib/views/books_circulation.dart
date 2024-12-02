import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../constants/colors.dart';
import '../views/book_viewer.dart';
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
          query: FirebaseDatabase.instance
              .ref("Database/SAPID"), // Reference to SAPID in the database
          itemBuilder: ((context, snapshot, animation, index) {
            log('Snapshot data: ${snapshot.value.toString()}'); // Debugging snapshot data

            if (snapshot.hasChild("BooksAssigned")) {
              // Ensure that the student has assigned books
              String sapid = snapshot.key.toString();
              String studentName = snapshot.child("Name").value?.toString() ??
                  '-'; // Get the student's name
              String studentEmail = snapshot.child("Email").value?.toString() ??
                  '-'; // Get the student's email
              List<DataSnapshot> booksAssigned = snapshot
                  .child("BooksAssigned")
                  .children
                  .toList(); // List of books assigned

              log('SAPID: $sapid');
              log('Name: $studentName');
              log('Email: $studentEmail');

              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    SizedBox(height: 8), // Spacing between elements
                    Text(
                      "Name: $studentName",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Email: $studentEmail",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 10), // Spacing for book list
                    Column(
                      children: booksAssigned
                          .map((book) => BookViewer(
                              value: book.child("BookURL").value.toString(),
                              bookName: book.child("BookName").value.toString(),
                              bookAuthor:
                                  book.child("BookAuthor").value.toString(),
                              bookCode: book.child("BookCode").value.toString(),
                              DueDate: book.child("Due Date").value.toString(),
                              IssueDate:
                                  book.child("Issued Date").value.toString()))
                          .toList(),
                    ),
                  ],
                ),
              );
            }
            return Container(); // Return empty container if no BooksAssigned
          }),
        ),
      ),
    );
  }
}
