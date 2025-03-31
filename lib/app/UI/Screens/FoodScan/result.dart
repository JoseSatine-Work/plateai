import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Models/daily_diet.dart';
import 'package:flutter_application_1/app/Models/item.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;
import 'package:flutter_application_1/app/utils/file_utils.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:flutter_application_1/services/item_repository.dart';
import 'package:provider/provider.dart';
import '../../Components/nutritionAnalysis.dart';

class Result extends StatefulWidget {
  const Result({
    super.key,
    required this.imagePath,
    required this.nutrition,
  });

  final String imagePath;
  final Map<String, dynamic> nutrition;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool isLoading = true;

  bool inDiet = false;
  bool isEaten = false;

  final ItemRepository _repository = ItemRepository();

  @override
  void initState() {
    super.initState();
    _addItem(File(widget.imagePath), widget.nutrition);
    checkDiet();
  }

  Future<void> _addItem(File imageFile, Map<String, dynamic> data) async {
    final imagePath = await FileUtils.saveImage(imageFile);
    final newItem = Item(imagePath: imagePath, data: data);
    await _repository.insertItem(newItem);
  }

  Future<void> checkDiet() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final DailyDiet? diet = userProvider.user!.dailyDiet;

    if (diet != null) {
      inDiet = diet.meals.values
          .expand((e) => e)
          .map((item) => item['name'])
          .contains(widget.nutrition['name']);

      setState(() {});
    }
  }

  Future<void> markAsEaten() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final DailyDiet? diet = userProvider.user!.dailyDiet;

    if (diet != null) {
      for (var time in diet.meals.keys) {
        for (var item in diet.meals[time]!) {
          if (item['name'] == widget.nutrition['name']) {
            item['eaten'] = true;
            break;
          }
        }
      }

      userProvider.setUser(models.User(
        uid: userProvider.user!.uid,
        email: userProvider.user!.email,
        firstName: userProvider.user!.firstName,
        lastName: userProvider.user!.lastName,
        phone: userProvider.user!.phone,
        activityLevel: userProvider.user!.activityLevel,
        age: userProvider.user!.age,
        goal: userProvider.user!.goal,
        height: userProvider.user!.height,
        weight: userProvider.user!.weight,
        gender: userProvider.user!.gender,
        initialWeight: userProvider.user!.initialWeight,
        waist: userProvider.user!.waist,
        image: userProvider.user!.image,
        dailyDiet: diet,
      ));

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      firestore
          .collection('users')
          .doc(userProvider.user!.uid)
          .collection('dailyDiet')
          .doc(DateTime.now()
              .toLocal()
              .toString()
              .split(' ')[0]) // Use local date without time
          .set({
        'diet': jsonEncode(diet.meals),
      }, SetOptions(merge: true)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved')),
        );
        print("Diet saved successfully!");
        setState(() {
          isEaten = true;
        });
      }).catchError((error) {
        print("Error saving diet: ${error.code} - ${error.message}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Nutrition",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.imagePath),
                          height: screenSize.height * 0.3,
                          width: screenSize.width * 0.9,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              nutritionAnalysis(nutrition: widget.nutrition),
              const SizedBox(height: 20),
              inDiet
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('This food item is\nin your today\'s diet.'),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF347928),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isEaten ? null : markAsEaten,
                            child: Text('Mark as Eaten'),
                          )
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
