import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/colors.dart';
import 'package:intl/intl.dart';

class AdminFeedbackPage extends StatelessWidget {
  const AdminFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      appBar: AppBar(
        title:
            const Text("Admin Feedback", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No feedback available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final feedback = snapshot.data!.docs[index];
              final feedbackText = feedback['feedback'] ?? 'No feedback';
              final timestamp = feedback['timestamp'] as Timestamp?;
              // final dateTime = timestamp?.toDate();
              final formattedDate = timestamp != null
                  ? DateFormat('dd-MM-yyyy').format(timestamp.toDate())
                  : '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(feedbackText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  subtitle: formattedDate != ''
                      ? Text(
                          formattedDate.toString(),
                          style: const TextStyle(fontSize: 13),
                        )
                      : const Text('No timestamp'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
