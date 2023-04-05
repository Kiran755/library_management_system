import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/utilities/ErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../utilities/showMessage.dart';

class SearchBookViewer extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName, bookAuthor, bookCode, Availability;
  final int requested;
  final String sapId, Name;
  const SearchBookViewer(
      {Key? key,
      required this.bookAuthor,
      required this.bookCode,
      required this.bookName,
      required this.color,
      required this.value,
      required this.Availability,
      required this.requested,
      required this.sapId,
      required this.Name})
      : super(key: key);

  @override
  State<SearchBookViewer> createState() => _SearchBookViewerState();
}

class _SearchBookViewerState extends State<SearchBookViewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(244, 223, 195, 1.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Container(
                      child: Image.network(
                        widget.value,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      height: 180,
                      width: 100),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: widget.color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookName,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              widget.bookAuthor,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.Availability,
                              style: widget.Availability == "Not Available"
                                  ? const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red)
                                  : const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Domain: Algorithms and Data Structures",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.lightBlue),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "In Queue: ${widget.requested}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.lightBlue),
                            ),
                            TextButton(
                              onPressed: () async {
                                final result = await ShowMessage(context);
                                if (result == false) {
                                  return;
                                }
                                DatabaseReference ref = FirebaseDatabase
                                    .instance
                                    .ref("Database/SAPID/${widget.sapId}");
                                DatabaseReference requestRef =
                                    FirebaseDatabase.instance.ref(
                                        "Database/Requests/${widget.bookCode}");
                                DateTime date = DateTime.now();
                                String formattedDate =
                                    DateFormat("yMd").format(date);
                                final Listsnapshot =
                                    await ref.child('BooksRequested').get();
                                if (Listsnapshot.exists) {
                                  if (Listsnapshot.children.length == 3) {
                                    print(
                                        "Maximum Book Issuing limit reached!");
                                    showError(context,
                                        "Maximum Book Issuing limit reached!");
                                    return;
                                  }
                                }
                                final snapshot = await ref
                                    .child('BooksRequested/${widget.bookCode}')
                                    .get();
                                if (snapshot.exists) {
                                  print("Book Already Exits!");
                                  showError(context, "Book Already Exists!");
                                  return;
                                } else {
                                  await ref.update({
                                    "BooksRequested/${widget.bookCode}": {
                                      "BookCode": widget.bookCode,
                                      "BookName": widget.bookName,
                                      "BookAuthor": widget.bookAuthor,
                                      "RequestedDate": formattedDate
                                    },
                                  });
                                  var colNameIndex = widget.bookCode.indexOf(
                                      "-", widget.bookCode.indexOf("-") + 1);
                                  var colName = widget.bookCode
                                      .substring(0, colNameIndex);
                                  FirebaseFirestore.instance
                                      .collection(colName)
                                      .doc(widget.bookCode)
                                      .update({
                                    "Requested": FieldValue.increment(1)
                                  });
                                  var requestedBy = await FirebaseFirestore
                                      .instance
                                      .collection(colName)
                                      .doc(widget.bookCode)
                                      .get()
                                      .then(
                                          (snapshot) => snapshot["Requested"]);
                                  await requestRef.update({
                                    "SapId/${widget.sapId}": {
                                      "Name": widget.Name,
                                      "TimeStamp": ServerValue.timestamp,
                                      "position": requestedBy
                                    },
                                    "requested": requestedBy
                                  });
                                  showError(context,
                                      "Book Request Done successfully");
                                }
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
                              child: const Text("Request Book"),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
