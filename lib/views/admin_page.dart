import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final CollectionReference _cols =
      FirebaseFirestore.instance.collection('AL-DSA');
  var result = 'QR CODE RESULT';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN PAGE"),
        backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(244, 223, 195, 1.0),
      body: StreamBuilder(
          stream: _cols.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(documentSnapshot['Name']),
                          subtitle: Text(documentSnapshot['Author']),
                        ));
                  });
            }
            return const Center(child: CircularProgressIndicator());
            // return Padding(
            //   padding: const EdgeInsets.only(top: 300),
            //   child: Center(
            //     child: Column(
            //       children: [
            //         TextButton(
            //           onPressed: () {
            //             scanQRcode();
            //           },
            //           style: TextButton.styleFrom(
            //             primary: Colors.white,
            //             backgroundColor:
            //                 const Color.fromRGBO(158, 90, 100, 1.0),
            //             minimumSize: const Size(250, 40),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(25),
            //             ),
            //           ),
            //           child: const Text("Scan QR CODE"),
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         Text(result)
            //       ],
            //     ),
            //   ),
            // );
          }),
    );
  }

  void scanQRcode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#fff666", "Cancel", true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        result = qrCode;
      });
      print(qrCode);
    } on PlatformException {
      result = "Failed to Scan QR CODE";
    }
  }
}
