import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/models/mushroom_db_model.dart';
import 'package:plantify/models/mushroom_model.dart';
import 'package:plantify/models/plant_idenfier_model.dart';
import 'package:plantify/models/plant_identify_db_model.dart';
import 'package:plantify/view/diagnose_view/daignose_screen_camera.dart';
import 'package:plantify/view/identify_plant_view/identify_plant_result_sc.dart';
import 'package:plantify/view/mushroom_result_sc/mushroom_result_sc.dart';
import 'package:plantify/view/my_garden_view/widgets/plant_bottom_sheet_widget.dart';
import 'package:plantify/view/reminders_view/reminder_view.dart';
import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';
import 'package:plantify/view_model/identify_plant_controller/identify_plant_controller.dart';
import 'package:plantify/view_model/mushroom_controller/mushroom_controller.dart';
import 'package:plantify/view_model/my_garden_controller/my_garden_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class MyGardenScreen extends StatefulWidget {
  bool isfromReminder;
  MyGardenScreen({super.key, this.isfromReminder = false});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen>
    with TickerProviderStateMixin {
  var mygardenController = Get.find<MyGardenController>();
  var reminderController = Get.put(ReminderController());
  late AnimationController _controller;

  // Track expanded reminders by type
  Map<String, bool> expandedReminders = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    mygardenController.loadPlants();
    mygardenController.loadMushrooms();
    if (widget.isfromReminder) {
      mygardenController.selectFilter.value = 2;
    }

    // Load reminders on init
    reminderController.loadAllReminders();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Group reminders by type
  Map<String, List<ReminderModel>> _groupRemindersByType() {
    Map<String, List<ReminderModel>> grouped = {};

    for (var reminder in reminderController.allReminders) {
      if (!grouped.containsKey(reminder.reminderType)) {
        grouped[reminder.reminderType] = [];
      }
      grouped[reminder.reminderType]!.add(reminder);
    }

    return grouped;
  }

  // Get icon for reminder type
  String _getIconForReminderType(String type) {
    switch (type.toLowerCase()) {
      case 'watering':
        return AppIcons.watering;
      case 'misting':
        return AppIcons.misting;
      case 'rotating':
        return AppIcons.rotating;
      default:
        return AppIcons.watering;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 18),
        ),
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        centerTitle: false,
        title: Text(
          'My Garden',
          style: TextStyle(
            fontFamily: AppFonts.sfPro,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mygardenController.gardenFilterList.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Center(
                            child: GestureDetector(
                              onTap: () {
                                mygardenController.selectFilter.value = index;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffE0E0E0)),
                                  color:
                                      mygardenController.selectFilter.value ==
                                          index
                                      ? Colors.white
                                      : Color(0xffF3F3F3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                height: 34,
                                child: Center(
                                  child: Text(
                                    mygardenController.gardenFilterList[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          mygardenController
                                                  .selectFilter
                                                  .value ==
                                              index
                                          ? AppColors.themeColor
                                          : Color(0xffA2ABA8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => mygardenController.selectFilter.value == 1
                        ? Expanded(
                            child: Obx(() {
                              final mushroom = mygardenController.mushrooms;

                              if (mushroom.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.local_florist,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'No mushroom added yet',
                                        style: TextStyle(
                                          fontFamily: AppFonts.sfPro,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => DiagnosePlantScreen(
                                              isfromHome: true,
                                              isfromIdentify: true,
                                              isfromMushroom: true,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          height: 54,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.themeColor,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'Add Mushroom',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'SFPRO',
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: mushroom.length,
                                itemBuilder: (context, index) {
                                  return _buildMushroomWidget(mushroom[index]);
                                },
                              );
                            }),
                          )
                        : mygardenController.selectFilter.value == 2
                        ? _buildRemindersSection()
                        : Expanded(
                            child: Obx(() {
                              final plants = mygardenController.plants;

                              if (plants.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.local_florist,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
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

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: plants.length,
                                itemBuilder: (context, index) {
                                  return _plantcardWidget(plants[index]);
                                },
                              );
                            }),
                          ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Obx(
                () => mygardenController.selectFilter.value == 1
                    ? SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          if (mygardenController.selectFilter.value == 0) {
                            log('add plant pressed');
                          } else {
                            Get.to(
                              () => ReminderScreen(isfromEdit: false),
                            )?.then((_) {
                              reminderController.loadAllReminders();
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          height: 54,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.themeColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text(
                                mygardenController.selectFilter.value == 0
                                    ? "Add Plant"
                                    : 'Add Reminder',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'SFPRO',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============= REMINDERS SECTION =============
  Widget _buildRemindersSection() {
    return Expanded(
      child: Obx(() {
        if (reminderController.allReminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No Reminders Yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.themeColor,
                  ),
                ),
                Text(
                  'Add a reminder to get started',
                  style: TextStyle(fontSize: 14, color: Color(0xff797979)),
                ),
              ],
            ),
          );
        }

        // Group reminders by type
        Map<String, List<ReminderModel>> groupedReminders =
            _groupRemindersByType();

        return ListView.builder(
          itemCount: groupedReminders.length,
          itemBuilder: (context, index) {
            String reminderType = groupedReminders.keys.elementAt(index);
            List<ReminderModel> reminders =
                groupedReminders[reminderType] ?? [];

            // Initialize if not exists
            if (!expandedReminders.containsKey(reminderType)) {
              expandedReminders[reminderType] = false;
            }

            return _reminderCardWidget(
              reminderType: reminderType,
              reminders: reminders,
            );
          },
        );
      }),
    );
  }

  // ============= REMINDER CARD WIDGET =============
  Widget _reminderCardWidget({
    required String reminderType,
    required List<ReminderModel> reminders,
  }) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xffE0E0E0), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              GestureDetector(
                onTap: () {
                  setState(() {
                    expandedReminders[reminderType] =
                        !(expandedReminders[reminderType] ?? false);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reminder Type with Icon
                    Row(
                      children: [
                        SvgPicture.asset(
                          _getIconForReminderType(reminderType),
                          height: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          reminderType,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.themeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // Count and Chevron
                    Row(
                      children: [
                        Text(
                          '${reminders.length} Plant${reminders.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xffA2ABA8),
                          ),
                        ),
                        SizedBox(width: 5),
                        AnimatedRotation(
                          turns: (expandedReminders[reminderType] ?? false)
                              ? 0.5
                              : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            CupertinoIcons.chevron_down,
                            size: 18,
                            color: Color(0xffA2ABA8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Expanded Content
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: (expandedReminders[reminderType] ?? false)
                    ? Column(
                        children: [
                          Divider(color: Color(0xffE6E6E6)),
                          ...reminders.map((reminder) {
                            return _reminderListItem(reminder);
                          }).toList(),
                        ],
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============= REMINDER LIST ITEM =============
  Widget _reminderListItem(ReminderModel reminder) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(
              () =>
                  ReminderScreen(isfromEdit: true, editReminderId: reminder.id),
            )?.then((_) {
              reminderController.loadAllReminders();
              setState(() {});
            });
          },
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              AppImages.garden_image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            reminder.plantName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.themeColor,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            '${reminder.hour}:${reminder.minute.toString().padLeft(2, '0')} ${reminder.period}',
            style: TextStyle(color: Color(0xffA2ABA8), fontSize: 12),
          ),
          trailing: PopupMenuButton(
            onSelected: (value) async {
              if (value == 'delete') {
                // Delete confirmation
                Get.dialog(
                  AlertDialog(
                    title: Text('Delete Reminder?'),
                    content: Text(
                      'Are you sure you want to delete this reminder?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await reminderController.deleteReminder(reminder.id);
                          reminderController.loadAllReminders();
                          setState(() {});
                          // Get.back();
                          Navigator.pop(context);
                          Get.snackbar(
                            'Success',
                            'Reminder deleted successfully',
                          );
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Color(0xffE6E6E6)),
      ],
    );
  }

  // ============= PLANT CARD WIDGET =============
  Widget _plantcardWidget(SavedPlantModel plant) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Parse response

            final finalData = PlantIdentifierData(
              plantName: plant.plantName,
              scientificName: plant.scientificName,
              description: plant.description,
              characteristics: plant.characteristics,
              carePoints: plant.carePoints,
              imagePath: base64Encode(plant.image),
              confidence: plant.confidence,
            );

            // Set data BEFORE navigating
            Get.find<PlantIdentifierController>().identifierData.value =
                finalData;

            // Navigate to result screen
            // Get.off(() => PlantIdentifierResultScreen());
            Get.to(() => PlantIdentifierResultScreen(isfromSavedPlant: true));
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
                    height: 110,
                    width: 100,
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
                        plant.scientificName,
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                      Text(
                        "${plant.plantName} Plant",
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Divider(
                        height: 1,
                        color: Color(0xffE6E6E6),
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: -5,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Color(0xffF9F9F9),
                context: context,
                builder: (_) => PlantBottomSheetWidget(),
              );
            },
            icon: Icon(Icons.more_horiz, size: 24),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 9,
          child: GestureDetector(
            onTap: () {
              mygardenController.selectFilter.value = 2;
            },
            child: Container(
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.themeColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppIcons.clock, width: 14, height: 14),
                  SizedBox(width: 6),
                  Text(
                    'Add Reminder',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============= EMPTY WIDGET =============
  Widget _buildMushroomWidget(SavedMushroomModel mushroom) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            log('mushroom history');
            final finalData = MushroomIdentificationData(
              mushroomName: mushroom.mushroomName,
              scientificName: mushroom.scientificName,
              edibility: mushroom.edibility,
              description: mushroom.description,
              characteristics: mushroom.characteristics,
              habitat: mushroom.habitat,
              lookAlikes: mushroom.lookAlikes,
              imagePath: base64Encode(mushroom.image),
              confidence: mushroom.confidence,
              isIdentified: true,
            );

            Get.find<MushroomIdentificationController>().mushroomData.value =
                finalData;

            Get.to(
              () => MushroomIdentificationResultScreen(isfromHistory: true),
            );
            // Get.to(
            //   () => PlantIdentifierResultScreen(
            //     isfromSavedPlant: true,
            //     plant: plant,
            //   ),
            // );
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
                    mushroom.image,
                    height: 110,
                    width: 100,
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
                        mushroom.scientificName,
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        mushroom.mushroomName,
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 16,
                          color: AppColors.themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${mushroom.mushroomName}",
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Divider(
                        height: 1,
                        color: Color(0xffE6E6E6),
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: -5,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Color(0xffF9F9F9),
                context: context,
                builder: (_) => PlantBottomSheetWidget(),
              );
            },
            icon: Icon(Icons.more_horiz, size: 24),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 9,
          child: GestureDetector(
            onTap: () {
              mygardenController.selectFilter.value = 2;
            },
            child: Container(
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.themeColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppIcons.clock, width: 14, height: 14),
                  SizedBox(width: 6),
                  Text(
                    'Add Reminder',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    // return Padding(
    //   padding: EdgeInsets.only(top: Get.height * .28),
    //   child: Column(
    //     children: [
    //       Text(
    //         'Your Mushroom List Is Empty',
    //         style: TextStyle(
    //           fontSize: 22,
    //           fontWeight: FontWeight.w600,
    //           color: AppColors.themeColor,
    //         ),
    //       ),
    //       Text(
    //         'Start exploring! Identify or diagnose \nany plant to see it appear here.',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 14, color: Color(0xff797979)),
    //       ),
    //       SizedBox(height: 20),
    //       GestureDetector(
    //         onTap: () {
    //           Get.to(
    //             () => DiagnosePlantScreen(
    //               isfromHome: true,
    //               isfromIdentify: true,
    //               isfromMushroom: true,
    //             ),
    //           );
    //         },
    //         child: Container(
    //           height: 54,
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             color: AppColors.themeColor,
    //             borderRadius: BorderRadius.circular(16),
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Icon(Icons.add, color: Colors.white, size: 18),
    //               Text(
    //                 ' Add Mushroom',
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   color: Colors.white,
    //                   fontFamily: 'SFPRO',
    //                   fontWeight: FontWeight.w800,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
