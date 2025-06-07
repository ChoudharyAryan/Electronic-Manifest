bool isValidUrl(String url) {
  final urlRegex = RegExp(
    r'^(?:(?:https?|ftp)://)?' // Optional protocol
    r'(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)*' // Subdomains
    r'[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?' // Domain
    r'(?:\.[A-Z]{2,6})' // TLD
    r'(?::\d+)?' // Optional port
    r'(?:/[^\s]*)?$', // Optional path
  );
  
  return url.isNotEmpty && urlRegex.hasMatch(url.trim());
}