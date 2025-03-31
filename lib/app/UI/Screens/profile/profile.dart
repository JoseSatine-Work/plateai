import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Data/activity_levels.dart';
import 'package:flutter_application_1/app/Data/goals.dart';
import 'package:flutter_application_1/app/Models/user.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;

  void getProfile(context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      user = userProvider.user;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Map<String, dynamic> profile = {
    'age': 25,
    'height': 170,
    'weight': 60,
    'gender': true,
    'activityLevel': 'Not Very Active', // Fixed typo
    'goal': 'Lose Weight', // Fixed typo
  };

  @override
  Widget build(BuildContext context) {
    getProfile(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          iconSize: 30.0,
          onPressed: () => Navigator.pop(context), // Added navigation
        ),
        centerTitle: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Added scrolling support
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(
                  user?.image ?? "",
                  "${user?.firstName} ${user?.lastName}",
                  user?.email ?? '',
                  user?.phone ?? ''),
              // _buildProfileCard(),
              const SizedBox(height: 20),
              const Text(
                'My Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      String image, String name, String email, String phone) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: Color.fromARGB(30, 52, 121, 40),
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.black.withAlpha(50),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              ]),
        ),
        Positioned(
          width: (MediaQuery.of(context).size.width * 0.8) - 20,
          right: 0,
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.only(
                  left: 40, top: 16, bottom: 16, right: 8),
              width: constraints.maxWidth,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/EditProfile');
                    },
                    icon: const Icon(Icons.edit_square,
                        color: Colors.green, size: 24),
                  ),
                ],
              ),
            );
          }),
        ),
        Positioned(
          top: (120 / 2) - 38,
          left: 10,
          child: image == ''
              ? CircleAvatar(
                  radius: 36,
                  backgroundColor: Color.fromARGB(255, 115, 161, 112),
                  child: Text(
                    name.split(' ').map((e) => e[0]).join(''),
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(image),
                ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    final List<MapEntry<String, String>> profileItems = [
      MapEntry('Age', '${user?.age.toInt()} Years'),
      MapEntry('Height', '${((user?.height ?? 0) * 100).toInt()} cm'),
      MapEntry('Weight',
          '${user?.weight.toStringAsFixed(1)} kg'), // Fixed weight display
      MapEntry('Gender', user?.gender ?? ""),
      MapEntry('Goal', goals[user?.goal ?? 0]),
      MapEntry(
        'Activity level',
        activityLevels[(user?.activityLevel.toInt()) ?? 0]['title'],
      ),
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: profileItems.map((item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.key,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1, // Ensure it stays on one line
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 3, // Limits the text to one line
                          overflow: TextOverflow
                              .ellipsis, // Adds ellipsis for overflow
                          textAlign:
                              TextAlign.end, // Align text to the end if needed
                        ),
                      ),
                    ],
                  ),
                  if (item != profileItems.last) const Divider(thickness: 1),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
