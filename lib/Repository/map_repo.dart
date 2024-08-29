import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transport/models/marker_model.dart';

class MapRepository{
  Future<void> addToFirestore(LocationModel location) async {
    try {
      // Get a reference to the Firestore collection
      final collection = FirebaseFirestore.instance.collection('Markers');

      // Add the document to the collection with a unique ID
      await collection.add(location.toJson());

      print('Document added to Firestore successfully');
    } catch (e) {
      print('Failed to add document to Firestore: $e');
    }
  }
}