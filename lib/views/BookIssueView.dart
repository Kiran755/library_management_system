import 'package:firstapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookIssueView extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName, bookAuthor, bookCode;
  // final String bookAuthor;
  // final String bookCode;
  const BookIssueView({
    Key? key,
    required this.value,
    this.color = Colors.transparent,
    required this.bookName,
    required this.bookAuthor,
    required this.bookCode,
  }) : super(key: key);
  @override
  State<BookIssueView> createState() => _BookIssueViewState();
}

class _BookIssueViewState extends State<BookIssueView> {
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
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: widget.color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.bookName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.bookAuthor,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.bookCode,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
