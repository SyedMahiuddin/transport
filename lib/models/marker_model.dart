import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase package for GeoPoint

class LocationModel {
   String title;
   String description;
   String imageIcon;
   GeoPoint geopoint; // Use Firebase GeoPoint

  LocationModel({
    required this.title,
    required this.description,
    required this.imageIcon,
    required this.geopoint, // Initialize with GeoPoint
  });

  // Create a LocationModel from a JSON object
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageIcon: json['imageIcon'] as String,
      geopoint: GeoPoint(
        (json['geopoint']['latitude'] as num).toDouble(),
        (json['geopoint']['longitude'] as num).toDouble(),
      ), // Parse GeoPoint
    );
  }

  // Convert a LocationModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageIcon': imageIcon,
      'geopoint': {
        'latitude': geopoint.latitude,
        'longitude': geopoint.longitude,
      }, // Convert GeoPoint to JSON
    };
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
