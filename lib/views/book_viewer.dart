import 'package:firstapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookViewer extends StatefulWidget {
  const BookViewer(
      {Key? key, required this.value, this.color = Colors.transparent})
      : super(key: key);
  final String value;
  final Color color;
  @override
  State<BookViewer> createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: widget.color,
      ),
      child: Row(
        children: [
          Image.asset(widget.value),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "The Psychology of Money",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Text(
                "Morgel Housel",
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 90,
              ),
              Text(
                "Due Date:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
              Text(
                "6th March 2022",
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
