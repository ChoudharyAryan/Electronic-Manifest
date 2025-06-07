
import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final String name;
  final bool isConsumable;
  final String? description;
  final String imageUrl;

  const Class(
      {required this.name,
      required this.isConsumable,
      required this.imageUrl,
      this.description});

  static const empty = Class(
      name: "-*",
      isConsumable: false,
      description: "-*",
      imageUrl: "assets/icons/blankImage.png");

  static Class fromJson(Map data) {
    final String url = data['image'];
    final regExp = RegExp(r'd/([a-zA-Z0-9_-]+)/');
    final match = regExp.firstMatch(url);
    if (match != null) {
      final fileId = match.group(1);
      data['image'] = 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    //log("This is the iamg URL ${data['image'].toString()}");
    return Class(
        name: "${data['name']}",
        isConsumable: data['is_consumable'],
        imageUrl: "${data['image']}",
        description: "${data['description']}");
  }

  @override
  List<Object?> get props => [name, isConsumable, imageUrl, description];
}
