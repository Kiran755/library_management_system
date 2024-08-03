import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecommendBookViewer extends StatefulWidget {
  final Color color;
  final String bookName, bookAuthor, bookCode;
  const RecommendBookViewer({
    Key? key,
    this.color = Colors.transparent,
    required this.bookName,
    required this.bookAuthor,
    required this.bookCode,
  }) : super(key: key);

  @override
  State<RecommendBookViewer> createState() => _RecommendBookViewerState();
}

class _RecommendBookViewerState extends State<RecommendBookViewer> {
  @override
  void initState() {
    super.initState();
    // Intercept the back button press event
    SystemChannels.navigation.setMethodCallHandler((call) async {
      if (call.method == 'pop') {
        final shouldPop = await _showLogoutConfirmationDialog();
        if (shouldPop) {
          // Allow the pop
          return;
        } else {
          // Prevent the pop
          throw PlatformException(code: 'CANCELLED');
        }
      }
      return;
    });
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: widget.color,
        ),
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: widget.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookName,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.bookAuthor,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.bookCode,
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
