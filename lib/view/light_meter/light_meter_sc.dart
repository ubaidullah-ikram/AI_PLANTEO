// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:plantify/constant/app_icons.dart';
// import 'package:plantify/constant/app_images.dart';
// import 'package:svg_flutter/svg_flutter.dart';

// class LightMeterScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppImages.light_meter_bg), // <-- YOUR IMAGE PATH
//             fit: BoxFit.fill, // <-- FULL SCREEN COVER
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                 child: Text(
//                   'Position your phone at the area where you want to place the plant',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//               SizedBox(height: Get.height * 0.55),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SvgPicture.asset(AppIcons.error_lightMeter, height: 26),
//                     SizedBox(width: 8),
//                     Flexible(
//                       child: Text(
//                         'Not enough light for growing plant',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   children: [
//                     SvgPicture.asset(AppIcons.reading_lightMeter, height: 26),
//                     SizedBox(width: 8),
//                     Flexible(
//                       child: Text(
//                         'Optimal light value: 460-1184 LUX',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/view_model/lus_meter_controller/lux_meter_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class LightMeterScreen extends StatelessWidget {
  final LightMeterController controller = Get.put(LightMeterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.light_meter_bg),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Position your phone at the area where you want to place the plant',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: Get.height * 0.45),
              // Lux Reading Display
              Obx(
                () => Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  // padding: EdgeInsets.all(30),
                  // decoration: BoxDecoration(
                  //   color: Colors.black.withOpacity(0.2),
                  //   // border: Border.all(
                  //   //   color: controller.statusColor.value,
                  //   //   width: 2,
                  //   // ),
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: Column(
                    children: [
                      Text(
                        '${controller.lightLevel.value.toStringAsFixed(0)} LUX',
                        style: TextStyle(
                          color: controller.statusColor.value,
                          // color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        controller.lightStatus.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: controller.statusColor.value,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Status Messages
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppIcons.error_lightMeter, height: 26),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Low: Below 460 LUX - Not enough light',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.reading_lightMeter, height: 26),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Optimal: 460-1184 LUX - Perfect',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(AppIcons.reading_lightMeter, height: 26),
              //       SizedBox(width: 8),
              //       Flexible(
              //         child: Text(
              //           'High: Above 1184 LUX - May be too bright',
              //           textAlign: TextAlign.start,
              //           style: TextStyle(
              //             color: Colors.red,
              //             fontSize: 14,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
