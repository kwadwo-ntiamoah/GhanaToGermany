import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart'; // This part directive is needed for code generation

@JsonSerializable()
class Profile {
  String email;
  String nickname;
  String fullName;
  String profilePhoto;
  String photos;

  Profile({
    required this.email,
    required this.nickname,
    required this.fullName,
    required this.profilePhoto,
    required this.photos,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}