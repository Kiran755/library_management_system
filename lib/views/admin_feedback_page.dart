import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/constants/colors.dart';

class AdminFeedbackPage extends StatelessWidget {
  const AdminFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      appBar: AppBar(
        title: const Text("Admin Feedback"),
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
              final dateTime = timestamp?.toDate();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(feedbackText),
                  subtitle: dateTime != null
                      ? Text(dateTime.toString())
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
