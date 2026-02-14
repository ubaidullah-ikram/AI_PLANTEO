import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/services/admanager_services.dart';
import 'package:plantify/services/query_manager_services.dart';
import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/home_screen/home_screen.dart';
import 'package:plantify/view/instruction_screen/onb_instruction_screen.dart';
import 'package:plantify/view_model/pro_screen_controller/pro_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  Timer? _splashTimer;
  bool _navigated = false; // ensure ek hi dafa navigate ho

  var second_app_opened = "second_app_opened";
  Future<void> trackCompletedResult() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(second_app_opened) ?? 0;
    count++;
    await prefs.setInt(second_app_opened, count);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void _showAppOpenAd() {
    AdManager.showAppOpenAd(
      onDismiss: () async {
        log('🚪 AppOpenAd dismissed → next screen');
        // _goNext();
      },
    );
  }

  void loadSplashAppOpenAd(BuildContext context) async {
    log('fn starts');
    _showLoadingDialog(context); // ✅ show loader

    try {
      if (!Get.find<ProScreenController>().isUserPro.value) {
        bool isAdEnabled = Platform.isIOS
            ? RemoteConfigService().app_open_Ads_for_IOS
            : RemoteConfigService().app_open_Ads_for_android;

        if (isAdEnabled) {
          AdManager.loadAppOpenAd(
            onAdLoaded: () {
              if (_navigated) {
                AdManager.appOpenAd?.dispose();
                return;
              }

              log('✅ AppOpenAd Loaded in Splash');
              Future.delayed(Duration(milliseconds: 400), () {
                _showAppOpenAd();
              });
            },
            onAdFailedToLoad: () {
              log('❌ AppOpenAd failed');
              _goNext();
            },
          );
        } else {
          log('🚫 splash ad disabled from remote config');
          _goNext();
        }
      } else {
        log('===> User is Pro → skip ad');
        _goNext();
      }
    } catch (e) {
      log('❌ Exception in loadSplashAppOpenAd: $e');
      _goNext();
    }

    _splashTimer = Timer(const Duration(seconds: 3), () {
      if (!_navigated) {
        log('⏰ Timeout reached → navigating');
        _goNext();
      }
    });
  }

  bool islogin = false;
  void _goNext() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _hideLoadingDialog();
    log('just before _navigated');
    if (_navigated) return;
    _navigated = true;
    log('just after _navigated');
    await trackCompletedResult();
    _splashTimer?.cancel();
    AdManager.appOpenAd?.dispose(); // ✅ ensure ad cancel/dispose
    // ✅ Give 10 free queries first time
    if (!Get.find<ProScreenController>().isUserPro.value) {
      log('the query called');
      QueryManager.downgradeToFreeIfNeeded();
    } else {
      log('message not');
    }

    bool islogin = sp.getBool('isInitialized') ?? false;
    if (islogin) {
      Get.off(() => HomeScreen());
    } else {
      Get.off(() => InstructionScreens());
      // Get.off(() => OnboardingScreen());
    }
  }

  @override
  void onClose() {
    _splashTimer?.cancel();
    AdManager.appOpenAd?.dispose(); // ✅ cleanup on destroy

    super.onClose();
  }
}

void _showLoadingDialog(BuildContext context) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                "Please wait...\nAd is loading",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void _hideLoadingDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}
