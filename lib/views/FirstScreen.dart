import 'package:firstapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 223, 195, 1.0),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset('assets/Books.svg'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "IT Library Management \nSystem",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Know about your Books\nAnywhere, Anytime.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 160,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(158, 90, 100, 1.0),
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Lets Jump In!",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
