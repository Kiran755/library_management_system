import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/views/book_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String name = "";
  var search = "awd";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            decoration: InputDecoration(
              hintText: "G.V KumBhojkar",
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
            onChanged: (val) {
              name = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("14 Searches"),
              Expanded(child: SizedBox()),
              const Text("Filters:Some Filter"),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("AL-DSA").snapshots(),
              builder: (context, snapshots) {
                var fromDatabase = snapshots.data!.docs[1].data();
                print("Data from database $fromDatabase");
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data2 = snapshots.data!.docs[index].data();
                          var data = snapshots.data!.docs[index].data()
                              as Map<String, dynamic>;
                          print("Data from database using data2");
                          if (data.isEmpty) {
                            return ListTile(
                              title: Text(
                                data["Name"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                data["Author"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          if (data["Name"]
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                            return ListTile(
                              title: Text(
                                data["Name"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                data["Author"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return Container(
                            child: const Text("Data comes here"),
                          );
                        });
              }),
        ),
      ],
    );
  }
}
