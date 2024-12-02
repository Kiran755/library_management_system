import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../views/requestBookViewer.dart';
import 'package:flutter/material.dart';

class RequestedBookView extends StatefulWidget {
  final String SapId;

  const RequestedBookView({Key? key, required this.SapId}) : super(key: key);

  @override
  State<RequestedBookView> createState() => _RequestedBookViewState();
}

class _RequestedBookViewState extends State<RequestedBookView> {
  List<String> queueData = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //     child: Divider(
            //   indent: 10,
            //   endIndent: 10,
            //   thickness: 1,
            //   color: Color.fromARGB(150, 12, 11, 11),
            // )),
            Text(
              "BOOKS REQUESTED",
              style: TextStyle(
                  fontSize: 22,
                  // color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            // Expanded(
            //     child: Divider(
            //   indent: 10,
            //   endIndent: 10,
            //   thickness: 1,
            //   color: Color.fromARGB(150, 12, 11, 11),
            // )),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 540,
                child: FirebaseAnimatedList(
                  defaultChild:
                      const Center(child: CircularProgressIndicator()),
                  query: FirebaseDatabase.instance
                      .ref("Database/SAPID/${widget.SapId}/BooksRequested"),
                  itemBuilder: (context, snapshot, animation, index) {
                    FirebaseFirestore.instance
                        .collection("${snapshot.child("DomainName")}")
                        .doc("${snapshot.child("BookCode")}")
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      // Check if the document exists.
                      if (documentSnapshot.exists) {
                        // Access the data from the document.
                        Map<String, dynamic> data =
                            documentSnapshot.data() as Map<String, dynamic>;
                        List<String> firestoreQueue =
                            data['queue'] as List<String>;
                        setState(() {
                          queueData = List.from(firestoreQueue);
                        });
                      } else {
                        // Document does not exist.
                        // Handle the case where the document is not found.
                      }
                    }).catchError((error) {
                      // Handle any errors that occur during the operation.
                    });
                    return Column(
                      children: [
                        RequestBookViewer(
                          color: Colors.white,
                          value: snapshot.child("BookURL").value.toString(),
                          issuedDate:
                              snapshot.child("RequestedDate").value.toString(),
                          requestedBy: snapshot.children.length.toString(),
                          bookAuthor:
                              snapshot.child("BookAuthor").value.toString(),
                          bookName: snapshot.child("BookName").value.toString(),
                          bookCode: snapshot.child("BookCode").value.toString(),
                          sapId: widget.SapId,
                          DomainName: snapshot.child("Domain").value.toString(),
                          queueData: queueData,
                        ),
                        const Divider(
                          indent: 10,
                          endIndent: 10,
                          thickness: 5,
                          color: Colors.transparent,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
