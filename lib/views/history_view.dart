import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  final String SapId;
  const HistoryView({Key? key, required this.SapId}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  var sapId;
  @override
  void initState() {
    super.initState();
    sapId = widget.SapId;
  }

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
              "HISTORY",
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
                height: 550,
                child: FirebaseAnimatedList(
                  defaultChild:
                      const Center(child: CircularProgressIndicator()),
                  query: FirebaseDatabase.instance
                      .ref("Database/SAPID/${widget.SapId}/BooksHistory"),
                  itemBuilder: (context, snapshot, animation, index) {
                    return Column(
                      children: [
                        BookViewer(
                          color: Colors.white,
                          value: snapshot.child("BookURL").value.toString(),
                          DueDate:
                              snapshot.child("Returned Date").value.toString(),
                          IssueDate:
                              snapshot.child("Issued Date").value.toString(),
                          bookAuthor:
                              snapshot.child("BookAuthor").value.toString(),
                          bookName: snapshot.child("BookName").value.toString(),
                          bookCode: snapshot.child("BookCode").value.toString(),
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
