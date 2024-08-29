import 'dart:convert';

class LocationModel {
  final String title;
  final String description;
  final String imageIcon;
  final double lat;
  final double long;

  LocationModel({
    required this.title,
    required this.description,
    required this.imageIcon,
    required this.lat,
    required this.long,
  });

  // Create a LocationModel from a JSON object
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageIcon: json['imageIcon'] as String,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
    );
  }

  // Convert a LocationModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageIcon': imageIcon,
      'lat': lat,
      'long': long,
    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
