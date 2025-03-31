import 'package:flutter/material.dart';

class DailyMacros extends StatelessWidget {
  const DailyMacros({super.key, required this.nutrition});
  final Map<String, dynamic> nutrition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/Nutrition');
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Incorrect parameter
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                                  ((nutrition['current']['protein'] as num) /
                                          nutrition['goal']['protein'] as num)
                                      .toDouble()
                                      .clamp(0, 1),
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(113, 52, 121, 40),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              height: 200,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Protein",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${nutrition['current']['protein']}g',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(((nutrition['current']['protein'] / nutrition['goal']['protein']) as double) * 100).toStringAsFixed(2)}%',
                                        // "0%",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${(nutrition['goal']['protein'] - nutrition['current']['protein'] as double).toStringAsFixed(1)}g left',
                          // '0.0g left',
                          style: TextStyle(fontSize: 12),
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
                                  ((nutrition['current']['fat'] as num) /
                                          nutrition['goal']['fat'] as num)
                                      .toDouble()
                                      .clamp(0, 1),
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(113, 52, 121, 40),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              height: 200,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Fat",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${nutrition['current']['fat']}g',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(((nutrition['current']['fat'] / nutrition['goal']['fat']) as double) * 100).toStringAsFixed(2)}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${((nutrition['goal']['fat'] - nutrition['current']['fat']) as double).toStringAsFixed(1)}g left',
                          style: TextStyle(fontSize: 12),
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
                                  ((nutrition['current']['carbs'] as num) /
                                          nutrition['goal']['carbs'] as num)
                                      .toDouble()
                                      .clamp(0, 1),
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(113, 52, 121, 40),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              height: 200,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Carbs",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${nutrition['current']['carbs']}g',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(((nutrition['current']['carbs'] / nutrition['goal']['carbs']) as double) * 100).toStringAsFixed(2)}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${((nutrition['goal']['carbs'] - nutrition['current']['carbs']) as double).toStringAsFixed(1)}g left',
                          // '0.0g left',
                          style: TextStyle(fontSize: 12),
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
                                  (((nutrition['current']['fiber'] ?? 0.0)
                                              as num) /
                                          (nutrition['goal']['fiber'] ??
                                              0.0) as num)
                                      .toDouble()
                                      .clamp(0, 1),
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(113, 52, 121, 40),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              height: 200,
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Fiber",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '${(nutrition['current']['fiber'] ?? 0.0)}g',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(((nutrition['current']['fiber'] / nutrition['goal']['fiber']) as double) * 100).toStringAsFixed(2)}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${(((nutrition['goal']['fiber'] ?? 0.0) - (nutrition['current']['fiber'] ?? 0.0)) as double).toStringAsFixed(1)}g left',
                          style: TextStyle(fontSize: 12),
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
      ),
    );
  }
}
