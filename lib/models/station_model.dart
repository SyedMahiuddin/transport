import 'package:cloud_firestore/cloud_firestore.dart';

class StationModel {
  final String name;
  final GeoPoint location;
  final double distance;
  final String imageUrl;

  StationModel({
    required this.name,
    required this.location,
    required this.distance,
    required this.imageUrl,
  });
}