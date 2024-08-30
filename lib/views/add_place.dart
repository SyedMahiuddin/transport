import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:transport/Controller/map_controller.dart';
import 'package:transport/Repository/map_repo.dart';
import 'package:transport/customs/color_helper.dart';
import 'package:transport/models/marker_model.dart';
class AddPlacePopup extends StatefulWidget {
  @override
  _AddPlacePopupState createState() => _AddPlacePopupState();
}

class _AddPlacePopupState extends State<AddPlacePopup> {
  String? selectedImage;
  String? selectedImageMarker;
  int selectedPlace=-1;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  MapController mapController=Get.put(MapController());

  void _pickImage() async {
    selectedImageMarker=null;
    selectedPlace=-1;
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedImage = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Place Marker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      mapController.addingPlace.value=false;
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap:(){
                        setState(() {
                          titleController.text="Cafe";
                          descriptionController.text="Coffee time";
                          selectedPlace=0;
                          selectedImageMarker='assets/images/cafeMark.png';
                        });
              },
                        child: _buildSuggestionBox('Cafe', 'assets/images/cafeMark.png',selectedPlace==0)),
                    SizedBox(width: 10.w),
                    InkWell(
                        onTap:(){
                          setState(() {
                            titleController.text="Police";
                            descriptionController.text="Police noticed";
                            selectedPlace=1;
                            selectedImageMarker='assets/images/libraryMark.png';
                          });
                        },
                        child: _buildSuggestionBox('Police', 'assets/images/libraryMark.png',selectedPlace==1)),
                    SizedBox(width: 10.w),
                    InkWell(
                        onTap:(){
                          setState(() {
                            titleController.text="Library";
                            descriptionController.text="Reading place";
                            selectedPlace=2;
                            selectedImageMarker='assets/images/libraryMark.png';
                          });
                        },
                        child: _buildSuggestionBox('BookShop', 'assets/images/libraryMark.png',selectedPlace==2)),
                    SizedBox(width: 10.w),
                    InkWell(
                        onTap:(){
                          setState(() {
                            titleController.text="Danger";
                            descriptionController.text="Suspicious place";
                            selectedPlace=3;
                            selectedImageMarker='assets/images/dangerMark.png';
                          });
                        },
                        child: _buildSuggestionBox('Danger', 'assets/images/dangerMark.png',selectedPlace==3)),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child:selectedImageMarker!=null?Image.asset(selectedImageMarker!): selectedImage == null
                      ? Icon(Icons.add_a_photo, color: Colors.white, size: 50.sp):
                      Image.file(File(selectedImage!), fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: ()  {
                  print("Submitting");
                  LocationModel location=
                  LocationModel(title: titleController.text,
                      description: descriptionController.text,
                      imageIcon: "", geopoint: mapController.longPickedPoint);
                  print("---  :${location.title}");
                   MapRepository().addToFirestore(location, selectedImageMarker??selectedImage!);
                  mapController.addingPlace.value=false;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionBox(String label, String iconPath, bool isSelected ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected?ColorHelper.secondryTheme: Colors.grey[700],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 24.w, height: 24.h),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
