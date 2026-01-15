// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:plantify/constant/app_colors.dart';
// import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';
// import 'package:svg_flutter/svg_flutter.dart';

// class PreviousCardWidget extends StatefulWidget {
//   const PreviousCardWidget({super.key});

//   @override
//   State<PreviousCardWidget> createState() => _PreviousCardWidgetState();
// }

// class _PreviousCardWidgetState extends State<PreviousCardWidget> {
//   var controller = Get.find<ReminderController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 64,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xffE0E0E0)!, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Previous',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   controller.expanded_previous.value =
//                       !controller.expanded_previous.value;
//                 },
//                 child: Obx(
//                   () => Text(
//                     controller.selected_previous.value,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: controller.selected_previous.value == "Select"
//                           ? Colors.grey
//                           : AppColors.textHeading,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Obx(
//             () => controller.expanded_previous.value == false
//                 ? Container(
//                     height: 110,
//                     child: CupertinoPicker(
//                       itemExtent: 40.0,
//                       scrollController: FixedExtentScrollController(
//                         initialItem: controller.selected_previous_index.value,
//                       ),
//                       // backgroundColor: Color(0xffF3F3F3),
//                       onSelectedItemChanged: (int index) {
//                         controller.selected_previous.value =
//                             controller.previous_list[index];

//                         controller.selected_previous_index.value = index;

//                         print('Selected index: $index');
//                       },
//                       children: List<Widget>.generate(
//                         controller.previous_list.length,
//                         (int index) {
//                           return Center(
//                             child: Text(
//                               controller.previous_list[index],
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w400,
//                                 color:
//                                     controller.selected_previous_index.value ==
//                                         index
//                                     ? AppColors
//                                           .textHeading // center item color
//                                     : Colors.grey,
//                               ), // side items),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   )
//                 : SizedBox.fromSize(),
//           ),
//         ],
//       ),
//     );
//   }
// }
