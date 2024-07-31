import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/utilities/ErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utilities/showMessage.dart';

class SearchBookViewer extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName, bookAuthor, bookCode, Availability, DomainName;
  final List<dynamic> queue;
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
      required this.Name,
      required this.DomainName,
      required this.queue})
      : super(key: key);

  @override
  State<SearchBookViewer> createState() => _SearchBookViewerState();
}

class _SearchBookViewerState extends State<SearchBookViewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                        height: 180,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.value,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )),
                  ),
                  Flexible(
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: widget.color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              widget.Availability,
                              style: widget.Availability == "Not Available"
                                  ? const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red)
                                  : const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Domain: ${widget.DomainName}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.lightBlue),
                            ),
                            // const SizedBox(height: 0),
                            Text(
                              "In Queue: ${widget.queue.length}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.lightBlue),
                            ),
                            const SizedBox(height: 2),
                            Visibility(
                              visible:
                                  widget.queue.contains(widget.sapId) == false,
                              child: TextButton(
                                onPressed: () async {
                                  final result = await ShowMessage(context);
                                  if (result == false) {
                                    return;
                                  }
                                  DatabaseReference ref = FirebaseDatabase
                                      .instance
                                      .ref("Database/SAPID/${widget.sapId}");
                                  // DatabaseReference requestRef =
                                  //     FirebaseDatabase.instance.ref(
                                  //         "Database/Requests/${widget.bookCode}");
                                  DateTime date = DateTime.now();
                                  String formattedDate =
                                      DateFormat("yMd").format(date);
                                  final listsnapshot =
                                      await ref.child('BooksRequested').get();
                                  if (listsnapshot.exists) {
                                    if (listsnapshot.children.length == 3) {
                                      print(
                                          "Maximum Book Issuing limit reached!");
                                      showError(context,
                                          "Maximum Book Issuing limit reached!");
                                      return;
                                    }
                                  }
                                  final snapshot = await ref
                                      .child(
                                          'BooksRequested/${widget.bookCode}')
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
                                        "Domain": widget.DomainName,
                                        "BookAuthor": widget.bookAuthor,
                                        "RequestedDate": formattedDate,
                                        "BookURL": widget.value
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
                                      "Requested": FieldValue.increment(1),
                                      "queue":
                                          FieldValue.arrayUnion([widget.sapId])
                                    });
                                    // var requestedBy = await FirebaseFirestore
                                    //     .instance
                                    //     .collection(colName)
                                    //     .doc(widget.bookCode)
                                    //     .get()
                                    //     .then(
                                    //         (snapshot) => snapshot["Requested"]);
                                    // await requestRef.update({
                                    //   "SapId/${widget.sapId}": {
                                    //     "Name": widget.Name,
                                    //     "TimeStamp": ServerValue.timestamp,
                                    //     "position": requestedBy,
                                    //     "BookURL": widget.value
                                    //   },
                                    //   "requested": requestedBy
                                    // });
                                    showError(context,
                                        "Book Request Done successfully");
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(158, 90, 100, 1.0),
                                  minimumSize: const Size(100, 25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Request Book"),
                              ),
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
