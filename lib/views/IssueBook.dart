import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/utilities/ErrorDialog.dart';
import 'package:firstapp/views/BookIssueView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firstapp/constants/colors.dart';

import '../utilities/showMessage.dart';

class IssueBook extends StatefulWidget {
  final String colName, docName;
  const IssueBook({Key? key, required this.colName, required this.docName})
      : super(key: key);

  @override
  State<IssueBook> createState() => _IssueBookState();
}

class _IssueBookState extends State<IssueBook> {
  late final TextEditingController _sapid;
  String result = "";
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

  // void getSap() async {
  //   try {
  //     final qrCode = await FlutterBarcodeScanner.scanBarcode(
  //         "#fff666", "Cancel", true, ScanMode.BARCODE);
  //     if (!mounted) return;
  //     setState(() {
  //       result = qrCode;
  //     });
  //   } catch (e) {
  //     result = "Failed to Scan QR CODE";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColour,
        appBar: AppBar(
          title: const Text("Issue Book"),
          backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              var bookURL = (snapshot.data as DocumentSnapshot)['BookURL'];
              var Availability =
                  (snapshot.data as DocumentSnapshot)['Availability'];
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
                  // ElevatedButton(
                  //     onPressed: () {
                  //       getSap();
                  //     },
                  //     style: TextButton.styleFrom(
                  //       primary: Colors.white,
                  //       backgroundColor:
                  //           const Color.fromRGBO(158, 90, 100, 1.0),
                  //       minimumSize: const Size(250, 40),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //     ),
                  //     child: const Text("SCAN")),
                  // Text(result),
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
                        String formattedDate =
                            DateFormat("dd/MM/yyyy").format(date);
                        String formattedDueDate =
                            DateFormat("dd/MM/yyyy").format(dueDate);
                        // print(formattedDate);
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Database/SAPID/$sapid");
                        final Listsnapshot =
                            await ref.child('BooksAssigned').get();
                        if (Availability == "Not Available") {
                          print(
                              "Book is requested by someone else. Please wait for your turn");
                          showError(context,
                              "Book is requested by someone else. Please wait for your turn");
                          return;
                        }
                        if (Listsnapshot.exists) {
                          if (Listsnapshot.children.length == 3) {
                            print("Maximum Book Issuing limit reached!");
                            showError(
                                context, "Maximum Book Issuing limit reached!");
                            return;
                          }
                        }
                        final snapshot =
                            await ref.child('BooksAssigned/$bookCode').get();
                        if (snapshot.exists) {
                          print("Book Already Exits!");
                          showError(context, "Book Already Exists");
                        } else {
                          await ref.update({
                            "BooksAssigned/$bookCode": {
                              "BookCode": bookCode,
                              "BookName": bookName,
                              "BookAuthor": bookAuthor,
                              "Issued Date": formattedDate,
                              "Due Date": formattedDueDate,
                              "BookURL": bookURL
                            },
                          });
                          // if (data.exists && data.value == 1) {
                          //   final query = await ReqRef.child("TimeStamp").get();
                          //   final TimeStamp = int.parse(query.value.toString());
                          //   print("Time Stamep : $TimeStamp");
                          //   await ReqRef.remove();
                          //   final docRef = await FirebaseFirestore.instance
                          //       .collection(widget.colName)
                          //       .doc(widget.docName)
                          //       .update(
                          //           {"Requested": FieldValue.increment(-1)});

                          //   await ref
                          //       .child("BooksRequested/$bookCode")
                          //       .remove();
                          //   final dataRef = FirebaseDatabase.instance
                          //       .ref("Database/Requests/${bookCode}");
                          //   final temp = await dataRef.child("requested").get();
                          //   final ReqVal = double.parse(temp.value.toString());
                          //   await dataRef
                          //       .child("requested")
                          //       .update({"requested": ReqVal - 1});
                          //   await dataRef
                          //       .child("SapId")
                          //       .orderByChild("TimeStamp")
                          //       .get()
                          //       .then((snapshot) {
                          //     final data = Map<String, dynamic>.from(
                          //         snapshot.value as dynamic);
                          //     data.forEach((key, value) {
                          //       print(
                          //           "This the timestamp : ${value["TimeStamp"]} and this the key : $key");
                          //       print(
                          //           "type of TimeSTamp : ${TimeStamp.runtimeType}");
                          //       print(
                          //           "Type of timeStamp frm the var: ${value["TimeStamp"].runtimeType}");
                          //       int DBTimeStamp = value["TimeStamp"];
                          //       if (DBTimeStamp > TimeStamp) {
                          //         print("hey I am working");
                          //         dataRef.child("SapId/$key").update(
                          //             {"position": value['position'] - 1});
                          //       }
                          //     });
                          //   });
                          // }
                          FirebaseFirestore.instance
                              .collection(widget.colName)
                              .doc(widget.docName)
                              .update({"Availability": "Not Available"});
                          showError(context, "Book Assigned Successfully");
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
                      child: const Text("Click To Assign"))
                ],
              );
            },
          ),
        ));
  }
}
