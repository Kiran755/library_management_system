import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/views/SearchTab.dart';
import 'package:firstapp/views/history_view.dart';
import 'package:firstapp/views/requested_books_view.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/views/search_viewer.dart';
import '../constants/routes.dart';
import '../enum/menuActions.dart';
import '../main.dart';

class NotesView extends StatefulWidget {
  final String Name, SapID;
  const NotesView({Key? key, required this.Name, required this.SapID})
      : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  var tabs;
  var initials = "KD";
  @override
  void initState() {
    super.initState();
    print("Name :   ${widget.Name}");
    print("akwad :   ${widget.SapID}");
    var Fname = widget.Name[0].toUpperCase();
    var LnameIndex = widget.Name.indexOf(" ");
    var Lname = widget.Name[LnameIndex + 1].toUpperCase();
    initials = Fname + Lname;

    tabs = [
      SearchTab(Name: widget.Name, SapId: widget.SapID),
      SearchView(sapId: widget.SapID, Name: widget.Name),
      RequestedBookView(SapId: widget.SapID),
      HistoryView(SapId: widget.SapID)
    ];
  }

  bool _active = false;
  int _currentIndex = 0;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 170, 99, 1),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: _handleTap,
            child: CircleAvatar(
              backgroundColor: const Color.fromRGBO(249, 221, 150, 0.51),
              child: Text(
                initials,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        title: Text(
          widget.Name,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
              icon: const Icon(
                Icons.more_vert,
                color: Color.fromRGBO(0, 0, 0, 1.0),
              ),
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await ShowPopUp(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    } else {
                      return;
                    }
                    break;
                  case MenuAction.profile:
                    Navigator.pushNamed(context, profile);
                    break;
                  case MenuAction.feedback:
                    // Navigator.pushNamed(context, feedBack,arguments: );
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.profile, child: Text("Profile")),
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.feedback, child: Text("Feedback")),
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text("Logout"))
                ];
              })
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color.fromRGBO(158, 90, 100, 0.7),
          selectedItemColor: const Color.fromRGBO(158, 90, 100, 1),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Request",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "History")
          ],
          onTap: (index) => {
            setState(() {
              _currentIndex = index;
            })
          },
        ),
      ),
    );
  }
}
