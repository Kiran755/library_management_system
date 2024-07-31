import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BooksOverdueViewer extends StatefulWidget {
  final String value;
  final Color color;
  final String bookName, bookAuthor, bookCode, DueDate, IssueDate;
  // final String bookAuthor;
  // final String bookCode;
  const BooksOverdueViewer({
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
  State<BooksOverdueViewer> createState() => _BooksOverdueViewerState();
}

class _BooksOverdueViewerState extends State<BooksOverdueViewer> {
  @override
  Widget build(BuildContext context) {
    var Fine = FineCalculator(widget.DueDate);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: widget.color,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: 180,
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: widget.value,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Due Date: ${widget.DueDate}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                  ),
                  Text(
                    "FINE DUE: Rs. $Fine",
                    style: const TextStyle(
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

  int FineCalculator(String dueDate) {
    var Year = int.parse(dueDate.substring(6));
    var Month = int.parse(dueDate.substring(3, 5));
    var Day = int.parse(dueDate.substring(0, 2));

    var date = DateTime(Year, Month, Day);
    var difference = DateTime.now().difference(date).inDays;
    var fine = difference * 5;

    return fine;
  }
}
