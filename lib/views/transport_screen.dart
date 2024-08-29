import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_place/google_place.dart';
import 'package:transport/Controller/map_controller.dart';
import 'package:transport/app_config.dart';
import 'package:transport/views/map_screen.dart';
import '../customs/color_helper.dart';

// Initialize Google Place API
final googlePlace = GooglePlace(AppConfig.mapApiKey); // Replace with your API key

class TripPlannerScreen extends StatefulWidget {
  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  MapController mapController=Get.put(MapController());
  int selectedTypeIndex = 3;
  bool stWriting = true;
  List<AutocompletePrediction> predictions = [];
  String startPlaceId = '';
  String destinationPlaceId = '';
  LatLng? startLatLng=LatLng(23.807141, 90.368774);
  LatLng? destinationLatLng=LatLng(23.751104, 90.392770);
  List<TripOption> tripOptions = [];

  // Controllers for text fields
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startController.addListener(() async {
      if (startController.text.isNotEmpty) {
        await _autocompleteSearch(startController.text, true);
      }
    });

    destinationController.addListener(() async {
      if (destinationController.text.isNotEmpty) {
        await _autocompleteSearch(destinationController.text, false);
      }
    });
  }

  @override
  void dispose() {
    startController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: ColorHelper.darkGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    _buildSearchField(
                      controller: startController,
                      hintText: 'Enter starting location',
                      isStart: true,
                      onSelected: (prediction) async {
                        setState(() {
                          startPlaceId = prediction.placeId ?? '';
                          predictions = [];
                        });
                        await _getPlaceDetails(startPlaceId, isStart: true);
                      },
                    ),
                    Divider(color: Colors.white, height: 20.h),
                    _buildSearchField(
                      controller: destinationController,
                      hintText: 'Enter destination',
                      isStart: false,
                      onSelected: (prediction) async {
                        setState(() {
                          destinationPlaceId = prediction.placeId ?? '';
                          predictions = [];
                        });
                        await _getPlaceDetails(destinationPlaceId, isStart: false);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (startLatLng != null && destinationLatLng != null) {
                      _suggestTripOptions();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.secondryTheme,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Save this trip',
                    style: TextStyle(
                      color: ColorHelper.primaryTheme,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTypeIndex = 0;
                      });
                    },
                    child: _buildTransportOption(Icons.directions_walk, '--', selectedTypeIndex == 0),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTypeIndex = 1;
                      });
                    },
                    child: _buildTransportOption(Icons.directions_bike, '--', selectedTypeIndex == 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTypeIndex = 2;
                      });
                    },
                    child: _buildTransportOption(Icons.directions_walk, '--', selectedTypeIndex == 2),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTypeIndex = 3;
                      });
                    },
                    child: _buildTransportOption(Icons.directions_car, '56 min', selectedTypeIndex == 3),
                  ),
                  Icon(Icons.filter_list, color: Colors.white, size: 24.sp),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Leaving now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Load earlier times',
                style: TextStyle(
                  color: ColorHelper.secondryTheme,
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 20.h),
              ...tripOptions.map((option) => InkWell(
                onTap: () {
                  mapController.selectedTripOption=option;

                  Get.to(() => MapScreen(), transition: Transition.downToUp, duration: Duration(milliseconds: 400));
                },
                child: _buildTripOption(
                  option.departs,
                  option.timeRange,
                  option.duration,
                  option.cost,
                  option.isAccessible,
                  transportMode: option.transportMode,
                  name: option.name,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
    required bool isStart,
    required Function(AutocompletePrediction) onSelected,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              isStart ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        if (predictions.isNotEmpty)
          Container(
            color: ColorHelper.darkGrey,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(predictions[index].description ?? '', style: TextStyle(color: Colors.white)),
                  onTap: () => onSelected(predictions[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _autocompleteSearch(String value, bool isStart) async {
    if (value.isEmpty) {
      setState(() {
        predictions = [];
      });
      return;
    }
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future<void> _getPlaceDetails(String placeId, {required bool isStart}) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && result.result!.geometry != null) {
      var location = result.result!.geometry!.location;
      LatLng latLng = LatLng(location!.lat!, location.lng!);
      setState(() {
        if (isStart) {
          print("getting start letLng");
          startLatLng = latLng;
        } else {
          print("getting end letLng");
          destinationLatLng = latLng;
        }
      });

      if (startLatLng != null && destinationLatLng != null) {
        _suggestTripOptions();
      }
    }
  }

  Future<void> _suggestTripOptions() async {
    print("making suggesstions");
    if (startLatLng != null && destinationLatLng != null) {
      // Fetch trip options for different transport modes
      List<TripOption> options = [];
      options.addAll(await _fetchTripOptions(startLatLng!, destinationLatLng!, 'transit'));
      options.addAll(await _fetchTripOptions(startLatLng!, destinationLatLng!, 'driving'));
      options.addAll(await _fetchTripOptions(startLatLng!, destinationLatLng!, 'bicycling'));
      options.addAll(await _fetchTripOptions(startLatLng!, destinationLatLng!, 'walking'));

      setState(() {
        tripOptions = options;
      });
    }
  }

  Future<List<TripOption>> _fetchTripOptions(LatLng start, LatLng destination, String mode) async {
    final apiKey = AppConfig.mapApiKey; // Replace with your API key
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${start.latitude},${start.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=$mode'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    return _parseTripOptions(data, mode);
  }

  List<TripOption> _parseTripOptions(Map<String, dynamic> data, String mode) {
    List<TripOption> tripOptions = [];
    var routes = data['routes'] as List<dynamic>;

    for (var route in routes) {
      var leg = route['legs'][0];
      var duration = leg['duration']['text'];
      var distance = leg['distance']['text'];
      var polyline = route['overview_polyline']['points'];

      print("points: ${polyline}");

      tripOptions.add(TripOption(
        transportMode: mode,
        departs: 'Now',
        timeRange: '7:00am - 8:00am',
        duration: duration,
        cost: '\$${(double.parse(distance.split(' ')[0].replaceAll(',', '').replaceAll('.', '')) * 0.1).toStringAsFixed(2)}',
        isAccessible: true,
        name: mode == 'transit' ? 'Bus 747' : 'Car',
        polyline: polyline,
      ));
    }

    return tripOptions;
  }

  Widget _buildTripOption(
      String departs,
      String timeRange,
      String duration,
      String cost,
      bool isAccessible, {
        required String transportMode,
        required String name,
      }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(
            transportMode == 'transit' ? Icons.directions_bus : Icons.directions_car,
            color: Colors.white,
            size: 30.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Departs: $departs',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                Text(
                  'Time Range: $timeRange',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                Text(
                  'Duration: $duration',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                Text(
                  'Cost: $cost',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                if (isAccessible)
                  Text(
                    'Accessible',
                    style: TextStyle(color: Colors.green, fontSize: 14.sp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportOption(IconData icon, String time, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isSelected ? ColorHelper.secondryTheme : ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            time,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

class TripOption {
  final String transportMode;
  final String departs;
  final String timeRange;
  final String duration;
  final String cost;
  final bool isAccessible;
  final String name;
  final String polyline;

  TripOption({
    required this.transportMode,
    required this.departs,
    required this.timeRange,
    required this.duration,
    required this.cost,
    required this.isAccessible,
    required this.name,
    required this.polyline,
  });
}
