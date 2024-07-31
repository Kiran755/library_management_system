import 'package:flutter/material.dart';

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
        color: Colors.white,
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
                  child: Image.network(
                    widget.value,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
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
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    widget.bookAuthor,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.bookCode,
                    textAlign: TextAlign.left,
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
