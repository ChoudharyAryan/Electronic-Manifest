
import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final String name;
  final bool isConsumable;
  final String? description;
  final String imageUrl;
  final List<String> properties;

  const Class(
      {required this.name,
      required this.isConsumable,
      required this.imageUrl,
      required this.properties,
      this.description});

  static const empty = Class(
      name: "-*",
      isConsumable: false,
      description: "-*",
      imageUrl: "assets/icons/blankImage.png",
      properties: ["-*"]);

  static Class fromJson(Map data) {
    return Class(
      name: "${data['name']}",
      isConsumable: data['is_consumable'],
      imageUrl: "${data['image']}",
      description: "${data['description']}",
      properties:
          "${data['properties']}".split(',').map((e) => e.trim()).toList(),
    );
  }

  @override
  List<Object?> get props =>
      [name, isConsumable, imageUrl, description, properties];
}
