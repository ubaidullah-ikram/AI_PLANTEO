import 'package:flutter/material.dart';
import 'package:plantify/constant/app_images.dart';

class LightMeterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.light_meter_bg), // <-- YOUR IMAGE PATH
            fit: BoxFit.fill, // <-- FULL SCREEN COVER
          ),
        ),
        child: Center(
          child: Text(
            "Hello Background!",
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
