import 'package:flutter/material.dart';

class UserData {
  double age;
  double height;
  double weight;
  double waist;

  UserData({
    required this.age,
    required this.height,
    required this.weight,
    required this.waist,
  });
}

class BMI_Parameters extends StatefulWidget {
  final UserData data;
  final Function(double) setAge;
  final Function(double) setHeight;
  final Function(double) setWeight;
  final Function(double) setWaist;

  const BMI_Parameters(
      {super.key,
      required this.data,
      required this.setAge,
      required this.setHeight,
      required this.setWeight,
      required this.setWaist});

  @override
  State<BMI_Parameters> createState() => _BMI_ParametersState();
}

class _BMI_ParametersState extends State<BMI_Parameters> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSlider(
            label: "Age",
            value: widget.data.age,
            min: 0,
            max: 100,
            unit: "",
            onChanged: widget.setAge,
          ),
          const SizedBox(height: 16),
          buildSlider(
              label: "Height",
              value: widget.data.height,
              min: 0,
              max: 3,
              unit: "m",
              onChanged: widget.setHeight),
          const SizedBox(height: 16),
          buildSlider(
              label: "Weight",
              value: widget.data.weight,
              min: 0,
              max: 300,
              unit: "kg",
              onChanged: widget.setWeight),
          const SizedBox(height: 16),
          buildSlider(
              label: "Waist circumference",
              value: widget.data.waist,
              min: 0,
              max: 200,
              unit: "cm",
              onChanged: widget.setWaist),
        ],
      ),
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$label : ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              unit.isEmpty
                  ? "${value.round()}"
                  : "${value.toStringAsFixed(2)} $unit",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          label: value.toString(),
          activeColor: Colors.green,
          inactiveColor: Colors.grey.shade400,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
