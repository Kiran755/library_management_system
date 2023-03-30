import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/views/SearchBookViewer.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchView extends StatefulWidget {
  final String sapId, Name;
  const SearchView({Key? key, required this.sapId, required this.Name})
      : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String name = "";
  var search = "awd";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromRGBO(218, 170, 99, 1),
            title: Card(
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('AL-DSA').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    color: const Color.fromRGBO(218, 170, 99, 1),
                    child: ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                              as Map<String, dynamic>;

                          if (name.isEmpty) {
                            return listItem(
                                context,
                                index,
                                data["Author"],
                                data["Code"],
                                data["Name"],
                                "assets/Book2.png",
                                data["Availability"],
                                data["Requested"],
                                widget.sapId,
                                widget.Name);
                          }
                          if (data['Name']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                            return listItem(
                                context,
                                index,
                                data["Author"],
                                data["Code"],
                                data["Name"],
                                "assets/Book2.png",
                                data["Availability"],
                                data["Requested"],
                                widget.sapId,
                                widget.Name);
                          }
                          return Container();
                        }),
                  );
          },
        ));
  }
}

Widget listItem(
    BuildContext context,
    int index,
    String bookAuthor,
    String bookCode,
    String bookName,
    String value,
    String Availability,
    int requested,
    String sapId,
    String Name) {
  return SearchBookViewer(
      bookAuthor: bookAuthor,
      bookCode: bookCode,
      bookName: bookName,
      color: Colors.white,
      value: value,
      Availability: Availability,
      requested: requested,
      sapId: sapId,
      Name: Name);
}
