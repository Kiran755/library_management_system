import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/constants/colors.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _name = 'Loading...';
  String _sapId = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _name = '-';
        _sapId = '-';
      });
      return;
    }

    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Database/Names/$uid");

    try {
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        var data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _name = data['Name'] ?? '-';
          _sapId = data['SapId'].toString() ?? '-';
        });
      } else {
        setState(() {
          _name = '-';
          _sapId = '-';
        });
      }
    } catch (e) {
      setState(() {
        _name = 'Error fetching data';
        _sapId = 'Error fetching data';
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                _name,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              const Text(
                "Sap ID",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                _sapId,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
