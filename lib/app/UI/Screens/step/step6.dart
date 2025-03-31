import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Models/daily_diet.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Step6 extends StatefulWidget {
  const Step6({super.key, required this.calories});

  final String calories;

  @override
  State<Step6> createState() => _Step6State();
}

class _Step6State extends State<Step6> {
  final User? user = FirebaseAuth.instance.currentUser;
  models.User? _user;

  Future<void> getUserData() async {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
      final Map<String, dynamic> userDataMap = userData.data()!;

      final DocumentSnapshot<Map<String, dynamic>> profileData =
          await FirebaseFirestore.instance
              .collection('db')
              .doc(user!.uid)
              .get();
      final Map<String, dynamic> profileDataMap = profileData.data()!;

      final DocumentSnapshot<Map<String, dynamic>> dailyDietSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('dailyDiet')
              .doc(DateTime.now().toLocal().toString().split(' ')[0])
              // .orderBy('date', descending: true)
              // .limit(1)
              .get();

      print(dailyDietSnapshot.data());

      DailyDiet? dailyDiet = dailyDietSnapshot.data()!.isEmpty
          ? null
          : DailyDiet(
              id: dailyDietSnapshot.id,
              userId: user!.uid,
              date: DateTime.now().toLocal().toString().split(' ')[0],
              meals: Map<String, List<dynamic>>.from(
                  jsonDecode(dailyDietSnapshot.data()!['diet'])),
            );

      // return;

      setState(() {
        _user = models.User(
          uid: user!.uid,
          email: user!.email!,
          firstName: user!.displayName!.split(' ')[0],
          lastName: user!.displayName!.split(' ')[1],
          phone: profileDataMap['phoneNumber'].toString(),
          goal: userDataMap['goal'],
          activityLevel: userDataMap['activityLevel'],
          age: userDataMap['age'],
          height: userDataMap['height'],
          weight: userDataMap['weight'] ?? 0.0,
          gender: userDataMap['gender'],
          initialWeight: userDataMap['initialWeight'],
          waist: userDataMap['waist'],
          dailyDiet: dailyDiet,
          image: '',
        );
      });

      if (_user == null) {
        Navigator.of(context).pushNamed('/Step1');
        return;
      }

      _userProvider.setUser(_user!);

      if (dailyDiet == null) {
        Navigator.of(context).pushNamed('/Step2', arguments: {
          'navigateTo': '/Dashboard',
        });
        return;
      }

      print(_user);
      Navigator.pushNamed(context, '/Dashboard');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          iconSize: 30.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Account Created",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/Success_check.png'),
                  SizedBox(height: 20),
                  const Text(
                    'Successfully!!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Your daily net goal is:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // '2,240',
                        widget.calories,
                        style: TextStyle(
                            color: Color(0xFF347928),
                            fontSize: 45,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF347928),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          'Calories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              getUserData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF347928),
              foregroundColor: Colors.white,
              minimumSize: const Size(250, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Go to Dashboard", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
