import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../Components/bmi_parameters.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;

class Step4 extends StatefulWidget {
  const Step4({super.key, required this.diet, this.navigateTo = '/Step5'});

  final Map<dynamic, dynamic> diet;
  final String navigateTo;

  @override
  _Step4State createState() => _Step4State();
}

class _Step4State extends State<Step4> {
  double _age = 20;
  double _height = 1.8;
  double _weight = 85;
  double _waist = 100;
  int gender = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
  }

  void _updateAge(double value) {
    setState(() {
      _age = value;
    });
  }

  void _updateHeight(double value) {
    setState(() {
      _height = value;
    });
  }

  void _updateWeight(double value) {
    setState(() {
      _weight = value;
    });
  }

  void _updateWaist(double value) {
    setState(() {
      _waist = value;
    });
  }

  void initValues() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user != null) {
      models.User user = userProvider.user!;

      setState(() {
        _age = user.age;
        _height = user.height;
        _weight = user.weight;
        _waist = user.waist;
      });
    }
  }

  void _saveFeatures() {
    User? user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (user != null) {
      _firestore.collection('users').doc(user.uid).set({
        // 'activityLevel': level,
        'gender': widget.navigateTo == '/Step5'
            ? (gender == 0 ? "Male" : "Female")
            : userProvider.user!.gender,
        'age': _age,
        'height': _height,
        'weight': _weight,
        'initialWeight': widget.navigateTo == '/Step5'
            ? _weight
            : userProvider.user!.initialWeight,
        'waist': _waist,
      }, SetOptions(merge: true)) // Using merge to preserve other fields
          .then((_) async {
        print("Features saved successfully!");
        if (widget.navigateTo == '/Step5') {
          Navigator.pushNamed(context, '/Step5', arguments: {
            'bmi': (_weight / (_height * _height)).toStringAsFixed(2),
            'calories': widget.diet.values
                .expand((element) => element)
                .map((e) => e['calories'])
                .reduce((value, element) => value + element)
                .toString(),
            // 'calories': "",
          });
          return;
        }

        models.User userData = userProvider.user!;

        userProvider.setUser(models.User(
          uid: userData.uid,
          firstName: userData.firstName,
          lastName: userData.lastName,
          email: userData.email,
          phone: userData.phone,
          goal: userData.goal,
          activityLevel: userData.activityLevel,
          age: _age,
          height: _height,
          waist: _waist,
          initialWeight: userData.initialWeight,
          weight: _weight,
          gender: gender == 0 ? "Male" : "Female",
          image: '',
          dailyDiet: userData.dailyDiet,
        ));

        Navigator.pushReplacementNamed(context, widget.navigateTo);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save features. Please try again.')),
        );
        print("Error saving features: ${error.code} - ${error.message}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150), // Custom height for the AppBar
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, left: 10, right: 10, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        iconSize: 48.0,
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                      ),
                      Expanded(
                        child: Text(
                          widget.navigateTo == '/Step5'
                              ? "What’s Your BMI?"
                              : "Update your Info",
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "We need your${widget.navigateTo == '/Step5' ? " sex," : ""} current age, height and weight to accurately calculate your BMI and calorie needs.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.navigateTo == '/Step5'
                    ? ToggleSwitch(
                        minWidth: (MediaQuery.of(context).size.width - 60) / 2,
                        minHeight: 54.0,
                        cornerRadius: 15.0,
                        customTextStyles: [TextStyle(fontSize: 16)],
                        activeBgColors: [
                          [Colors.green[800]!],
                          [Colors.green[800]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: const Color.fromARGB(111, 52, 121, 40),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: gender,
                        totalSwitches: 2,
                        labels: const ['Male', 'Female'],
                        radiusStyle: true,
                        onToggle: (index) {
                          setState(() {
                            gender = index!;
                          });
                        },
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                BMI_Parameters(
                  data: UserData(
                    age: _age,
                    height: _height,
                    weight: _weight,
                    waist: _waist,
                  ),
                  setAge: _updateAge,
                  setHeight: _updateHeight,
                  setWeight: _updateWeight,
                  setWaist: _updateWaist,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _saveFeatures();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF347928),
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(widget.navigateTo == '/Step5' ? "Next" : "Save",
                  style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
