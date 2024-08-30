import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models/marker_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;

class MapRepository {

  Future<void> addToFirestore(LocationModel location, String imagePath) async {
    try {
      // Initialize Firebase Storage reference
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = imagePath.split('/').last;
      final imageRef = storageRef.child('images/$fileName');

      UploadTask uploadTask;
      Uint8List resizedImageBytes;

      if (imagePath.startsWith('assets/')) {
        print('Attempting to upload asset image...');

        try {
          // Load asset data as bytes
          final byteData = await rootBundle.load(imagePath);
          print('Asset image loaded successfully.');
          final imageData = byteData.buffer.asUint8List();

          // Resize image to 100x100 pixels
          resizedImageBytes = await resizeImage(imageData);
        } catch (e) {
          print('Error loading asset image: $e');
          return; // Exit if loading asset fails
        }

        // Start upload with resized image bytes
        uploadTask = imageRef.putData(resizedImageBytes);
      } else {
        print('Attempting to upload file from path: $imagePath');

        final file = File(imagePath);
        if (await file.exists()) {
          // Read file as bytes
          final imageData = await file.readAsBytes();

          // Resize image to 100x100 pixels
          resizedImageBytes = await resizeImage(imageData);

          // Upload the resized image to Firebase Storage
          uploadTask = imageRef.putData(resizedImageBytes);
        } else {
          print("File does not exist at path: $imagePath");
          return; // Exit if file doesn't exist
        }
      }

      // Monitor the upload task for progress and errors
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      }, onError: (e) {
        print('Upload error: $e');
      });

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      print('Upload complete. Getting download URL...');

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Download URL obtained: $downloadUrl');

      // Update location model with the image URL
      location.imageIcon = downloadUrl;

      // Save location to Firestore
      final collection = FirebaseFirestore.instance.collection('Markers');
      await collection.add(location.toJson());

      print('Document added to Firestore successfully with image URL.');
    } catch (e) {
      print('Failed to add document to Firestore: $e');
    }
  }

// Method to resize image to 100x100 pixels
  Future<Uint8List> resizeImage(Uint8List imageData) async {
    // Decode image to process with the image package
    img.Image? originalImage = img.decodeImage(imageData);
    if (originalImage == null) {
      throw Exception('Failed to decode image for resizing');
    }

    // Resize image to 100x100 pixels
    img.Image resizedImage = img.copyResize(originalImage, width: 100, height: 100);

    // Encode the resized image back to bytes (PNG format)
    return Uint8List.fromList(img.encodePng(resizedImage));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLocations() {
    return FirebaseFirestore.instance
        .collection('Markers')
        .snapshots();
  }

}