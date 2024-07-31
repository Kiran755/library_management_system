import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utilities/showMessage.dart';

class RequestBookViewer extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName,
      bookAuthor,
      bookCode,
      requestedBy,
      issuedDate,
      sapId,
      DomainName;
  final List<String> queueData;
  const RequestBookViewer(
      {Key? key,
      required this.bookAuthor,
      required this.bookCode,
      required this.bookName,
      required this.color,
      required this.issuedDate,
      required this.requestedBy,
      required this.value,
      required this.sapId,
      required this.DomainName,
      required this.queueData})
      : super(key: key);

  @override
  State<RequestBookViewer> createState() => _RequestBookViewerState();
}

class _RequestBookViewerState extends State<RequestBookViewer> {
  int position = -1;
  @override
  Widget build(BuildContext context) {
    // final dbref = FirebaseFirestore.instance.collection(widget.DomainName).doc(widget.bookCode);
    return FutureBuilder<int>(
        future: fetchFirestoreData(),
        builder: (BuildContext context, snapshot) {
          return (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                      height: 180,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.value,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )),
                ),
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
                          textAlign: TextAlign.left,
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
                          "Issued Date: ${widget.issuedDate}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Your position : ${snapshot.data}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue),
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
                              DocumentReference<Map<String, dynamic>>
                                  firestoreRef = FirebaseFirestore.instance
                                      .collection(colName)
                                      .doc(widget.bookCode);
                              DocumentSnapshot<Map<String, dynamic>> docSnap =
                                  await firestoreRef.get();
                              if (docSnap.exists) {
                                firestoreRef.update({
                                  'queue':
                                      FieldValue.arrayRemove([(widget.sapId)])
                                });
                              }

                              // DatabaseReference ReqRef =
                              //     FirebaseDatabase.instance.ref(
                              //         "Database/Requests/${widget.bookCode}/SapId/${widget.sapId}");
                              // final query =
                              //     await ReqRef.child("TimeStamp").get();
                              // final TimeStamp =
                              //     int.parse(query.value.toString());
                              // print("Time Stamep : $TimeStamp");
                              // print("Is thus shir awdawdw");
                              // await ReqRef.remove();
                              // final docRef = await FirebaseFirestore.instance
                              //     .collection(colName)
                              //     .doc(widget.bookCode)
                              //     .update(
                              //         {"Requested": FieldValue.increment(-1)});
                              await ref
                                  .child("BooksRequested/${widget.bookCode}")
                                  .remove();
                              // final dataRef = FirebaseDatabase.instance
                              //     .ref("Database/Requests/${widget.bookCode}");
                              // DataSnapshot temp =
                              //     await dataRef.child("requested").get();
                              // print("Valur of thi sis ${temp.value}");
                              // int ReqVal = int.parse(temp.value.toString());
                              // int res = ReqVal - 1;
                              // print("This is the value of Req $ReqVal");
                              // await dataRef.update({"requested": res});
                              // await dataRef
                              //     .child("SapId")
                              //     .orderByChild("TimeStamp")
                              //     .get()
                              //     .then((snapshot) {
                              //   final data = Map<String, dynamic>.from(
                              //       snapshot.value as dynamic);
                              //   data.forEach((key, value) {
                              //     print(
                              //         "This the new timestamp : ${value["TimeStamp"]} and this the key : $key");
                              //     print(
                              //         "type of new TimeSTamp : ${TimeStamp.runtimeType}");
                              //     print(
                              //         "Type of timeStamp frm the var: ${value["TimeStamp"].runtimeType}");
                              //     int DBTimeStamp = value["TimeStamp"];
                              //     int val = int.parse(value["position"]);
                              //     if (DBTimeStamp > TimeStamp) {
                              //       print("hey I am working");
                              //       dataRef
                              //           .child("SapId/$key")
                              //           .update({"position": val - 1});
                              //     }
                              //   });
                              // });
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

  Future<int> fetchFirestoreData() async {
    print("hello ${widget.DomainName} && ${widget.bookCode}");
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(widget.DomainName)
        .doc(widget.bookCode)
        .get();

    Map<String, dynamic> hello =
        documentSnapshot.data() as Map<String, dynamic>;

    print("hello $hello");
    int queuePosition = 0;
    List<dynamic> queue = hello['queue'] as List<dynamic>;
    queuePosition = queue.indexOf(widget.sapId);
    // setState(() {
    //   position = queuePosition + 1;
    // });
    print("POSITION AT : $position");
    return queuePosition + 1;
  }
}
