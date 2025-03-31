import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key, required this.diet});

  final Map<dynamic, dynamic> diet;

  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  int _selectedButtonIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  void _saveActivityLevel(int index) {
    double level;

    switch (index) {
      case 0:
        level = 1.2;
        break;
      case 1:
        level = 1.375;
        break;
      case 2:
        level = 1.55;
        break;
      case 3:
        level = 1.725;
        break;
      case 4:
        level = 1.9;
        break;
      default:
        level = 1.2;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _firestore.collection('users').doc(user.uid).set({
        'activityLevel': level,
      }, SetOptions(merge: true)) // Using merge to preserve other fields
          .then((_) {
        print("Activity Level saved successfully!");
        Navigator.pushNamed(context, '/Step4',
            arguments: {'diet': widget.diet, 'navigateTo': '/Step5'});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save level. Please try again.')),
        );
        print("Error saving goal: ${error.code} - ${error.message}");
      });
    }
  }

  Widget _buildActivityButton(String title, String description, int index) {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150, // Increase AppBar height as needed
        flexibleSpace: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      iconSize: 50.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "What’s your baseline activity level?",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  "Not including workouts - we count that separately.",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // const Spacer(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActivityButton(
                      "Sedentary",
                      "Little or No Exercise (e.g., Primarily desk-bound job, minimal daily movement).",
                      0,
                    ),
                    const SizedBox(height: 20),
                    _buildActivityButton(
                      "Lightly Active",
                      "Light Exercise 1–3 Days/Week (e.g., Some moderate walks or short workouts each week).",
                      1,
                    ),
                    const SizedBox(height: 20),
                    _buildActivityButton(
                      "Moderately Active",
                      "Moderate Exercise 3–5 Days/Week (e.g., Regular workouts - running, cycling, gym - most days of the week).",
                      2,
                    ),
                    const SizedBox(height: 20),
                    _buildActivityButton(
                      "Very Active",
                      "Hard Exercise 6–7 Days/Week (e.g., Intense training or physically demanding job nearly every day).",
                      3,
                    ),
                    const SizedBox(height: 20),
                    _buildActivityButton(
                      "Extra Active",
                      "Very Hard Exercise, Possibly 2×/Day (e.g., Elite athlete or someone doing intense physical training twice a day, plus a very active job).",
                      4,
                    ),
                  ],
                ),
              ),
            ),
            // Spacer(),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveActivityLevel(_selectedButtonIndex);
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
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
