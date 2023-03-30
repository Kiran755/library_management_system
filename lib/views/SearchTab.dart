import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchTab extends StatefulWidget {
  final String Name, SapId;
  const SearchTab({Key? key, required this.Name, required this.SapId})
      : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  var sapid;
  @override
  void initState() {
    super.initState();
    sapid = widget.SapId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SingleChildScrollView(
            child: Column(
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
                      "BOOKS ASSIGNED",
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
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(234, 223, 209, 0.6),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: const Color.fromRGBO(158, 90, 100, 1.0),
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Expanded(
                    child: SizedBox(
                      height: 500,
                      child: FirebaseAnimatedList(
                        defaultChild: const Center(
                            child: const CircularProgressIndicator()),
                        query: FirebaseDatabase.instance.ref(
                            "Database/SAPID/${widget.SapId}/BooksAssigned"),
                        itemBuilder: (context, snapshot, animation, index) {
                          print("SPAID : ${widget.SapId}");
                          return Column(
                            children: [
                              BookViewer(
                                value: "assets/Book2.png",
                                DueDate:
                                    snapshot.child("Due Date").value.toString(),
                                IssueDate: snapshot
                                    .child("Issued Date")
                                    .value
                                    .toString(),
                                bookAuthor: snapshot
                                    .child("BookAuthor")
                                    .value
                                    .toString(),
                                bookName:
                                    snapshot.child("BookName").value.toString(),
                                bookCode:
                                    snapshot.child("BookCode").value.toString(),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void getSAPID() async {
  //   final snapshot =
  //       await FirebaseDatabase.instance.ref("Database/Names/$userUid").get();
  //   if (snapshot.exists) {
  //     final sap_id = snapshot.child("/$userUid");
  //     print(sap_id);
  //     sapid = sap_id;
  //   }
  // }
}
