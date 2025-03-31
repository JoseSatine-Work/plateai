import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app/Models/daily_diet.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:flutter_application_1/services/core_ml.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key, this.navigateTo = '/Step3'});

  final String navigateTo;

  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  List<dynamic> data = [];

  Map<String, List<dynamic>> food = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': [],
  };

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/list.json').then((value) {
      data = jsonDecode(value) as List<dynamic>;
      setState(() {
        data = data;
      });
    });
  }

  void _saveGoal() {
    User? user = FirebaseAuth.instance.currentUser;

    Map<dynamic, dynamic> diet = (food.map((mealType, mealItems) {
      return MapEntry(
          mealType,
          mealItems
              .map((item) {
                dynamic itemData = data.firstWhere(
                    (element) => element['name'] == item,
                    orElse: () => null);
                return itemData;
              })
              .where((element) => element != null)
              .toList());
    }));
    if (user != null) {
      print(diet);
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailyDiet')
          .doc(DateTime.now()
              .toLocal()
              .toString()
              .split(' ')[0]) // Use local date without time
          .set({
        'diet': jsonEncode(diet),
        // 'diet': jsonEncode(food.map((value) {
        //   return value.map((item) {
        //     dynamic itemData = data.firstWhere(
        //         (element) => element['name'] == item,
        //         orElse: () => null);
        //     // return {
        //     //   'name': itemData['name'],
        //     //   'calories': itemData['calories']
        //     // };
        //     return itemData;
        //   }).toList();
        // })),
      }, SetOptions(merge: true)) // Using merge to preserve other fields
          .then((_) {
        print("Diet saved successfully!");

        if (widget.navigateTo == '/Step3') {
          Navigator.pushNamed(context, widget.navigateTo, arguments: {
            'diet': diet,
          });
          return;
        }

        final _user = Provider.of<UserProvider>(context, listen: false);

        _user.setUser(models.User(
          uid: _user.user!.uid,
          firstName: _user.user!.firstName,
          lastName: _user.user!.lastName,
          email: _user.user!.email,
          phone: _user.user!.phone,
          goal: _user.user!.goal,
          activityLevel: _user.user!.activityLevel,
          age: _user.user!.age,
          height: _user.user!.height,
          weight: _user.user!.weight,
          initialWeight: _user.user!.initialWeight,
          gender: _user.user!.gender,
          image: _user.user!.image,
          waist: _user.user!.waist,
          dailyDiet: DailyDiet(
            id: DateTime.now().toLocal().toString().split(' ')[0],
            userId: _user.user!.uid,
            date: DateTime.now().toLocal().toString().split(' ')[0],
            meals: food.map((mealType, mealItems) {
              return MapEntry(
                  mealType,
                  mealItems
                      .map((item) {
                        return data.firstWhere(
                            (element) => element['name'] == item,
                            orElse: () => null);
                      })
                      .where((element) => element != null)
                      .toList());
            }),
          ),
        ));

        Navigator.pushNamed(context, widget.navigateTo);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save diet. Please try again.')),
        );
        // print("Error saving diet: ${error.code} - ${error.message}");
      });
    }
  }

  SingleSelectController timeController = SingleSelectController("Select...");
  SingleSelectController foodController = SingleSelectController("Add Food");

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
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Daily Diet Plan",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
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
            CustomDropdown(
              controller: timeController,
              items: ["Select...", "Breakfast", "Lunch", "Dinner"],
              onChanged: (value) {
                setState(() {});
              },
              decoration: CustomDropdownDecoration(
                closedFillColor: Color(0xFF347928),
                expandedFillColor: Color(0xFF347928),
                listItemStyle: TextStyle(color: Colors.white, fontSize: 16),
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                headerStyle: TextStyle(color: Colors.white, fontSize: 18),
                closedSuffixIcon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white),
                expandedSuffixIcon:
                    Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white),
              ),
              hintText: "Select...",
            ),
            SizedBox(height: 20),
            CustomDropdown.search(
              items: [
                "Add Food",
                ...(data.map((item) {
                  return item['name'] as String;
                }).toList())
              ],
              onChanged: (value) {
                setState(() {
                  if (value != "Add Food") {
                    food[timeController.value]!.add(value);
                  }
                });
              },
              // enabled: timeController.value != "Select...",
              decoration: CustomDropdownDecoration(
                searchFieldDecoration: SearchFieldDecoration(
                  hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                closedFillColor: Color(0xFF347928),
                expandedFillColor: Color(0xFF347928),
                listItemStyle: TextStyle(color: Colors.white, fontSize: 16),
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                headerStyle: TextStyle(color: Colors.white, fontSize: 18),
                closedSuffixIcon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white),
                expandedSuffixIcon:
                    Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white),
              ),
              hintText: "Add Food",
              headerBuilder: (context, selectedItem, enabled) {
                return Text(
                  "Add Food",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...food.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...entry.value.map((item) {
                              dynamic itemData = data.firstWhere(
                                  (element) => element['name'] == item,
                                  orElse: () => null);
                              if (itemData == null) return SizedBox.shrink();
                              return GestureDetector(
                                onDoubleTap: () {
                                  setState(() {
                                    food[entry.key]!.remove(item);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        itemData['name'],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${itemData['calories']} kcal",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 10),
                            entry.key == 'Dinner'
                                ? SizedBox.shrink()
                                : Divider(),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Double tap to remove item',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveGoal,
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
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);

                    if (image == null) return;

                    try {
                      final dynamic prediction =
                          await CoreMlService.predictImage(image.path);
                      if (prediction == null) {
                        return;
                      }
                      // Extract class name and confidence score
                      final className = prediction['className'];
                      final confidenceScore = prediction['confidenceScore'];

                      print('Predicted Class: $className');
                      print('Confidence Score: $confidenceScore');

                      // Load list.json
                      final listJson =
                          await rootBundle.loadString('assets/list.json');
                      final data = jsonDecode(listJson);

                      // Find the matching data
                      final matchingData = data.firstWhere(
                        (item) =>
                            item['name']
                                .toString()
                                .toLowerCase()
                                .replaceAll(' ', '_') ==
                            className,
                        orElse: () => null,
                      );

                      if (matchingData != null) {
                        String name = matchingData['name'];

                        if (timeController.value == "Select...") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please select a meal time before adding food.'),
                            ),
                          );
                          return;
                        }

                        // if (food[timeController.value]!.contains(name)) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //           'This food item is already added to the list.'),
                        //     ),
                        //   );
                        //   return;
                        // }

                        setState(() {
                          food[timeController.value]!.add(name);
                        });
                        return matchingData;
                      } else {
                        print('No matching data found');
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF347928),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // child: Text("Next", style: TextStyle(fontSize: 20)),
                  icon: Icon(Icons.camera_rounded),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
