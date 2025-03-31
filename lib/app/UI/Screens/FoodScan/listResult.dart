import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Models/item.dart';
import 'dart:math';

import 'package:flutter_application_1/services/item_repository.dart';

class ListResult extends StatefulWidget {
  const ListResult({super.key});

  @override
  State<ListResult> createState() => _ListResultState();
}

class _ListResultState extends State<ListResult> {
  // List<Food> foodList = [
  //   Food(
  //     name: 'Apple',
  //     nutrients: FoodNutrients(
  //       protein: 0.3,
  //       fat: 0.2,
  //       carbs: 14.0,
  //       fibers: 2.4,
  //     ),
  //   ),
  //   Food(
  //     name: 'Banana',
  //     nutrients: FoodNutrients(
  //       protein: 1.1,
  //       fat: 0.3,
  //       carbs: 23.0,
  //       fibers: 2.6,
  //     ),
  //   ),
  //   Food(
  //     name: 'Orange',
  //     nutrients: FoodNutrients(
  //       protein: 0.9,
  //       fat: 0.1,
  //       carbs: 11.8,
  //       fibers: 2.4,
  //     ),
  //   ),
  //   Food(
  //     name: 'Spinach',
  //     nutrients: FoodNutrients(
  //       protein: 2.9,
  //       fat: 0.4,
  //       carbs: 3.6,
  //       fibers: 2.2,
  //     ),
  //   ),
  //   Food(
  //     name: 'Chicken',
  //     nutrients: FoodNutrients(
  //       protein: 31.0,
  //       fat: 3.6,
  //       carbs: 0.0,
  //       fibers: 0.0,
  //     ),
  //   ),
  //   Food(
  //     name: 'Salmon',
  //     nutrients: FoodNutrients(
  //       protein: 25.0,
  //       fat: 13.0,
  //       carbs: 0.0,
  //       fibers: 0.0,
  //     ),
  //   ),
  //   Food(
  //     name: 'Quinoa',
  //     nutrients: FoodNutrients(
  //       protein: 4.4,
  //       fat: 1.9,
  //       carbs: 21.3,
  //       fibers: 2.8,
  //     ),
  //   ),
  //   Food(
  //     name: 'Avocado',
  //     nutrients: FoodNutrients(
  //       protein: 2.0,
  //       fat: 15.0,
  //       carbs: 9.0,
  //       fibers: 7.0,
  //     ),
  //   ),
  //   Food(
  //     name: 'Broccoli',
  //     nutrients: FoodNutrients(
  //       protein: 2.8,
  //       fat: 0.4,
  //       carbs: 7.0,
  //       fibers: 2.6,
  //     ),
  //   ),
  // ];

  // void updateFoodList(List<Food> newList) {
  //   setState(() {
  //     foodList = newList;
  //   });
  // }

  final ItemRepository _repository = ItemRepository();

  List<Item> foodList = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final items = await _repository.fetchItems();
    setState(() {
      foodList = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Scanner Result",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: foodList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildResultCard(foodList[index]),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/Dashboard');
              },
            ),
            const SizedBox(width: 60), // Space for the FAB
            IconButton(
              icon: Icon(
                Icons.format_list_bulleted,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ScanFoodListResult');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            // Action for FAB
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildResultCard(Item food) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/ScanFoodResult', arguments: food);
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _buildBackgroundLayers(),
          _buildContentRow(food),
        ],
      ),
    );
  }

  Widget _buildBackgroundLayers() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 0),
          height: 180,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth * 0.85,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContentRow(Item food) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // _buildCircularAvatar(food.name),
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.file(
                File(food.imagePath),
                fit: BoxFit.cover,
                height: 96,
                width: 96,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(child: _buildUserInfo(food)),
        ],
      ),
    );
  }

  Widget _buildCircularAvatar(String name) {
    String initials = name.isNotEmpty
        ? name.substring(0, min(2, name.length)).toUpperCase()
        : "??";
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            "${value}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Item food) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          food.data['name'],
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildNutrientRow('Protein', food.data['dailyValue']['protein'] ?? ""),
        _buildNutrientRow('Fat', food.data['dailyValue']['totalFat'] ?? ""),
        _buildNutrientRow(
            'Carbs', food.data['dailyValue']['totalCarbohydrates'] ?? ""),
        _buildNutrientRow(
            'Fibers', food.data['dailyValue']['dietaryFiber'] ?? ""),
      ],
    );
  }
}
