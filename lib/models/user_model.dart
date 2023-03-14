// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? id;
  final String name;
  final String contact;
  final String email;
  final String userType;
  UserModel({
    this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.userType,
  });

  factory UserModel.fromMap(Map<String, dynamic> e) {
    return UserModel(
      name: e['name'],
      contact: e['email'],
      email: e['email'],
      userType: e['userType'],
    );
  }
}
