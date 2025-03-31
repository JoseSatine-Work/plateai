import 'package:flutter/material.dart';

class nutritionAnalysis extends StatefulWidget {
  const nutritionAnalysis({super.key, required this.nutrition});
  final Map<String, dynamic> nutrition;

  @override
  State<nutritionAnalysis> createState() => _nutritionAnalysisState();
}

class _nutritionAnalysisState extends State<nutritionAnalysis> {
  double calories = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.nutrition);
    getServingSizeCalories();
  }

  void getServingSizeCalories() {
    String servingSize = widget.nutrition['servingSize'];
    int start = servingSize.lastIndexOf('(');
    int end = servingSize.lastIndexOf(')');
    calories =
        double.parse(servingSize.substring(start + 1, end).replaceAll('g', ''));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Incorrect parameter
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nutrition['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Nutrition Value : ${widget.nutrition['calories']}kcal",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )),
          SizedBox(height: 8),
          Center(
            child: SizedBox(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 200,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(33, 52, 121, 40),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Container(
                            height: 200 *
                                double.parse(((widget.nutrition['dailyValue']
                                            ['protein'] ??
                                        "0.0") as String)
                                    .replaceAll('g', ' ')) /
                                calories,
                            width: 70,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(113, 52, 121, 40),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Protein",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${((double.parse(((widget.nutrition['dailyValue']['protein'] ?? "0.0") as String).replaceAll('g', ' ')) / calories) * 100).toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 200,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(33, 52, 121, 40),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Container(
                            height: 200 *
                                ((double.parse((((widget.nutrition['dailyValue']
                                                    ['totalFat'] ??
                                                "0.0") as String)
                                            .split(' ')[0]
                                            .replaceAll('g', ''))) as num) /
                                        calories)
                                    .toDouble(),
                            width: 70,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(113, 52, 121, 40),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Fat",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(((double.parse((((widget.nutrition['dailyValue']['totalFat'] ?? "0.0") as String).split(' ')[0].replaceAll('g', ''))) as num) / calories) * 100).toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 200,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(33, 52, 121, 40),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Container(
                            height: 200 *
                                ((double.parse(((widget.nutrition['dailyValue']
                                                    ['totalCarbohydrates'] ??
                                                "0.0") as String)
                                            .split(' ')[0]
                                            .replaceAll('g', '')) as num) /
                                        calories)
                                    .toDouble(),
                            width: 70,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(113, 52, 121, 40),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Carbs",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(((double.parse(((widget.nutrition['dailyValue']['totalCarbohydrates'] ?? "0.0") as String).split(' ')[0].replaceAll('g', '')) as num) / calories) * 100).toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 200,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(33, 52, 121, 40),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Container(
                            height: 200 *
                                ((double.parse(((widget.nutrition['dailyValue']
                                                    ['dietaryFiber'] ??
                                                '0g') as String)
                                            .split(' ')[0]
                                            .replaceAll('g', ' '))) /
                                        calories)
                                    .toDouble(),
                            width: 70,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(113, 52, 121, 40),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Fiber",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(((double.parse(((widget.nutrition['dailyValue']['dietaryFiber'] ?? "0.0") as String).split(' ')[0].replaceAll('g', ' '))) / calories) * 100).toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
