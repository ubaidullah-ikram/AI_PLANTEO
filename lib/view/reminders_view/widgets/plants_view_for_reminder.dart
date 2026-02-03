import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/models/plant_identify_db_model.dart';
import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';
import 'package:plantify/view_model/my_garden_controller/my_garden_controller.dart';

class PlantsViewForReminder extends StatefulWidget {
  const PlantsViewForReminder({super.key});

  @override
  State<PlantsViewForReminder> createState() => _PlantsViewForReminderState();
}

class _PlantsViewForReminderState extends State<PlantsViewForReminder> {
  var mygardenController = Get.find<MyGardenController>();

  var controller = Get.find<ReminderController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Plants'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() {
              final plants = mygardenController.plants;

              if (plants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: context.height * 0.4),
                      Icon(Icons.local_florist, size: 48, color: Colors.grey),

                      Text(
                        'No plants added yet',
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: plants.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _plantcardWidget(plants[index], index);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _plantcardWidget(SavedPlantModel plant, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Parse response
            log('message ${plant.plantName}');
            controller.selectedPlant.value = plant.plantName;
            controller.reminderImage = plant.image;
            Get.back();
            // final finalData = PlantIdentifierData(
            //   plantName: plant.plantName,
            //   scientificName: plant.scientificName,
            //   description: plant.description,
            //   characteristics: plant.characteristics,
            //   carePoints: plant.carePoints,
            //   imagePath: base64Encode(plant.image),
            //   confidence: plant.confidence,
            // );

            // // Set data BEFORE navigating
            // Get.find<PlantIdentifierController>().identifierData.value =
            //     finalData;

            // // Navigate to result screen
            // // Get.off(() => PlantIdentifierResultScreen());
            // Get.to(() => PlantIdentifierResultScreen(isfromSavedPlant: true));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xffE0E0E0)),
            ),
            margin: EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    plant.image,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        plant.plantName,
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 16,
                          color: AppColors.themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
