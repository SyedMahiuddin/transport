import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:transport/Repository/map_repo.dart';
import 'package:transport/app_config.dart';
import 'package:transport/models/marker_model.dart';

class MapController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    getPolyline();
    super.onInit();
  }

  final LatLng center = const LatLng(-33.887385, 151.204274);
  final LatLng centerDestination = const LatLng(-33.877385, 151.104274);
  var driverMarkerList = [].obs;

  final TextEditingController destinationController = TextEditingController();
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
  var polylineCoordinatesWalk = [].obs;
  var findingRoutes=false.obs;
  getPolyline() async {
    findingRoutes.value=true;
    polyLines.clear();
    polylineCoordinates.clear;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(
          center.latitude, center.longitude),
      PointLatLng(centerDestination.latitude,
          centerDestination.longitude),
      travelMode: TravelMode.transit,
    );
    log("polyLineResponse: ${result.points.length}");
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log("${result.errorMessage}");
    }

    PolylineResult resultWalk = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(
          center.latitude, center.longitude),
      PointLatLng(centerDestination.latitude,
          centerDestination.longitude),
      travelMode: TravelMode.walking,
    );
    log("polyLineResponse: ${result.points.length}");
    if (resultWalk.points.isNotEmpty) {
      for (var point in resultWalk.points) {
        polylineCoordinatesWalk.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log("${result.errorMessage}");
    }

    moveCameraToPolyline();
    findingRoutes.value=false;
  }




  var allMarkers = <Marker>{
    Marker(
      markerId: MarkerId('start'),
      position: LatLng(-33.887385, 151.204274),
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: 'Starting Point',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    Marker(
      markerId: MarkerId('end'),
      position: LatLng(-33.877385, 151.104274),
      infoWindow: InfoWindow(
        title: 'End',
        snippet: 'Destination Point',
      ),
      icon: BitmapDescriptor.defaultMarker, // Default red marker
    ),
  }.obs;

  final List<double> _rotations = [
    0.0, 45.0, 90.0,
  ];

  void onMapTapped(LatLng position) {
      allMarkers.add(
        Marker(
          markerId: MarkerId("tempMarker"),
          position: position,
          infoWindow: const InfoWindow(
            title: '',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      MapRepository().addToFirestore(
          LocationModel(title: "Place", description: "Police here", imageIcon: "", lat: 99.0, long: 77.0)
      );
  }

  void onMapLongTapped(LatLng position)
  {
    allMarkers.add(
      Marker(
        markerId: MarkerId("tempMarker"),
        position: position,
        infoWindow: const InfoWindow(
          title: '',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    MapRepository().addToFirestore(
      LocationModel(title: "Place", description: "Police here", imageIcon: "", lat: 99.0, long: 77.0)
    );
  }

  Future<void> loadMarkers() async {
    await Future.delayed(const Duration(seconds: 1));
    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/images/marker.png',
    );
    var listToMarked= driverMarkerList;
    Set<Marker> markers =
    listToMarked.value.asMap().entries.map((entry) {
      int idx = entry.key;
      LatLng location = entry.value;
      double rotation =
      _rotations[idx % _rotations.length]; // Cycle through rotations

      return Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: markerIcon,
        rotation: rotation,
      );
    }).toSet();

    allMarkers.value = markers;
    log("marker length: ${allMarkers.length}");

  }

  void moveCameraToPolyline() {
    if (polylineCoordinates.isEmpty) return;

    double minLat = polylineCoordinates[0].latitude;
    double maxLat = polylineCoordinates[0].latitude;
    double minLng = polylineCoordinates[0].longitude;
    double maxLng = polylineCoordinates[0].longitude;

    for (var point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }


  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraMove(CameraPosition position) {
    log("camera Moving");
  }

  void onCameraIdle() {
    log("camera Idle");
  }
}