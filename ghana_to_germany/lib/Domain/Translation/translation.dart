import 'package:json_annotation/json_annotation.dart';

part 'translation.g.dart'; // This part directive is needed for code generation

@JsonSerializable() // This annotation indicates that the class can be serialized
class Translation {
  final String input, translation;

  Translation({required this.input, required this.translation});

  // Factory method to create a User from a JSON map
  factory Translation.fromJson(Map<String, dynamic> json) => _$TranslationFromJson(json);

  // Method to convert a User to a JSON map
  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
