import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart'; // This part directive is needed for code generation

@JsonSerializable() // This annotation indicates that the class can be serialized
class Token {
  final String key, email;
  final int expiryMinutes;
  final bool pendingProfileUpdate;

  Token({
    required this.key,
    required this.expiryMinutes,
    required this.email,
    required this.pendingProfileUpdate
  });

  // Factory method to create a User from a JSON map
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  // Method to convert a User to a JSON map
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

