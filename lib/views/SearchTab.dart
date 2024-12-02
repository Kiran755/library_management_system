import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../views/book_viewer.dart';
import '../views/recomend_book_viewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchTab extends StatefulWidget {
  final String Name, SapId;

  const SearchTab({Key? key, required this.Name, required this.SapId})
      : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  var sapid;
  var _books;
  late final Future booksData;
  @override
  void initState() {
    super.initState();
    sapid = widget.SapId;
    booksData = networkCall();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //     child: Divider(
                    //   indent: 10,
                    //   endIndent: 10,
                    //   thickness: 1.4,
                    //   color: Color.fromRGBO(101, 101, 101, 0.2),
                    // )),
                    Text(
                      "BOOKS ASSIGNED",
                      style: TextStyle(
                          fontSize: 22,
                          // color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    // Expanded(
                    //     child: Divider(
                    //   indent: 10,
                    //   endIndent: 10,
                    //   thickness: 1.4,
                    //   color: Color.fromRGBO(101, 101, 101, 0.2),
                    // )),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: const Color.fromRGBO(158, 90, 100, 1.0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SizedBox(
                    height: 400,
                    child: FirebaseAnimatedList(
                      defaultChild:
                          const Center(child: CircularProgressIndicator()),
                      query: FirebaseDatabase.instance
                          .ref("Database/SAPID/${widget.SapId}/BooksAssigned"),
                      itemBuilder: (context, snapshot, animation, index) {
                        print("SPAID : ${widget.SapId}");
                        // String date =
                        //     snapshot.child("Due Date").value.toString();
                        // String tempDay = date.substring(0, date.indexOf("/"));

                        // String dueDay =
                        //     int.parse(tempDay) < 10 ? "0" + tempDay : tempDay;

                        // String sub = date.substring(date.indexOf("/") + 1);
                        // String tempMonth = sub.substring(0, sub.indexOf("/"));
                        // String dueMonth = int.parse(tempMonth) < 10
                        //     ? "0" + tempMonth
                        //     : tempMonth;
                        // String dueYear = sub.substring(sub.indexOf("/") + 1);
                        // print("This is the year : $sub");
                        // String formatDate =
                        //     "$dueYear-$dueMonth-$dueDay 12:00:00";
                        // DateTime new_date = DateTime.parse(formatDate);
                        // debugPrint(
                        //     "Notifcation scheduled for that time $new_date");
                        // NotificationService().scheduleNotification(
                        //     title: "Reminder",
                        //     body:
                        //         "Reminder for returning the book today! If you have already returned the book,please ignore this message",
                        //     scheduledNotificationDateTime: new_date);
                        return Column(
                          children: [
                            BookViewer(
                              value: snapshot.child("BookURL").value.toString(),
                              DueDate:
                                  snapshot.child("Due Date").value.toString(),
                              IssueDate: snapshot
                                  .child("Issued Date")
                                  .value
                                  .toString(),
                              bookAuthor:
                                  snapshot.child("BookAuthor").value.toString(),
                              bookName:
                                  snapshot.child("BookName").value.toString(),
                              bookCode:
                                  snapshot.child("BookCode").value.toString(),
                            ),
                            const Divider(
                              indent: 10,
                              endIndent: 10,
                              thickness: 2,
                              color: Color.fromRGBO(158, 90, 100, 1.0),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
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
                      "BOOKS RECOMMENDED",
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
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: const Color.fromRGBO(158, 90, 100, 1.0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FutureBuilder(
                      future: booksData,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const CircularProgressIndicator();

                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();

                          case ConnectionState.active:
                            return const CircularProgressIndicator();

                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              var books = [];
                              books = snapshot.data as List<dynamic>;

                              print("this is form builder : ${snapshot.data}");
                              return SizedBox(
                                height: 650,
                                child: Column(
                                  children: [
                                    RecommendBookViewer(
                                        bookAuthor: books != Null
                                            ? books[0][3].toString()
                                            : "",
                                        bookCode: books != Null
                                            ? books[0][1].toString()
                                            : "",
                                        bookName: books != Null
                                            ? books[0][2].toString()
                                            : ""),
                                    RecommendBookViewer(
                                        bookAuthor: books != Null
                                            ? books[1][3].toString()
                                            : "",
                                        bookCode: books != Null
                                            ? books[1][1].toString()
                                            : "",
                                        bookName: books != Null
                                            ? books[1][2].toString()
                                            : ""),
                                    RecommendBookViewer(
                                        bookAuthor: books != Null
                                            ? books[2][3].toString()
                                            : "",
                                        bookCode: books != Null
                                            ? books[2][1].toString()
                                            : "",
                                        bookName: books != Null
                                            ? books[2][2].toString()
                                            : ""),
                                    RecommendBookViewer(
                                        bookAuthor: books != Null
                                            ? books[3][3].toString()
                                            : "",
                                        bookCode: books != Null
                                            ? books[3][1].toString()
                                            : "",
                                        bookName: books != Null
                                            ? books[3][2].toString()
                                            : "")
                                  ],
                                ),
                              );
                            } else {
                              return const Text("No data found");
                            }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> networkCall() async {
    var url =
        Uri.http('kiran12.pythonanywhere.com', '/book/Data Structures using C');
    print(url);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      setState(() {
        _books = jsonResponse["Books"];
      });
      print('Number of books about http: ${jsonResponse["Books"][0]}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return _books;
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
