import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/firebase_options.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/services/notification_service.dart';
import 'package:plantify/services/query_manager_services.dart';
import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/services/revnue_cat_services.dart';
import 'package:plantify/view/splash_view/splash_sc.dart';
import 'package:plantify/view_model/plant_expert_chatController/plant_expert_chatController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantify/view_model/pro_screen_controller/pro_screen_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  Get.put(PlantExpertChatController(), permanent: true);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  try {
    await RevenueCatHelper().initPlatformState();
    log('revnue cat done');
  } catch (e) {
    log('error while in revnue cat');
  }
  Get.put(ProScreenController());
  try {
    await RemoteConfigService().init();
  } catch (e) {}

  QueryManager.initialize();
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
