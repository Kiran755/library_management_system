import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utilities/showMessage.dart';

class RequestBookViewer extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName, bookAuthor, bookCode, requestedBy, issuedDate, sapId;
  const RequestBookViewer(
      {Key? key,
      required this.bookAuthor,
      required this.bookCode,
      required this.bookName,
      required this.color,
      required this.issuedDate,
      required this.requestedBy,
      required this.value,
      required this.sapId})
      : super(key: key);

  @override
  State<RequestBookViewer> createState() => _RequestBookViewerState();
}

class _RequestBookViewerState extends State<RequestBookViewer> {
  @override
  Widget build(BuildContext context) {
    final dbref = FirebaseDatabase.instance.ref(
        "Database/Requests/${widget.bookCode}/SapId/${widget.sapId}/position");
    return FutureBuilder<DataSnapshot>(
        future: dbref.get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          return (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: widget.color,
            ),
            child: Row(
              children: [
                Image.asset(widget.value),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: widget.color,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          widget.bookAuthor,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Issued Date: ${widget.issuedDate}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Your Position : ${snapshot.data?.value.toString()}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                        TextButton(
                            onPressed: () async {
                              final result = await ShowMessage(context);
                              if (result == false) {
                                return;
                              }
                              DatabaseReference ref = FirebaseDatabase.instance
                                  .ref("Database/SAPID/${widget.sapId}");
                              final colNameIndex = widget.bookCode.indexOf(
                                  "-", widget.bookCode.indexOf("-") + 1);
                              final colName =
                                  widget.bookCode.substring(0, colNameIndex);
                              DatabaseReference ReqRef =
                                  FirebaseDatabase.instance.ref(
                                      "Database/Requests/${widget.bookCode}/SapId/${widget.sapId}");
                              final query =
                                  await ReqRef.child("TimeStamp").get();
                              final TimeStamp =
                                  int.parse(query.value.toString());
                              print("Time Stamep : $TimeStamp");
                              print("Is thus shir awdawdw");
                              await ReqRef.remove();
                              final docRef = await FirebaseFirestore.instance
                                  .collection(colName)
                                  .doc(widget.bookCode)
                                  .update(
                                      {"Requested": FieldValue.increment(-1)});

                              await ref
                                  .child("BooksRequested/${widget.bookCode}")
                                  .remove();
                              final dataRef = FirebaseDatabase.instance
                                  .ref("Database/Requests/${widget.bookCode}");
                              DataSnapshot temp =
                                  await dataRef.child("requested").get();
                              print("Valur of thi sis ${temp.value}");
                              int ReqVal = int.parse(temp.value.toString());
                              int res = ReqVal - 1;
                              print("This is the value of Req $ReqVal");
                              await dataRef.update({"requested": res});
                              await dataRef
                                  .child("SapId")
                                  .orderByChild("TimeStamp")
                                  .get()
                                  .then((snapshot) {
                                final data = Map<String, dynamic>.from(
                                    snapshot.value as dynamic);
                                data.forEach((key, value) {
                                  print(
                                      "This the new timestamp : ${value["TimeStamp"]} and this the key : $key");
                                  print(
                                      "type of new TimeSTamp : ${TimeStamp.runtimeType}");
                                  print(
                                      "Type of timeStamp frm the var: ${value["TimeStamp"].runtimeType}");
                                  int DBTimeStamp = value["TimeStamp"];
                                  int val = int.parse(value["position"]);
                                  if (DBTimeStamp > TimeStamp) {
                                    print("hey I am working");
                                    dataRef
                                        .child("SapId/$key")
                                        .update({"position": val - 1});
                                  }
                                });
                              });
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(158, 90, 100, 1.0),
                              minimumSize: const Size(100, 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text("Remove"))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
        });
  }
}
