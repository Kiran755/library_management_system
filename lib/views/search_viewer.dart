import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/views/SearchBookViewer.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../constants/domains.dart';

class SearchView extends StatefulWidget {
  final String sapId, Name;
  const SearchView({Key? key, required this.sapId, required this.Name})
      : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String name = "";
  String dropdownvalue = "Algorithms And Data Structures";
  Map<String, String> domain = {
    "Algorithms And Data Structures": "AL-DSA",
    "Programming In C": "BES-CP",
    "Algorithms And Engineering Applications": "AL-EA",
    "Programming in JAVA": "BES-JAVA",
    "Computer Organization and Architecture": "HD-COA",
    "Electronic Devices and Circuits": "HD-ES",
    "Microprocessors": "HD-MPMC",
    "Computer Networks": "NC-CN",
    "Web Technologies": "WST-IP"
  };

  List<String> domain_names = [];
  var items = [
    "Algorithms And Data Structures",
    "Programming In C",
    "Algorithms And Engineering Applications",
    "Computer Organization and Architecture",
    "Programming in JAVA",
    "Electronic Devices and Circuits",
    "Microprocessors",
    "Computer Networks",
    "Web Technologies",
  ];
  var search = "awd";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(218, 170, 99, 1),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color.fromRGBO(218, 170, 99, 1),
                    title: Card(
                      child: TextField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search...'),
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(177, 181, 113, 123),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.3), //shadow for button
                                  blurRadius: 1) //blur radius of shadow
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.72,
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                  isExpanded: true,
                                  dropdownColor:
                                      Color.fromARGB(255, 181, 113, 123),
                                  value: dropdownvalue,
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(domain[dropdownvalue] ?? dropdownvalue)
              .snapshots(),
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
                                data["AuthorName"],
                                data["BookCode"],
                                data["BookName"],
                                data["BookURL"],
                                data["Availability"],
                                data["Requested"],
                                widget.sapId,
                                widget.Name,
                                data["DomainName"],
                                (data['queue'] ?? []) as List<dynamic>);
                          }
                          if (data['AuthorName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name.toLowerCase()) ||
                              data['BookName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name.toLowerCase())) {
                            return listItem(
                                context,
                                index,
                                data["AuthorName"],
                                data["BookCode"],
                                data["BookName"],
                                data["BookURL"],
                                data["Availability"],
                                data["Requested"],
                                widget.sapId,
                                widget.Name,
                                data["DomainName"],
                                (data['queue'] ?? []) as List<dynamic>);
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
    String Name,
    String DomainName,
    List<dynamic> queue) {
  return SearchBookViewer(
      bookAuthor: bookAuthor,
      bookCode: bookCode,
      bookName: bookName,
      color: Colors.white,
      value: value,
      Availability: Availability,
      requested: requested,
      sapId: sapId,
      Name: Name,
      DomainName: DomainName,
      queue: queue);
}
