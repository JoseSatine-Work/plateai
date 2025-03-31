import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Section
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Image.asset(
              'assets/icons/icon.png',
              height: 300,
            ),
          ),
          const SizedBox(height: 120),
          // "Get Start" Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/SignUp');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF347928),
                foregroundColor: Colors.white,
                minimumSize: const Size(350, 50),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: Text(
              "Get Started",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10), // Spacing between buttons
          // "Log In" Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/LogIn');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF347928),
                elevation: 5,
                minimumSize: const Size(350, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFF347928)),
                )),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ));
  }
}
