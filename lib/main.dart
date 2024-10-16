import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/constants/routes.dart';
import 'package:firstapp/services/auth/auth_service.dart';
import 'package:firstapp/services/notifi_service.dart';
import 'package:firstapp/views/BooksOverDue.dart';
import 'package:firstapp/views/EmailVerify.dart';
import 'package:firstapp/views/FirstScreen.dart';
import 'package:firstapp/views/IssueBook.dart';
import 'package:firstapp/views/LoginView.dart';
import 'package:firstapp/views/NotesView.dart';
import 'package:firstapp/views/RegisterView.dart';
import 'package:firstapp/views/admin_page.dart';
import 'package:firstapp/views/books_circulation.dart';
import 'package:firstapp/views/feedback_page.dart';
import 'package:firstapp/views/new_admin_menu.dart';
import 'package:firstapp/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter environment is ready

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
    return;
  }

  // Initialize notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS initialization settings
  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true);

  // Combine settings for Android and iOS
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Initialize notifications plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  tz.initializeTimeZones();

  // Run the app
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme:
    ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat-Black'),
    home: const FirstScreen(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(Name: "", SapID: ""),
      emailVerify: (context) => const EmailVerify(),
      adminPage: (context) => const AdminPage(),
      profile: (context) => const Profile(),
      feedBack: (context) => const FeedBack(),
      booksCirculation: (context) => const BooksInCirculation(),
      BooksOverDue: (context) => const BooksOverdue(),
      newAdminPage: (context) => const NewAdminPage(),
    },
  ));
}


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialze(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              print(user);
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView(Name: "", SapID: "");
                } else {
                  return const EmailVerify();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

Future<bool> ShowPopUp(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Logout"))
        ],
      );
    },
  ).then((value) => value ?? false);
}
// This widget is the root of your application

