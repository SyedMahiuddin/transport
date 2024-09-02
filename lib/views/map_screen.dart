import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transport/Controller/map_controller.dart';

import '../customs/color_helper.dart';
import '../models/marker_model.dart';
import 'add_place.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  MapController mapController=Get.put(MapController());

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme,
      body: Stack(
        children: [
          // Map Placeholder
          Positioned.fill(
            child: Container(
              color: ColorHelper.darkGrey, // Placeholder for map background color
              child: Center(
                child:  Obx(() => SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    markers: mapController.markers.cast<Marker>().toSet(),
                    onTap: mapController.onMapTapped,
                    onLongPress: mapController.onMapLongTapped,
                    polylines: mapController.openMapOnly.value?{}: {
                      Polyline(
                          polylineId: const PolylineId("route"),
                          points: mapController.decodePolyline(mapController.selectedTripOption!.polyline)
                              .map((geoPoint) =>
                              LatLng(geoPoint.latitude, geoPoint.longitude))
                              .toList(),
                          color: Colors.blue,
                          width: 7),

                    },

                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    onMapCreated: mapController.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target:mapController.openMapOnly.value?mapController.centerDestination: mapController.center,
                      zoom: 15.0,
                    ),
                  ),
                )),

              ),
            ),
          ),
          // Top bar with time and icons
          Positioned(
            top: 25.h,
            left: 10.w,
            child: InkWell(
              onTap: (){

              Get.back();
              //mapController.openMapOnly.value=false;
            }, child:Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, color: ColorHelper.primaryTheme, size: 28.sp),
                ))),)
          ),
          // Floating action button for map center
          Positioned(
            bottom: 170.h,
            right: 16.w,
            child: FloatingActionButton(
              backgroundColor: ColorHelper.primaryText,
              onPressed: () {},
              child: Icon(Icons.my_location, color: ColorHelper.primaryTheme, size: 28.sp),
            ),
          ),
          // Floating action button for notifications
          Positioned(
            bottom: 230.h,
            right: 16.w,
            child: FloatingActionButton(
              backgroundColor: ColorHelper.primaryText,
              onPressed: () {},
              child: Icon(Icons.notifications, color: ColorHelper.primaryTheme, size: 28.sp),
            ),
          ),
          // Bottom Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: mapController.openMapOnly.value?SizedBox(): Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorHelper.primaryTheme,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departs',
                            style: TextStyle(
                              color: ColorHelper.secondryTheme,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            mapController.selectedTripOption!.duration,
                            style: TextStyle(
                              color: ColorHelper.primaryText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '\$${mapController.selectedTripOption!.cost}',
                        style: TextStyle(
                          color: ColorHelper.primaryText,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '7:18am - 8:32am  1hr 14mins',
                          style: TextStyle(
                            color: ColorHelper.primaryText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorHelper.secondryTheme,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 32.w),
                        ),
                        onPressed: () {},
                        child: Text(
                          'GO',
                          style: TextStyle(
                            color: ColorHelper.primaryText,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.directions_walk, color: ColorHelper.primaryText, size: 24.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'B 747 M M1',
                        style: TextStyle(
                          color: ColorHelper.primaryText,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Obx(()=>mapController.addingPlace.value?AddPlacePopup():SizedBox()),
          )
        ],
      ),
    );
  }
}