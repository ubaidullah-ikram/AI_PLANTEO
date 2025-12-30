import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/firebase_options.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/splash_view/splash_sc.dart';
import 'package:plantify/view_model/plant_expert_chatController/plant_expert_chatController.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(PlantExpertChatController(), permanent: true);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GetMaterialApp(
      theme: ThemeData(fontFamily: AppFonts.sfPro),
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}
