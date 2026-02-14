import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/services/admanager_services.dart';
import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/diagnose_view/daignose_screen_camera.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_result_screen.dart';
import 'package:plantify/view/light_meter/light_meter_sc.dart';
import 'package:plantify/view/my_garden_view/my_garden_screen.dart';
import 'package:plantify/view/plantio_expert_chat_sc/plant_chat_screen.dart';
import 'package:plantify/view/pro_screen/pro_screen.dart';
import 'package:plantify/view/reminders_view/reminder_view.dart';
import 'package:plantify/view/setting_sc/setting_screen.dart';
import 'package:plantify/view_model/api_controller/api_controller.dart';
import 'package:plantify/view_model/camera_controller/custom_camera_controller.dart';
import 'package:plantify/view_model/identify_plant_controller/identify_plant_controller.dart';
import 'package:plantify/view_model/mushroom_controller/mushroom_controller.dart';
import 'package:plantify/view_model/my_garden_controller/my_garden_controller.dart';
import 'package:plantify/view_model/pro_screen_controller/pro_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cameraCtrl = Get.put(CustomCamerController());
  var mygardenController = Get.put(MyGardenController());
  PlantIdentifierController _identifierController = Get.put(
    PlantIdentifierController(),
    permanent: true,
  );
  MushroomIdentificationController _mushroomIdentificationController = Get.put(
    MushroomIdentificationController(),
  );
  DiagnoseApiController _diagnoseApiController = Get.put(
    DiagnoseApiController(),
  );
  Future<void> _launchURL(String urlN) async {
    final Uri url = Uri.parse(urlN);
    await launchUrl(url);
  }

  Future<void> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    if (int.parse(buildNumber) < RemoteConfigService().force_update_version) {
      log('update require');
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Update Required"),
            content: Text("Please update app to continue"),
            actions: [
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    _launchURL(
                      'https://play.google.com/store/apps/details?id=com.ai.story.generator.novel.script.writer.maker',
                    );
                  } else {
                    _launchURL('https://apps.apple.com/app/id6758267377');
                  }
                  // launchUrl(Uri.parse(appStoreLink));
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      log('not require');
    }
    print("Version: $version");
    print("Build Number: $buildNumber");
  }

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Reminder',
      'icon': AppImages.reminder_icon, // apna icon path
      'color': Color(0xffC2DFD5),
    },
    {
      'title': 'Light Meter',
      'icon': AppImages.light_meter_icon, // apna icon path
      'color': Color(0xffFFF4D0),
    },
    {
      'title': 'My Garden',
      'icon': AppImages.my_garden_icon, // apna icon path
      'color': Color(0xffC6D8B9),
    },
  ];

  DateTime? _lastBackPressed;
  bool isBannerAdLoaded = false;
  bool inbannerForBottom = false;

  bool _isAdInitialized = false;
  // ✅ Har controller ki apni banner ad
  BannerAd? bannerAd;

  void _loadBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );
    bannerAd = BannerAd(
      adUnitId: AdIds.bannerAdIdId,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner Loaded");
          setState(() {
            isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Failed: $error");
          setState(() {
            isBannerAdLoaded = false;
          });
        },
      ),
    );
    bannerAd!.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isAdInitialized) {
      if (RemoteConfigService().banner_ads_for_IOS ||
          RemoteConfigService().banner_ads_for_android) {
        if (!Get.find<ProScreenController>().isUserPro.value) {
          _loadBannerAd();
        }
      }
      _isAdInitialized = true;
    }
  }

  @override
  void dispose() {
    AdManager.disposeBanner(bannerAd);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();

        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
          _lastBackPressed = now;

          Fluttertoast.showToast(msg: 'press again to exit');

          return false;
        }

        return true;
      },
      child: Scaffold(
        bottomNavigationBar: isBannerAdLoaded
            ? SizedBox(
                width: bannerAd!.size.width.toDouble(),
                height: bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: bannerAd!),
              )
            : SizedBox(),
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: Color(0xffF9F9F9),
          surfaceTintColor: Color(0xffF9F9F9),
          automaticallyImplyLeading: false,
          title: Row(
            children: [SvgPicture.asset(AppIcons.home_logo, height: 24)],
          ),
          actions: [
            Obx(
              () => Get.find<ProScreenController>().isUserPro.value
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        Get.to(() => PlanteoProScreen());
                      },
                      child: Container(
                        height: 30,
                        width: 94,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.themeColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: SvgPicture.asset(
                                color: Colors.white,
                                AppIcons.pro_icon_white,
                                height: 14,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Upgrade',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Get.to(() => SettingScreen());
              },
              child: SvgPicture.asset(AppIcons.setting, height: 24),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                // Text(RemoteConfigService().freeQueryConfig.freeLimit.toString()),
                // Image.asset(AppImages.home_first_tool),
                GestureDetector(
                  onTap: () {
                    if (!Get.find<ProScreenController>().isUserPro.value) {
                      plantChatInterAd();
                    } else {
                      Get.to(() => PlanteoExpertScreen());
                    }
                  },
                  child: Container(
                    height: 155,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      // color: Colors.green,
                      image: DecorationImage(
                        alignment: Alignment(0, -0.7),
                        image: AssetImage(AppImages.home_first_tool),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 130),
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.h(40)),
                          Row(
                            children: [
                              Text(
                                'Ask Planteo AI',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff216E49),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Instant plant & \nfarming solutions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.w700,
                                    color: Color(0xff797979),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                // TextButton(
                //   onPressed: () => throw Exception(),
                //   child: const Text("Throw Test Exception"),
                // ),
                supportToolCard(
                  "Identify Plants",
                  "Snap a photo and instantly discover the name, type, and details of any plant.",
                  AppImages.identify_plant,
                  Color(0xffC2DFD5),
                  0,
                ),
                supportToolCard(
                  "Diagnose Plants",
                  "Find out what’s wrong with your plant and get fixes to help it recover.",
                  AppImages.diagnose_plant,
                  Color(0xffFFF4D0),
                  1,
                ),
                supportToolCard(
                  "Identify Mushroom",
                  "Identify mushrooms with a quick photo and get reliable information instantly.",
                  AppImages.mushroom,
                  Color(0xffC6D8B9),
                  2,
                ),

                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Monitor & Maintain',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 94,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            // Card click action
                            if (index == 0) {
                              Get.to(
                                () => MyGardenScreen(isfromReminder: true),
                              );
                              // Get.to(() => ReminderScreen(isfromEdit: false));
                            } else if (index == 2) {
                              Get.to(() => MyGardenScreen());
                            } else {
                              Get.to(() => LightMeterScreen());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            width: 130,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffE0E0E0)),
                              color: card['color'],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image/Icon
                                Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Image.asset(
                                    card['icon'],
                                    height: 50,
                                    // fit: BoxFit.cover,
                                    // width: 50,
                                    // color: Colors.amber,
                                  ),
                                ),
                                SizedBox(height: 6),
                                // Text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 12),
                                    Text(
                                      card['title'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    // SizedBox(width: 8),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      // color: Colors.black54,
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget supportToolCard(
    String toolNAme,
    String toolDesc,
    String toolImg,
    Color cardColor,
    int index,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            if (Get.find<ProScreenController>().isUserPro.value) {
              navigateToToolScreen(index);
              return;
            }
            // Remote Config check
            bool showInterstitial = false;
            if (Platform.isAndroid) {
              showInterstitial =
                  RemoteConfigService().intersitial_ads_for_android;
            } else if (Platform.isIOS) {
              showInterstitial = RemoteConfigService().intersitial_ads_for_ios;
            }
            // Tool-specific key for SharedPreferences
            String toolKey = 'tool_${index}_click_count';
            int clickCount = prefs.getInt(toolKey) ?? 0;
            clickCount++; // increment current click
            await prefs.setInt(toolKey, clickCount);
            // Check if ad should show → first click or every 3rd click after
            if (showInterstitial &&
                (clickCount == 1 || (clickCount - 1) % 3 == 0)) {
              // Show loading dialog
              showDialog(
                context: Get.context!,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    content: Row(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(width: 15),
                        Text("Loading Ad..."),
                      ],
                    ),
                  );
                },
              );

              // Load Interstitial Ad
              AdManager.loadInterstitialAd(
                context: Get.context!,
                onAdLoaded: () {
                  Navigator.of(Get.context!).pop(); // hide loading
                  AdManager.showInterstitialAd(
                    onDismiss: () {
                      navigateToToolScreen(index);
                    },
                  );
                },
                onAdFailedToLoad: () {
                  Navigator.of(Get.context!).pop(); // hide loading
                  navigateToToolScreen(index);
                },
              );
            } else {
              // Direct navigate if ad not needed
              navigateToToolScreen(index);
            }
            // if (index == 0) {
            //   // identifier
            //   Get.to(
            //     () =>
            //         DiagnosePlantScreen(isfromHome: true, isfromIdentify: true),
            //   );
            //   // Get.to(() => PlanteoExpertScreen());
            // } else if (index == 1) {
            //   // diagnose
            //   Get.to(
            //     () => DiagnosePlantScreen(
            //       isfromHome: true,
            //       isfromIdentify: false,
            //     ),
            //   );
            // } else if (index == 2) {
            //   /// mushroom
            //   Get.to(
            //     () => DiagnosePlantScreen(
            //       isfromHome: true,
            //       isfromIdentify: true,
            //       isfromMushroom: true,
            //     ),
            //   );
            //   // Get.to(() => PlanteoExpertScreen());
            // }
          },
          child: SizedBox(
            height: 105,
            child: Center(
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        toolNAme,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff054023),
                        ),
                      ),
                      // Text(
                      //   toolDesc,
                      //   style: TextStyle(
                      //     fontSize: 10,
                      //     fontWeight: FontWeight.w700,
                      //     letterSpacing: 0,

                      //     color: Color(0xff797979),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: index == 2 ? 5 : -10,
          top: index == 2 ? 0 : -10,
          child: Image.asset(
            toolImg,
            height: index == 2 ? 80 : 110,
            // fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  void navigateToToolScreen(int index) {
    if (index == 0) {
      // identifier
      Get.to(() => DiagnosePlantScreen(isfromHome: true, isfromIdentify: true));
    } else if (index == 1) {
      // diagnose
      Get.to(
        () => DiagnosePlantScreen(isfromHome: true, isfromIdentify: false),
      );
    } else if (index == 2) {
      /// mushroom
      Get.to(
        () => DiagnosePlantScreen(
          isfromHome: true,
          isfromIdentify: true,
          isfromMushroom: true,
        ),
      );
    }
  }

  plantChatInterAd() async {
    setState(() {});

    bool showInterstitial = false;
    if (Platform.isAndroid) {
      showInterstitial = RemoteConfigService().intersitial_ads_for_android;
    } else if (Platform.isIOS) {
      showInterstitial = RemoteConfigService().intersitial_ads_for_ios;
    }

    // Check if we should show interstitial only once in 24 hr
    if (showInterstitial) {
      final prefs = await SharedPreferences.getInstance();
      final lastAdTimeMillis = prefs.getInt('last_interstitial_ad_time') ?? 0;
      final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
      const duration24hr = 24 * 60 * 60 * 1000;

      if (currentTimeMillis - lastAdTimeMillis >= duration24hr) {
        // ✅ 24 hr passed or first time → show ad
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 15),
                  Text("Loading Ad..."),
                ],
              ),
            );
          },
        );

        AdManager.loadInterstitialAd(
          context: Get.context!,
          onAdLoaded: () {
            Navigator.of(Get.context!).pop(); // hide loading
            AdManager.showInterstitialAd(
              onDismiss: () async {
                // save current timestamp
                await prefs.setInt(
                  'last_interstitial_ad_time',
                  currentTimeMillis,
                );
                Get.to(() => PlanteoExpertScreen());
              },
            );
          },
          onAdFailedToLoad: () {
            Navigator.of(Get.context!).pop(); // hide loading
            Get.to(() => PlanteoExpertScreen());
          },
        );
      } else {
        // ⏳ 24 hr not passed → skip ad
        Get.to(() => PlanteoExpertScreen());
      }
    } else {
      // Remote Config off → navigate directly
      Get.to(() => PlanteoExpertScreen());
    }
  }
}
