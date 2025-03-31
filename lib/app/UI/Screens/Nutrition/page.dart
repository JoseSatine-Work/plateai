import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Models/daily_diet.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;

class Nutrition extends StatefulWidget {
  const Nutrition({super.key});

  @override
  _NutritionState createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  int _check = 0; // 0 for Male, 1 for Female

  Map<String, double>? calories;
  Map<String, double>? caloriesPercentage;
  int totalCalories = 0;
  List<Map<String, dynamic>> macros = [];
  Map<String, double>? dataMapMacros;

  double round(double value) {
    return double.parse(value.toStringAsFixed(2)); // Keeps two decimal places
  }

  Future<void> getData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final models.User? user = userProvider.user;

    DailyDiet? diet = user!.dailyDiet;

    if (diet == null) {
      return;
    }

    calories = Map.fromEntries(diet.meals.keys.map((key) {
      return MapEntry(
          key,
          diet.meals[key]!.fold(0, (sum, item) {
            return sum + (item['calories'] as int);
          }));
    }));

    totalCalories =
        calories!.values.fold(0, (sum, value) => sum + (value.toInt()));

    caloriesPercentage = Map.fromEntries(calories!.keys.map((key) {
      return MapEntry(
          key, round((calories![key]! / totalCalories.toDouble()) * 100));
    }));

    dynamic totalNutrientsValue = diet.meals.values
        .expand((_) => _)
        .map((e) => e['dailyValue'])
        .fold({}, (prev, element) {
      element.forEach((key, value) {
        if (prev.containsKey(key)) {
          prev[key] = prev[key] +
              double.parse(double.parse(((value ?? "0.0") as String)
                      .split(' ')[0]
                      .replaceAll('m', '')
                      .replaceAll('c', '')
                      .replaceAll('g', ''))
                  .toStringAsFixed(2));
        } else {
          prev[key] = double.parse(double.parse(((value ?? "0.0") as String)
                  .split(' ')[0]
                  .replaceAll('m', '')
                  .replaceAll('c', '')
                  .replaceAll('g', ''))
              .toStringAsFixed(2));
        }
      });
      return prev;
    });

    double requiredNutrientsTotal = totalNutrientsValue['totalCarbohydrates'] +
        totalNutrientsValue['totalFat'] +
        totalNutrientsValue['protein'] +
        totalNutrientsValue['dietaryFiber'];

    requiredNutrientsTotal =
        double.parse(requiredNutrientsTotal.toStringAsFixed(2));

    // print(requiredNutrientsTotal);

    // print(diet.meals.values.expand((e) => e).map((item) => item['dailyValue']
    //         ['totalCarbohydrates']
    //     .split(' ')[0]
    //     .replaceAll('g', '')));

    macros = [
      {
        "name": "Carbohydrates",
        "value":
            "${diet.meals.values.expand((e) => e).map((item) => (item['dailyValue']['totalCarbohydrates'] ?? "0.0").split(' ')[0].replaceAll('g', '')).fold<double>(0, (sum, value) => sum + double.parse((value as String).split(' ')[0].replaceAll('g', '')))}g",
        "total": (diet.meals.values
                    .expand((e) => e)
                    .map((item) =>
                        (item['dailyValue']['totalCarbohydrates'] ?? "0.0")
                            .split(' ')[0]
                            .replaceAll('g', ''))
                    .fold(
                        0.0,
                        (sum, value) =>
                            sum +
                            double.parse((value as String)
                                .split(' ')[0]
                                .replaceAll('g', ''))) /
                requiredNutrientsTotal) *
            100,
        "goal": "30%",
        "color": Colors.green.shade700
      },
      {
        "name": "Fat",
        "value":
            "${diet.meals.values.expand((e) => e).map((item) => (item['dailyValue']['totalFat'] ?? "0.0")).fold(0.0, (sum, value) => sum + double.parse((value as String).split(' ')[0].replaceAll('g', '')))}g",
        "total": (diet.meals.values
                    .expand((e) => e)
                    .map((item) => (item['dailyValue']['totalFat'] ?? "0.0"))
                    .fold(
                        0.0,
                        (sum, value) =>
                            sum +
                            double.parse((value as String)
                                .split(' ')[0]
                                .replaceAll('g', ''))) /
                requiredNutrientsTotal) *
            100,
        "goal": "20%",
        "color": Colors.green.shade400
      },
      {
        "name": "Protein",
        "value":
            "${diet.meals.values.expand((e) => e).map((item) => (item['dailyValue']['totalFat'] ?? "0.0")).fold(0.0, (sum, value) => sum + double.parse((value as String).split(' ')[0].replaceAll('g', '')))}g",
        "total": diet.meals.values
            .expand((e) => e)
            .map((e) => double.parse(
                (e['dailyValue']['protein'] ?? "0.0").replaceAll('g', '')))
            .fold<double>(0.0, (sum, value) => sum + value),
        "goal": "20%",
        "color": Colors.green.shade200
      },
      {
        "name": "Fiber",
        "value":
            "${diet.meals.values.expand((e) => e).map((e) => double.parse((e['dailyValue']['dietaryFiber'] ?? "0.0").split(' ')[0].replaceAll('g', ''))).fold<double>(0, (sum, value) => sum + value)}g",
        "total": diet.meals.values
            .expand((e) => e)
            .map((e) => double.parse((e['dailyValue']['dietaryFiber'] ?? "0.0")
                .split(' ')[0]
                .replaceAll('g', '')))
            .fold<double>(0, (sum, value) => sum + value),
        "goal": "20%",
        "color": Colors.green.shade200
      }
    ];

    print(macros);

    dataMapMacros = {
      "Carbohydrates": double.parse(macros[0]['value'].replaceAll('g', '')),
      "Fat": double.parse(macros[1]['value'].replaceAll('g', '')),
      "Protein": double.parse(macros[2]['value'].replaceAll('g', '')),
      "Fiber": double.parse(macros[3]['value'].replaceAll('g', '')),
    };

    print(dataMapMacros);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // Colors for the pie chart
    final List<Color> colorList = [
      Colors.green.shade700,
      Colors.green.shade300,
      Colors.green.shade100,
      Colors.green.shade200,
    ];

    // final Map<String, double> dataMap_macros = {
    //   "Carbohydrates": 91,
    //   "Fat": 5,
    //   "Protein": 4,
    // };

    // Macronutrient data
    // final List<Map<String, dynamic>> macros = [
    //   {
    //     "name": "Carbohydrates",
    //     "value": "11g",
    //     "total": "91%",
    //     "goal": "50%",
    //     "color": Colors.green.shade700
    //   },
    //   {
    //     "name": "Fat",
    //     "value": "1g",
    //     "total": "5%",
    //     "goal": "30%",
    //     "color": Colors.green.shade400
    //   },
    //   {
    //     "name": "Protein",
    //     "value": "1g",
    //     "total": "4%",
    //     "goal": "20%",
    //     "color": Colors.green.shade200
    //   },
    // ];

    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleSwitch(
                  minWidth: (MediaQuery.of(context).size.width / 2) - 36,
                  minHeight: 50.0,
                  cornerRadius: 15.0,
                  activeBgColors: [
                    [Colors.green[800]!],
                    [Colors.green[800]!]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Color.fromARGB(111, 52, 121, 40),
                  inactiveFgColor: Colors.white,
                  initialLabelIndex:
                      _check, // Set initial label index based on _check
                  totalSwitches: 2,
                  labels: ['Calories', 'Macros'],
                  radiusStyle: true,
                  onToggle: (index) {
                    print('switched to: $index');
                    getData();
                    setState(() {
                      _check = index!; // Update _check and call setState
                    });
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: _check == 0
                      ? Center(
                          child: Card(
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Pie Chart
                                  PieChart(
                                    dataMap: calories!,
                                    animationDuration:
                                        const Duration(milliseconds: 800),
                                    chartLegendSpacing: 32,
                                    chartRadius:
                                        MediaQuery.of(context).size.width * 0.4,
                                    colorList: colorList,
                                    initialAngleInDegree: 0,
                                    // chartType: ChartType.ring,
                                    ringStrokeWidth: 16,
                                    legendOptions: const LegendOptions(
                                      showLegends: false,
                                    ),
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: false,
                                      decimalPlaces: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Grid-like layout for items
                                  GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 3,
                                    children: [
                                      _buildGridItem(
                                          "Breakfast",
                                          "${caloriesPercentage!['Breakfast'] ?? 0.0}%",
                                          "${calories!['Breakfast']} Cal",
                                          Colors.green.shade700),
                                      _buildGridItem(
                                          "Lunch",
                                          "${caloriesPercentage!['Lunch'] ?? 0.0}%",
                                          "${calories!['Lunch']} Cal",
                                          Colors.green.shade300),
                                      _buildGridItem(
                                          "Dinner",
                                          "${caloriesPercentage!['Dinner'] ?? 0.0}%",
                                          "${calories!['Dinner']} Cal",
                                          Colors.green.shade100),
                                      // _buildGridItem(
                                      //     "Snacks",
                                      //     "${dataMap_percentage['Snacks']}%",
                                      //     "${dataMap_calories['Snacks']} Cal",
                                      //     Colors.green.shade200),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Footer details
                                  const Divider(thickness: 1),
                                  _buildFooterRow(
                                      "Total Calories", "${totalCalories}"),
                                  const Divider(thickness: 1),
                                  _buildFooterRow("Goal", "$totalCalories",
                                      color: Colors.green),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Card(
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Pie Chart
                                  PieChart(
                                    dataMap: dataMapMacros!,
                                    animationDuration:
                                        const Duration(milliseconds: 800),
                                    chartLegendSpacing: 32,
                                    chartRadius:
                                        MediaQuery.of(context).size.width * 0.4,
                                    colorList: colorList,
                                    initialAngleInDegree: 0,
                                    // chartType: ChartType.ring,
                                    ringStrokeWidth: 16,
                                    legendOptions: const LegendOptions(
                                      showLegends: false,
                                    ),
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                      showChartValues: false,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Macronutrient List
                                  Column(
                                    children: macros.map((macro) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            // Macro Color Indicator
                                            Container(
                                              width: 16,
                                              height: 16,
                                              color: macro["color"],
                                            ),
                                            const SizedBox(width: 8),
                                            // Macro Name and Value
                                            Expanded(
                                              child: Text(
                                                "${macro['name']} (${macro['value']})",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            // Macro Total
                                            Text(
                                              (macro["total"] as double)
                                                  .toStringAsFixed(2),
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(width: 16),
                                            // Macro Goal
                                            Text(
                                              macro["goal"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

// Helper method to build grid items
Widget _buildGridItem(
    String title, String percentage, String calories, Color color) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        color: color,
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text("$percentage ($calories)", style: const TextStyle(fontSize: 10)),
        ],
      ),
    ],
  );
}

// Helper method to build footer rows
Widget _buildFooterRow(String title, String value,
    {Color color = Colors.black}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Text(
          value,
          style: TextStyle(
              fontSize: 14, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
