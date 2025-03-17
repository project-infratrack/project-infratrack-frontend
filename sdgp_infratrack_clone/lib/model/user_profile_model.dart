// lib/model/user_profile.dart

class UserProfile {
  final String name;
  final String idNumber;
  final String username;
  final String email;
  final String mobileNo;

  UserProfile({
    required this.name,
    required this.idNumber,
    required this.username,
    required this.email,
    required this.mobileNo,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      idNumber: json['idNumber'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'idNumber': idNumber,
      'username': username,
      'email': email,
      'mobileNo': mobileNo,
    };
  }
}
