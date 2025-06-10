bool isValidProperties(String properties) {

  final propertiesRegex = RegExp(r'^[A-Za-z ]+(?:,[A-Za-z ]+)*$');

  return properties.isNotEmpty && propertiesRegex.hasMatch(properties.trim());
}
