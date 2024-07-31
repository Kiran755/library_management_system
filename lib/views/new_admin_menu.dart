import 'package:firstapp/views/BooksOverDue.dart';
import 'package:firstapp/views/IssueBook.dart';
import 'package:firstapp/views/ReturnBook.dart';
import 'package:firstapp/views/admin_page.dart';
import 'package:firstapp/views/books_circulation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firstapp/constants/colors.dart';

import '../constants/routes.dart';
import '../enum/menuActions.dart';
import '../main.dart';
import '../services/auth/auth_service.dart';

class NewAdminPage extends StatefulWidget {
  const NewAdminPage({Key? key}) : super(key: key);

  @override
  State<NewAdminPage> createState() => _NewAdminPageState();
}

class _NewAdminPageState extends State<NewAdminPage> {
  var colName = "";
  var colNameIndex = 0;
  var result = 'QR CODE RESULT';
  int _currentIndex = 0;
  var tabs = [];

  @override
  Widget build(BuildContext context) {
    tabs = [
      const AdminPage(),
      const BooksInCirculation(),
      const BooksOverdue()
    ];
    // bool _active = false;

    void handleTap(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text("ADMIN PAGE",
              style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
          foregroundColor: Colors.white,
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
      backgroundColor: bgColour,
      body: tabs[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromRGBO(158, 90, 100, 1),
          unselectedItemColor: const Color.fromRGBO(158, 90, 100, 0.7),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 22),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.roundabout_left_outlined),
              label: "Books",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Fine",
            ),
          ],
          onTap: handleTap,
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
