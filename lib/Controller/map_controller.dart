

import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:transport/Repository/map_repo.dart';
import 'package:transport/app_config.dart';
import 'package:transport/models/marker_model.dart';
import 'package:transport/views/transport_screen.dart';

class MapController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    //getPolyline();
    getLocations();
    super.onInit();
  }

  var openMapOnly=false.obs;
  final LatLng center = const LatLng(-33.887385, 151.204274);
  final LatLng centerDestination = const LatLng(-33.877385, 151.104274);
  var driverMarkerList = [].obs;
  TripOption? selectedTripOption;

  final TextEditingController destinationController = TextEditingController();
  GooglePlace googlePlace = GooglePlace(AppConfig.mapApiKey);
  late GoogleMapController mapController;
  late GoogleMapController mapControllerTO;
  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
  var polylineCoordinatesWalk = [].obs;
  var findingRoutes=false.obs;


  var allLocations = [].obs;
  Future<void> getLocations() async {
    MapRepository().getLocations().listen((event) async{
      allLocations.value = List.generate(
          event.docs.length,
              (index) => LocationModel.fromJson(
              event.docs[index].data()));
      List<Marker> newMarkers = await  convertLocationsToMarkers(allLocations);
      markers.value=  newMarkers.toSet();
    });
  }
  Future<BitmapDescriptor> _getMarkerIconFromTitle(String title) async {
    String assetPath;
    if (title.contains('Cafe')) {
      assetPath = 'assets/images/cafeMark.png';
    } else if (title.contains('Police')) {
      assetPath = 'assets/images/libraryMark.png';
    } else if (title.contains('Danger')) {
      assetPath = 'assets/images/dangerMark.png';
    } else if (title.contains('Library')) {
      assetPath = 'assets/images/libraryMark.png';
    } else {
      // Return default marker if no specific icon is set
      return BitmapDescriptor.defaultMarker;
    }
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)), // Adjust the size as needed
      assetPath,
    );
  }

  Future<List<Marker>> convertLocationsToMarkers(var locations) async {
    print("loading markers");
    List<Marker> markers = [];

    for (var location in locations) {
      final BitmapDescriptor markerIcon = await _getMarkerIconFromTitle(location.title);

      markers.add(
        Marker(
          markerId: MarkerId(location.title),
          position: LatLng(location.geopoint.latitude, location.geopoint.longitude),
          icon: markerIcon,
          infoWindow: InfoWindow(
            title: location.title,
            snippet: location.description,
          ),
        ),
      );
    }

    return markers;
  }
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



var markers= <Marker>{}.obs;
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
  }
late GeoPoint longPickedPoint;
  var addingPlace=false.obs;
  void onMapLongTapped(LatLng position)
  {
    addingPlace.value=true;
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

    longPickedPoint= GeoPoint(position.latitude, position.longitude);

    //getPlaceDetailsforMarker(placeId);
    // MapRepository().addToFirestore(
    //   LocationModel(title: "Place", description: "Police here", imageIcon: "", lat: 99.0, long: 77.0)
    // );
  }

  Future<void> getPlaceDetailsforMarker(String placeId) async {

    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && result.result!.geometry != null) {
      var location = result.result!.geometry!.location;
      LatLng latLng = LatLng(location!.lat!, location.lng!);

    }
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
    if(selectedTripOption!=null)
    {
      print("camera moving to polyline");
      polylineCoordinates.value=decodePolyline(selectedTripOption!.polyline);
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

  }


  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    moveCameraToPolyline();
  }

  void onCameraMove(CameraPosition position) {
    log("camera Moving");
  }

  void onCameraIdle() {
    log("camera Idle");
  }


  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }

    return polyline;
  }

}