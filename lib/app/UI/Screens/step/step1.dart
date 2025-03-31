import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/app/Data/goals.dart';

class Step1 extends StatefulWidget {
  const Step1({super.key});

  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  String goal = "";
  int _selectedButtonIndex = -1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  void _saveGoal(String goal) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _firestore.collection('users').doc(user.uid).set({
        'goal': _selectedButtonIndex,
      }, SetOptions(merge: true)) // Using merge to preserve other fields
          .then((_) {
        print("Goal saved successfully!");
        Navigator.pushNamed(context, '/Step2',
            arguments: {'navigateTo': '/Step3'});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save goal. Please try again.')),
        );
        print("Error saving goal: ${error.code} - ${error.message}");
      });
    }
  }

  Widget _buildGoalButton(String text, int index) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedButtonIndex == index
            ? Color.fromARGB(221, 52, 121, 40)
            : Color.fromARGB(80, 118, 214, 101),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        minimumSize: Size(450, 100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Increased height
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(
                top: 30, left: 10, right: 10), // Added side padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      iconSize: 50.0,
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "What’s Your Goal?",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "We’ll personalize recommendations based on your goal.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: goals
                  .map((goal) {
                    int index = goals.indexOf(goal);
                    return [
                      _buildGoalButton(goal, index),
                      const SizedBox(height: 8),
                    ];
                  })
                  .expand((element) => element)
                  .toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveGoal(goal);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF347928),
              foregroundColor: Colors.white,
              minimumSize: const Size(250, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Next", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
