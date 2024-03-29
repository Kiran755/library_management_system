import 'package:cached_network_image/cached_network_image.dart';
import 'package:firstapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookViewer extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName, bookAuthor, bookCode, DueDate, IssueDate;
  // final String bookAuthor;
  // final String bookCode;
  const BookViewer({
    Key? key,
    required this.value,
    this.color = Colors.transparent,
    required this.bookName,
    required this.bookAuthor,
    required this.bookCode,
    required this.DueDate,
    required this.IssueDate,
  }) : super(key: key);
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                child: CachedNetworkImage(
                  imageUrl: widget.value,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                height: 180,
                width: 100),
          ),
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
                  Text(
                    widget.bookAuthor,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.bookCode,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Issued Date: ${widget.IssueDate}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Due Date: ${widget.DueDate}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
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
