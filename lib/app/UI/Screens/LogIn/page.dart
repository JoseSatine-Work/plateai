import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Models/daily_diet.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:provider/provider.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isChecked = false;
  bool _isObscured = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String email = "";
  String password = "";

  models.User? _user;

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The sign in request was canceled by the user before completion.
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
      final Map<String, dynamic> userDataMap = userData.data()!;

      final DocumentSnapshot<Map<String, dynamic>> profileData =
          await FirebaseFirestore.instance
              .collection('db')
              .doc(userCredential.user!.uid)
              .get();
      final Map<String, dynamic> profileDataMap = profileData.data()!;

      final DocumentSnapshot<Map<String, dynamic>> dailyDietSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
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
              userId: userCredential.user!.uid,
              date: DateTime.now().toLocal().toString().split(' ')[0],
              meals: Map<String, List<dynamic>>.from(
                  jsonDecode(dailyDietSnapshot.data()!['diet'])),
            );

      setState(() {
        _user = models.User(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            firstName: userCredential.user!.displayName!.split(' ')[0],
            lastName: userCredential.user!.displayName!.split(' ')[1],
            phone: profileDataMap['phoneNumber'],
            goal: userDataMap['goal'],
            activityLevel: userDataMap['activityLevel'],
            age: userDataMap['age'],
            height: userDataMap['height'],
            weight: userDataMap['weight'],
            gender: userDataMap['gender'],
            initialWeight: userDataMap['initialWeight'],
            waist: userDataMap['waist'],
            image: userDataMap['image'] ?? '',
            dailyDiet: dailyDiet);
      });

      if (dailyDiet == null) {
        Navigator.of(context).pushNamed('/Step2', arguments: {
          'navigateTo': '/Dashboard',
        });
        return;
      }

      print('User signed in with Google: ${userCredential.user?.displayName}');
    } catch (error) {
      print('Google sign-in failed: $error');
    }
  }

  Future<void> _signInWithEmailAndPassword(
      String email, String password) async {
    print('Email: $email, Password: $password');
    if (email.isEmpty || password.isEmpty) {
      print('Email and password cannot be empty.');
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed in: ${userCredential.user?.email}');

      final DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
      final Map<String, dynamic> userDataMap = userData.data()!;

      final DocumentSnapshot<Map<String, dynamic>> profileData =
          await FirebaseFirestore.instance
              .collection('db')
              .doc(userCredential.user!.uid)
              .get();
      final Map<String, dynamic> profileDataMap = profileData.data()!;

      final DocumentSnapshot<Map<String, dynamic>> dailyDietSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .collection('dailyDiet')
              .doc(DateTime.now().toLocal().toString().split(' ')[0])
              // .orderBy('date', descending: true)
              // .limit(1)
              .get();

      DailyDiet? dailyDiet = dailyDietSnapshot.data() == null
          ? null
          : DailyDiet(
              id: dailyDietSnapshot.id,
              userId: userCredential.user!.uid,
              date: DateTime.now().toLocal().toString().split(' ')[0],
              meals: Map<String, List<dynamic>>.from(
                  jsonDecode(dailyDietSnapshot.data()!['diet'])),
            );

      // return;

      print(userDataMap);

      setState(() {
        _user = models.User(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          firstName: userCredential.user!.displayName!.split(' ')[0],
          lastName: userCredential.user!.displayName!.split(' ')[1],
          phone: profileDataMap['phoneNumber'].toString(),
          goal: userDataMap['goal'],
          activityLevel: userDataMap['activityLevel'],
          age: userDataMap['age'],
          height: userDataMap['height'],
          weight: userDataMap['weight'],
          gender: userDataMap['gender'],
          initialWeight: userDataMap['initialWeight'],
          waist: userDataMap['waist'],
          image: userDataMap['image'] ?? '',
          dailyDiet: dailyDiet,
        );
      });

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
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/icon.png',
                height: 96,
                width: 96,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      email = text;
                      print('Text entered: $text');
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscured,
                    onChanged: (text) {
                      password = text;
                      print('Text entered: $password');
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade500,
                          width: 2,
                        ),
                      ),
                      const Text("Remember Information"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Provide appropriate email and password values

                        await _signInWithEmailAndPassword(email, password);
                        userProvider.setUser(_user!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF347928),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(350, 50),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Log In", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(color: Color(0xFF347928), fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("or"),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _handleGoogleSignIn();
                        userProvider.setUser(_user!);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(350, 50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/google_logo.png',
                            height: 32,
                            width: 32,
                          ),
                          const SizedBox(width: 16),
                          Container(
                            height: 24,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Login with Google',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/SignUp');
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Color(0xFF347928)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
