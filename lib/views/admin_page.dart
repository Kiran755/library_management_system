import '../views/IssueBook.dart';
import '../views/ReturnBook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'admin_feedback_page.dart';

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
  final int _currentIndex = 0;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 240),
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminFeedbackPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                minimumSize: const Size(250, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Feedbacks"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                issueBookViaQR();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
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
                foregroundColor: Colors.white,
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
