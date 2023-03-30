import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/views/IssueBook.dart';
import 'package:firstapp/views/ReturnBook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../constants/routes.dart';
import '../enum/menuActions.dart';
import '../main.dart';
import '../services/auth/auth_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var colName = "";
  var colNameIndex = 0;
  var result = 'QR CODE RESULT';
  bool _active = false;
  int _currentIndex = 0;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("ADMIN PAGE"),
          backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
          actions: [
            PopupMenuButton<MenuAction>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await ShowPopUp(context);
                      if (shouldLogout) {
                        await AuthService.firebase().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      } else {
                        return;
                      }
                      break;
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                        value: MenuAction.logout, child: Text("Logout"))
                  ];
                })
          ]),
      backgroundColor: const Color.fromRGBO(244, 223, 195, 1.0),
      body: Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  issueBookViaQR();
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Issue Book"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  returnBookViaQR();
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                  minimumSize: const Size(250, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Return Book"),
              ),
              Text(result),
            ],
          ),
        ),
      ),
      // body: StreamBuilder(
      //     stream: _cols.snapshots(),
      //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      //       if (streamSnapshot.hasData) {
      //         return ListView.builder(
      //             itemCount: streamSnapshot.data!.docs.length,
      //             itemBuilder: (context, index) {
      //               final DocumentSnapshot documentSnapshot =
      //                   streamSnapshot.data!.docs[index];
      //               return Card(
      //                   margin: const EdgeInsets.all(10),
      //                   child: ListTile(
      //                     title: Text(documentSnapshot['Name']),
      //                     subtitle: Text(documentSnapshot['Author']),
      //                   ));
      //             });
      //       }
      //       return const Center(child: CircularProgressIndicator());
      //     }),
    );
  }

  void issueBookViaQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#fff666", "Cancel", true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        result = qrCode;
      });
      colNameIndex = qrCode.indexOf("-", qrCode.indexOf("-") + 1);
      colName = qrCode.substring(0, colNameIndex);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IssueBook(colName: colName, docName: result)));
    } on PlatformException {
      result = "Failed to Scan QR CODE";
    }
  }

  void returnBookViaQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#fff666", "Cancel", true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        result = qrCode;
      });
      colNameIndex = qrCode.indexOf("-", qrCode.indexOf("-") + 1);
      colName = qrCode.substring(0, colNameIndex);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ReturnBook(colName: colName, docName: result)));
    } on PlatformException {
      result = "Failed to Scan QR CODE";
    }
  }
}
