import 'base_model.dart';

class UserModel extends BaseModel<UserModel> {
  String username;
  String fullname;
  String phoneNumber;
  String email;
  String? address;
  String? gender;
  String role;
  String? profilePicture;

  UserModel({
    required String id,
    required this.username,
    required this.fullname,
    required this.phoneNumber,
    required this.email,
    this.address,
    this.gender,
    this.profilePicture,
    required this.role,
    required DateTime created,
    required DateTime updated,
  }) : super(id: id, created: created, updated: updated) {
    collection = "users";
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      username: map['username'],
      fullname: map['fullname'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      address: map['address'],
      gender: map['gender'],
      role: map['role'],
      profilePicture: map['profilePicture'],
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'username': username,
      'fullname': fullname,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'gender': gender,
      'profilePicture': profilePicture,
      'role': role,
    };
  }
}
