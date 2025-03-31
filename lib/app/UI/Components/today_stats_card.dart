import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/UI/Screens/dashboard/page.dart';

class TodayStatsCard extends StatelessWidget {
  const TodayStatsCard({
    super.key,
    required this.calories,
    required this.bbScore,
    required this.hwrScore,
    required this.wthScore,
    required this.activityScore,
    required this.dietScore,
  });

  final int calories;
  final String bbScore;
  final String hwrScore;
  final String wthScore;
  final String activityScore;
  final String dietScore;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/Nutrition');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today",
              textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(30, 52, 121, 40),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth * 0.85,
                            height: 350,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(226, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.shade400.withAlpha(180),
                              width: 6,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // "1590",
                                  "$calories",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Remaining",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Calories",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "BBS = (0.4 × HWR) + (0.3 × WTH)\n+ (0.2 × Activity) + (0.1 × Diet)",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            buildScoreRow("BB Score", bbScore,
                                fw: FontWeight.bold),
                            buildScoreRow("HWR Score", hwrScore),
                            buildScoreRow("WTH Score", wthScore),
                            buildScoreRow("Activity Score", activityScore),
                            buildScoreRow("Diet Score", dietScore),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
