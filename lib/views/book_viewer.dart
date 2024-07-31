import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
                height: 180,
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.value,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )),
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
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    widget.bookAuthor,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    widget.bookCode,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Issued Date: ${widget.IssueDate}",
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "Due Date: ${widget.DueDate}",
                    style: const TextStyle(
                        fontSize: 13,
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
