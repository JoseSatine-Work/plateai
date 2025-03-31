class UserProfile {
  String userName;
  String email;
  num phoneNumber;
  bool gender;
  num age;
  String goal;

  UserProfile({
    this.userName = '',
    this.email = '',
    this.phoneNumber = -1,
    this.gender = true,
    this.age = -1,
    this.goal = '',
  });

  // Convert UserProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'age': age,
      'goal': goal,
    };
  }

  // Create a UserProfile instance from a map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? -1,
      gender: map['gender'] ?? true,
      age: map['age'] ?? -1,
      goal: map['goal'] ?? '',
    );
  }
}
