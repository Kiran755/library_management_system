import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utilities/ErrorDialog.dart';
import '../utilities/showMessage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';

import 'BookIssueView.dart';

class ReturnBook extends StatefulWidget {
  final String docName, colName;
  const ReturnBook({Key? key, required this.docName, required this.colName})
      : super(key: key);

  @override
  State<ReturnBook> createState() => _ReturnBookState();
}

class _ReturnBookState extends State<ReturnBook> {
  late final TextEditingController _sapid;
  @override
  void initState() {
    _sapid = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _sapid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColour,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
          title: const Text("Return Book"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(widget.colName)
                .doc(widget.docName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading");
              }
              var bookName = (snapshot.data as DocumentSnapshot)['BookName'];
              var bookAuthor =
                  (snapshot.data as DocumentSnapshot)['AuthorName'];
              var bookCode = (snapshot.data as DocumentSnapshot)['BookCode'];
              var bookURL = (snapshot.data as DocumentSnapshot)["BookURL"];
              return Column(
                children: [
                  BookIssueView(
                      value: bookURL,
                      bookName: bookName,
                      bookAuthor: bookAuthor,
                      bookCode: bookCode),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Enter SapId",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24)),
                          contentPadding: const EdgeInsets.all(14),
                          isDense: true,
                        ),
                        controller: _sapid,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final result = await ShowMessage(context);
                        if (result == false) {
                          return;
                        }
                        final String sapid = _sapid.text;
                        DateTime date = DateTime.now();
                        DateTime dueDate =
                            DateTime(date.year, date.month, date.day + 7);
                        String formattedDate = DateFormat("yMd").format(date);
                        String formattedDueDate =
                            DateFormat("yMd").format(dueDate);
                        // print(formattedDate);
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Database/SAPID/$sapid");
                        final Listsnapshot =
                            await ref.child('BooksAssigned').get();
                        if (Listsnapshot.exists) {
                          if (Listsnapshot.children.isEmpty) {
                            print("No Books to return!");
                            showError(
                                context, "There are no assigned books!", true);
                            return;
                          }
                        }
                        final snapshot =
                            await ref.child('BooksAssigned/$bookCode').get();
                        if (!snapshot.exists) {
                          print("Book Not found!");
                          showError(
                              context, "Book Not assigned to the user", true);
                        } else {
                          DatabaseReference localref = FirebaseDatabase.instance
                              .ref(
                                  "Database/SAPID/$sapid/BooksAssigned/$bookCode");

                          final temp =
                              await localref.child("Issued Date").get();
                          final String issueDate = temp.value.toString();
                          await localref.remove();
                          await ref.update({
                            "BooksHistory/$bookCode": {
                              "BookCode": bookCode,
                              "BookName": bookName,
                              "BookAuthor": bookAuthor,
                              "Issued Date": issueDate,
                              "Returned Date": formattedDate,
                              "BookURL": bookURL
                            },
                          });
                          FirebaseFirestore.instance
                              .collection(widget.colName)
                              .doc(widget.docName)
                              .update({"Availability": "Avaiable"});
                          showError(
                              context, "Book Returned Successfully", true);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromRGBO(158, 90, 100, 1.0),
                        minimumSize: const Size(250, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text("Return Book")),
                ],
              );
            },
          ),
        ));
  }
}
