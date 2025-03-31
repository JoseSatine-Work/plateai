import 'dart:convert';

import 'package:flutter_application_1/app/Models/daily_diet.dart';

class User {
  String uid;
  String firstName;
  String lastName;
  String email;
  String phone;
  int goal;
  double activityLevel;
  double age;
  double height;
  double weight;
  double? initialWeight;
  double waist;
  String gender;
  String image;

  DailyDiet? dailyDiet;

  // String dietStr;

  // // get diet in json encoded string and convert it to json
  // Map<String, dynamic> get diet => jsonDecode(dietStr);

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.goal,
    required this.activityLevel,
    required this.age,
    required this.height,
    required this.waist,
    required this.initialWeight,
    required this.weight,
    required this.gender,
    this.dailyDiet,
    required this.image,
  });
}
