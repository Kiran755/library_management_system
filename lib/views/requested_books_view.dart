import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firstapp/views/SearchBookViewer.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:firstapp/views/requestBookViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RequestedBookView extends StatefulWidget {
  final String SapId;
  const RequestedBookView({Key? key, required this.SapId}) : super(key: key);

  @override
  State<RequestedBookView> createState() => _RequestedBookViewState();
}

class _RequestedBookViewState extends State<RequestedBookView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
                child: Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
              color: Color.fromARGB(150, 12, 11, 11),
            )),
            Text(
              "BOOKS REQUESTED",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Expanded(
                child: Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
              color: Color.fromARGB(150, 12, 11, 11),
            )),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Expanded(
                child: SizedBox(
                  height: 500,
                  child: FirebaseAnimatedList(
                    defaultChild:
                        const Center(child: CircularProgressIndicator()),
                    query: FirebaseDatabase.instance
                        .ref("Database/SAPID/${widget.SapId}/BooksRequested"),
                    itemBuilder: (context, snapshot, animation, index) {
                      var requests = FirebaseDatabase.instance
                          .ref(
                              "Database/Requests/${snapshot.child("BookCode").value.toString()}/requested")
                          .get()
                          .then((snapshot) => snapshot.value.toString());
                      print(requests);
                      return Column(
                        children: [
                          RequestBookViewer(
                            color: Colors.white,
                            value: "assets/Book2.png",
                            issuedDate: snapshot
                                .child("RequestedDate")
                                .value
                                .toString(),
                            requestedBy: snapshot.children.length.toString(),
                            bookAuthor:
                                snapshot.child("BookAuthor").value.toString(),
                            bookName:
                                snapshot.child("BookName").value.toString(),
                            bookCode:
                                snapshot.child("BookCode").value.toString(),
                            sapId: widget.SapId,
                          ),
                          const Divider(
                            indent: 10,
                            endIndent: 10,
                            thickness: 5,
                            color: Color.fromRGBO(158, 90, 100, 1.0),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
