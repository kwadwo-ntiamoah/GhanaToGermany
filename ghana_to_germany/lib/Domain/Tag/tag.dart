import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart'; // This part directive is needed for code generation

@JsonSerializable() // This annotation indicates that the class can be serialized
class Tag {
  final String name;

  Tag({required this.name});

  static List<Tag> tagsFromJson(List<dynamic> json) {
    return json.map((post) => Tag.fromJson(post)).toList();
  }

  // Factory method to create a User from a JSON map
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  // Method to convert a User to a JSON map
  Map<String, dynamic> toJson() => _$TagToJson(this);
}
