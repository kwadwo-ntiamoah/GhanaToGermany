import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // This part directive is needed for code generation

@JsonSerializable() // This annotation indicates that the class can be serialized
class User {
  final String nickname, fullName;
  final String? profilePhoto, photos;

  User({
    required this.nickname,
    required this.fullName,
    this.profilePhoto,
    this.photos
  });

  // Factory method to create a User from a JSON map
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Method to convert a User to a JSON map
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

