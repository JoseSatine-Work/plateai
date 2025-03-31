import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app/UI/Components/today_stats_card.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:flutter_application_1/services/core_ml.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../Components/dailyMacros.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class UserData {
  final String gender;
  final double waist;
  final double weight;
  final double height;
  final double age;
  final double activityLevel;
  final int goal;

  UserData({
    required this.gender,
    required this.waist,
    required this.weight,
    required this.height,
    required this.age,
    required this.activityLevel,
    required this.goal,
  });
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  static const defaultNutrition = {
    "nutrition": {"fat": 49, "carbs": 80, "protein": 80, "fiber": 80},
    "goal": {"fat": 49, "carbs": 80, "protein": 80, "fiber": 80},
  };

  final Map<String, dynamic> nutrition = defaultNutrition;

  // static const double STARTING_WEIGHT = 105.0;
  double currentWeight = 55.0;
  late final double progressValue;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // UserData? userData;
  String bbScore = "0";
  String hwrScore = "0";
  String wthScore = "0";
  String activityScore = "0";
  String dietScore = "0";
  int calories = 0;
  double initalWeight = 0.0;
  double targetWeight = 0.0;
  double targetRange = 30;
  double initialRange = 90;
  dynamic loggedCalories = 0.0;
  dynamic totalCalories = 0.0;
  Map<String, dynamic> nutritions = {
    "fat": 0,
    "carbs": 0,
    "protein": 0,
    "fiber": 0,
  };

  @override
  void initState() {
    super.initState();
    getPermissions();
    try {
      progressValue =
          (initalWeight - currentWeight) / (initalWeight - targetWeight).abs();
    } catch (e) {
      progressValue = 0.0;
      debugPrint('Error calculating progress: $e');
    }
  }

  Future<void> getPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();
    final photosPermission = await Permission.photos.request();
    final storagePermission = await Permission.storage.request();

    if (!cameraPermission.isGranted ||
        !microphonePermission.isGranted ||
        !photosPermission.isGranted ||
        !storagePermission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "The app might not work as expected without camera and microphone permissions."),
        ),
      );
    }
  }

  Future<dynamic> _predict(String imagePath) async {
    try {
      final dynamic prediction = await CoreMlService.predictImage(imagePath);
      if (prediction == null) {
        return;
      }
      // Extract class name and confidence score
      final className = prediction['className'];
      final confidenceScore = prediction['confidenceScore'];

      print('Predicted Class: $className');
      print('Confidence Score: $confidenceScore');

      // Load list.json
      final listJson = await rootBundle.loadString('assets/list.json');
      final data = jsonDecode(listJson);

      // Find the matching data
      final matchingData = data.firstWhere(
        (item) =>
            item['name'].toString().toLowerCase().replaceAll(' ', '_') ==
            className,
        orElse: () => null,
      );

      if (matchingData != null) {
        print('Matching Data: $matchingData');
        return matchingData;
      } else {
        print('No matching data found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getUserData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final userProvider = context.watch<UserProvider>();

    final userData = userProvider.user!;

    calories = userData.dailyDiet!.meals.values
        .expand((element) => element)
        .map((e) => e['calories'])
        .reduce((value, element) => value + element);

    nutritions = {
      "current": {
        "fat": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .where((e) => e['eaten'] == true)
            .map(
              (e) => double.parse((e['dailyValue']['totalFat'] ?? "0.0")
                  .split(' ')[0]
                  .replaceAll('g', '')),
            )
            .fold(0.0, (value, element) => value + element),
        "carbs": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .where((e) => e['eaten'] == true)
            .map(
              (e) => double.parse(
                  (e['dailyValue']['totalCarbohydrates'] ?? "0.0")
                      .split(' ')[0]
                      .replaceAll('g', '')),
            )
            .fold(0.0, (value, element) => value + element),
        "protein": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .where((e) => e['eaten'] == true)
            .map(
              (e) => double.parse((e['dailyValue']['protein'] ?? "0.0")
                  .split(' ')[0]
                  .replaceAll('g', '')),
            )
            .fold(0.0, (value, element) => value + element),
        "fiber": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .where((e) => e['eaten'] == true)
            .map(
              (e) => double.parse((e['dailyValue']['dietaryFiber'] ?? "0.0")
                  .split(' ')[0]
                  .replaceAll('g', '')),
            )
            .fold(0.0, (value, element) => value + element),
      },
      "goal": {
        "fat": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .map(
              (e) => double.parse((e['dailyValue']['totalFat'] ?? "0.0")
                  .split(' ')[0]
                  .replaceAll('g', '')),
            )
            .reduce((value, element) => value + element),
        "carbs": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .map(
              (e) => double.parse(
                  (e['dailyValue']['totalCarbohydrates'] ?? "0.0")
                      .split(' ')[0]
                      .replaceAll('g', '')),
            )
            .reduce((value, element) => value + element),
        "protein": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .map(
              (e) => double.parse((e['dailyValue']['protein'] ?? "0.0")
                  .split(' ')[0]
                  .replaceAll('g', '')),
            )
            .reduce((value, element) => value + element),
        "fiber": userData.dailyDiet!.meals.values
            .expand((element) => element)
            .map(
              (e) => double.parse((e['dailyValue']['dietaryFiber'] ?? "0.0")
                  .split(' ')[0]
                  .replaceAll('g', '')),
            )
            .reduce((value, element) => value + element),
      }
    };

    initalWeight = userData.initialWeight ?? 0.0;
    currentWeight = userData.weight;
    // targetWeight = userData.goal == 0 ? initalWeight - 5 : initalWeight + 5;
    targetWeight = double.parse((initalWeight * .75).toStringAsFixed(1));
    // progressValue =
    //     (initalWeight - currentWeight) / (initalWeight - TARGET_WEIGHT).abs();

    // print(nutritions);

    // waist / height was provided but i think that formula is wrong
    double hwr = (userData.waist / (userData.height * 100));
    double wth = (userData.weight / userData.height);

    hwrScore = max(0, (100 - ((hwr - 0.5) * 200)).abs()).toStringAsFixed(2);
    wthScore = max(0, 100 - (wth - 0.21).abs() * 500).toStringAsFixed(2);

    dynamic _calories = userData.dailyDiet!.meals.values.expand((e) => e);

    loggedCalories = _calories
        .where((e) => e['eaten'] == true)
        .map((e) => e['calories'].toDouble())
        .fold(0.0, (sum, value) => sum + value);
    totalCalories = _calories
        .map((e) => e['calories'].toDouble())
        .fold(0.0, (sum, value) => sum + value);

    dietScore = ((loggedCalories / totalCalories) * 100).toStringAsFixed(2);

    bbScore = ((0.4 * double.parse(hwrScore)) +
            (0.3 * double.parse(wthScore)) +
            (0.2 * userData.activityLevel) +
            (0.1 * double.parse(dietScore)))
        .toStringAsFixed(2);

    name = "${userData.firstName} ${userData.lastName}";

    activityScore = "${userData.activityLevel}";
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    getUserData(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? Scaffold(
            body: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : Scaffold(
            key: ValueKey(userProvider.user),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // backgroundColor: Colors.green,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      // color: Colors.white,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/Profile');
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${name}'s App",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.green,
                      // color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/Setting');
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth > 600 ? 32.0 : 16.0),
                child: Column(
                  children: [
                    TodayStatsCard(
                      calories: (totalCalories - loggedCalories).toInt(),
                      bbScore: bbScore,
                      hwrScore: hwrScore,
                      wthScore: wthScore,
                      activityScore: activityScore,
                      dietScore: dietScore,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Macros",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        DailyMacros(nutrition: nutritions),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/Step4', arguments: {
                          'diet': userProvider.user!.dailyDiet!.meals,
                          'navigateTo': '/Dashboard',
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Progress",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              width: 600,
                              height: 240,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  SizedBox(
                                    width: 240,
                                    child: SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                          startAngle: 180,
                                          endAngle: 0,
                                          minimum: targetRange,
                                          maximum: initialRange,
                                          showTicks: false,
                                          showLabels: false,
                                          showAxisLine: false,
                                          // axisLineStyle: AxisLineStyle(
                                          //   thickness: 20,
                                          //   cornerStyle: CornerStyle.bothFlat,
                                          //   color: Colors.grey[300],
                                          // ),
                                          ranges: <GaugeRange>[
                                            GaugeRange(
                                              startValue: targetRange,
                                              endValue: targetRange +
                                                  (initialRange - targetRange) *
                                                      0.25,
                                              color: Colors.lightGreen.shade400,
                                              startWidth: 16,
                                              endWidth: 16,
                                            ),
                                            GaugeRange(
                                              startValue: targetRange +
                                                  (initialRange - targetRange) *
                                                      0.25,
                                              endValue: targetRange +
                                                  (initialRange - targetRange) *
                                                      0.5,
                                              color: Colors.yellow.shade600,
                                              startWidth: 16,
                                              endWidth: 16,
                                            ),
                                            GaugeRange(
                                              startValue: targetRange +
                                                  (initialRange - targetRange) *
                                                      0.5,
                                              endValue: targetRange +
                                                  (initialRange - targetRange) *
                                                      0.75,
                                              color: Colors.deepOrangeAccent,
                                              startWidth: 16,
                                              endWidth: 16,
                                            ),
                                            GaugeRange(
                                              startValue: targetRange +
                                                  (initialRange - targetRange) *
                                                      0.75,
                                              endValue: initialRange,
                                              color: Colors.red.shade600,
                                              startWidth: 16,
                                              endWidth: 16,
                                            ),
                                          ],
                                          pointers: <GaugePointer>[
                                            NeedlePointer(
                                              value: currentWeight,
                                              needleColor: Colors.grey[300],
                                              knobStyle: KnobStyle(
                                                color: Colors.grey[400],
                                                knobRadius: 0.15,
                                              ),
                                            ),
                                          ],
                                          annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                              widget: Text(
                                                targetRange.toStringAsFixed(1),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              angle: 175,
                                              positionFactor: 1.2,
                                            ),
                                            GaugeAnnotation(
                                              widget: Text(
                                                initialRange.toStringAsFixed(1),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              angle: 5,
                                              positionFactor: 1.2,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 135),
                                      Text(
                                        '${(initalWeight - currentWeight).abs().toStringAsFixed(1)} kg ${currentWeight <= initalWeight ? 'lost' : 'gained'}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Current: ${currentWeight.toStringAsFixed(1)} kg',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text:
                            'Weight Progress is based on your initial weight: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${initalWeight.toStringAsFixed(2)}kg',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        // getUserData();
                        Navigator.pushNamed(context, '/Step1');
                      },
                    ),
                    const SizedBox(width: 60), // Space for the FAB
                    IconButton(
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/ScanFoodListResult');
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                onPressed: () async {
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera, imageQuality: 100);

                  setState(() {
                    isLoading = true;
                  });
                  if (image != null) {
                    dynamic nutrition = await _predict(image.path);

                    if (nutrition != null) {
                      Navigator.pushNamed(context, '/ScanFoodResult',
                          arguments: {
                            'imagePath': image.path,
                            'nutrition': nutrition,
                          });
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                shape: const CircleBorder(),
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }
}

Widget buildScoreRow(String label, String score,
    {FontWeight? fw = FontWeight.w400}) {
  return IntrinsicWidth(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset(iconPath, width: 24, height: 24),
          // const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: fw)),
          const SizedBox(width: 12),
          Text(score,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
