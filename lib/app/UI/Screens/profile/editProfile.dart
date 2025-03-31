import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/Data/activity_levels.dart';
import 'package:flutter_application_1/app/Data/goals.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../../Components/bmi_parameters.dart';
import 'package:flutter_application_1/app/Models/user.dart' as models;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // int _selectedGoal = 1;
  // int _selectedActivityLevel = 1;
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  bool _isLoading = false;
  double _age = 20;
  double _height = 1.8;
  double _weight = 85;
  double _waist = 100;
  XFile? image;

  String imagePath = '';
  String imageUrl = '';

  void _updateAge(double value) {
    setState(() {
      _age = value;
    });
  }

  void _updateHeight(double value) {
    setState(() {
      _height = value;
    });
  }

  void _updateWeight(double value) {
    setState(() {
      _weight = value;
    });
  }

  void _updateWaist(double value) {
    setState(() {
      _waist = value;
    });
  }

  void getUserData(BuildContext context) {
    // final userProvider = context.watch<UserProvider>();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final userData = userProvider.user!;

    setState(() {
      firstNameController.text = userData.firstName;
      lastNameController.text = userData.lastName;
      emailController.text = userData.email;
      phoneController.text = userData.phone;

      _selectedGoalNotifier.value = userData.goal;
      _selectedActivityLevelNotifier.value = userData.activityLevel;

      _age = userData.age;
      _height = userData.height;
      _weight = userData.weight;
      _waist = userData.waist;

      imageUrl = userData.image;
    });
  }

  void setUser(BuildContext context) async {
    // final userProvider = context.watch<UserProvider>();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await _auth.currentUser!.updateDisplayName(
      '${firstNameController.text} ${lastNameController.text}',
    );
    await _auth.currentUser!.updateEmail(emailController.text);

    await _firestore.collection('db').doc(_user!.uid).set({
      'userName': '${firstNameController.text} ${lastNameController.text}',
      'email': emailController.text,
      'phoneNumber': phoneController.text,
    });

    await _firestore.collection('users').doc(_user.uid).set({
      'image': '',
      'goal': _selectedGoalNotifier.value,
      'activityLevel': _selectedActivityLevelNotifier.value,
      'age': _age,
      'height': _height,
      'weight': userProvider.user!.weight,
      'initialWeight': _weight,
      'waist': _waist,
    });

    userProvider.setUser(models.User(
      uid: _auth.currentUser!.uid,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      goal: _selectedGoalNotifier.value,
      activityLevel: _selectedActivityLevelNotifier.value,
      gender: userProvider.user!.gender,
      age: _age,
      height: _height,
      weight: userProvider.user!.weight,
      // weight: _weight,
      image: '',
      initialWeight: _weight,
      waist: _waist,
      dailyDiet: userProvider.user!.dailyDiet,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated Successfully'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    setUser(context);
                  },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    "Save",
                    style:
                        TextStyle(fontSize: 16, color: Colors.green.shade700),
                  ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(),
              _buildInputFields(),
              _buildGoalSection(),
              _buildActivityLevelSection(),
              BMI_Parameters(
                data: UserData(
                  age: _age,
                  height: _height,
                  weight: _weight,
                  waist: _waist,
                ),
                setAge: _updateAge,
                setHeight: _updateHeight,
                setWeight: _updateWeight,
                setWaist: _updateWaist,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              image = await _picker.pickImage(source: ImageSource.camera);
              if (image == null) {
                return;
              }

              setState(() {
                imagePath = image!.path;
              });
            },
            child: imageUrl.isEmpty && imagePath.isEmpty
                ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 115, 161, 112),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "AB",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: imagePath.isNotEmpty
                        ? AssetImage(imagePath)
                        : NetworkImage(imageUrl),
                  ),
          ),
          const SizedBox(height: 10),
          const Text('Tap to change photo',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildTextField(
            controller: firstNameController,
            label: 'First Name',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter first name' : null,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: lastNameController,
            label: 'Last Name',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter last name' : null,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: _emailValidator,
          ),
          const SizedBox(height: 20),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) =>
                setState(() => this.number = number),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              showFlags: true,
            ),
            initialValue: number,
            textFieldController: phoneController,
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  final ValueNotifier<int> _selectedGoalNotifier = ValueNotifier<int>(1);
  final ValueNotifier<double> _selectedActivityLevelNotifier =
      ValueNotifier<double>(1.2);

  Widget _buildGoalSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Goal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<int>(
            valueListenable: _selectedGoalNotifier,
            builder: (context, selectedGoal, _) {
              return Column(
                children: goals.map((goal) {
                  return _buildGoalRadioTile(
                    goal,
                    goals.indexOf(goal),
                    groupValue: selectedGoal,
                    onChanged: (value) => _selectedGoalNotifier.value = value!,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Activity Level",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<double>(
            valueListenable: _selectedActivityLevelNotifier,
            builder: (context, selectedActivityLevel, _) {
              return Column(
                children: activityLevels.map((activityLevel) {
                  return _buildActivityRadioTile(
                    activityLevel['title'],
                    activityLevel['value'],
                    groupValue: selectedActivityLevel,
                    onChanged: (value) =>
                        _selectedActivityLevelNotifier.value = value! as double,
                  );
                }).toList(),
                // children: [
                //   _buildRadioTile(
                //     'Sedentary',
                //     1,
                //     groupValue: selectedActivityLevel,
                //     onChanged: (value) =>
                //         _selectedActivityLevelNotifier.value = value!,
                //   ),
                //   _buildRadioTile(
                //     'Lightly Active',
                //     2,
                //     groupValue: selectedActivityLevel,
                //     onChanged: (value) =>
                //         _selectedActivityLevelNotifier.value = value!,
                //   ),
                //   _buildRadioTile(
                //     'Moderately Active',
                //     3,
                //     groupValue: selectedActivityLevel,
                //     onChanged: (value) =>
                //         _selectedActivityLevelNotifier.value = value!,
                //   ),
                //   _buildRadioTile(
                //     'Very Active',
                //     4,
                //     groupValue: selectedActivityLevel,
                //     onChanged: (value) =>
                //         _selectedActivityLevelNotifier.value = value!,
                //   ),
                //   _buildRadioTile(
                //     'Extra Active',
                //     5,
                //     groupValue: selectedActivityLevel,
                //     onChanged: (value) =>
                //         _selectedActivityLevelNotifier.value = value!,
                //   ),
                // ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalRadioTile(String title, int value,
      {required int groupValue, required ValueChanged<int?> onChanged}) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildActivityRadioTile(String title, double value,
      {required double groupValue, required ValueChanged<num?> onChanged}) {
    return RadioListTile(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
    );
  }

  String? _emailValidator(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await Future.delayed(const Duration(seconds: 1));

        formKey.currentState!.save();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Updated Successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _selectedGoalNotifier.dispose();
    _selectedActivityLevelNotifier.dispose();
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
