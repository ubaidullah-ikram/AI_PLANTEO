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

  void loadSplashInterAd(BuildContext context) async {
    log('fn starts');

    // 2 sec splash delay
    try {
      if (!Get.find<ProScreenController>().isUserPro.value) {
        if (Platform.isIOS) {
          log('its ios inter ad check');
          iosInterAd(context);
        } else {
          log('its android inter ad check');
          androidInterAd(context);
        }
      } else {
        log('===>  User is Pro isko jany do');
        _goNext();
      }
    } catch (e) {
      log('❌ Exception in loadSplashInterAd: $e');
      _goNext();
    }

    // ✅ Hard timeout
    _splashTimer = Timer(const Duration(seconds: 3), () {
      if (!_navigated) {
        log('⏰ Timeout reached → navigating');
        _goNext();
      }
    });
  }

  androidInterAd(BuildContext context) {
    log(
      'android inter ad ${RemoteConfigService().intersitial_ads_for_android} from config',
    );
    if (RemoteConfigService().intersitial_ads_for_android) {
      AdManager.loadInterstitialAd(
        onAdLoaded: () {
          if (_navigated) {
            // agar already navigate ho gaya to ad ignore kar do
            AdManager.disposeInterstitial();
            return;
          }
          log('✅ Interstitial Loaded in Splash');
          _showAd();
        },
        onAdFailedToLoad: (error) {
          log('❌ Interstitial failed to load: $error');
          _goNext();
        },
        context: context,
      );
    } else {
      log('splash disable from remote config');
      _goNext();
    }
  }

  iosInterAd(BuildContext context) {
    log(
      'ios inter ad ${RemoteConfigService().intersitial_ads_for_ios} from config',
    );
    if (RemoteConfigService().intersitial_ads_for_ios) {
      AdManager.loadInterstitialAd(
        onAdLoaded: () {
          if (_navigated) {
            // agar already navigate ho gaya to ad ignore kar do
            AdManager.disposeInterstitial();
            return;
          }
          log('✅ Interstitial Loaded in Splash');
          _showAd();
        },
        onAdFailedToLoad: (error) {
          log('❌ Interstitial failed to load: $error');
          _goNext();
        },
        context: context,
      );
    } else {
      log('splash disable from remote config');
      _goNext();
    }
  }

  void _showAd() {
    AdManager.showInterstitialAd(
      onDismiss: () async {
        log('🚪 Ad dismissed → next screen');

        _goNext();
      },
      onAddFailedToShow: () async {
        log('❌ Failed to show Ad → next screen');

        _goNext();
      },
    );
  }

  // final config = RemoteConfigService().freeQueryConfig;

  // String kFreeQueriesKey = 'remaining_queries';
  // int kInitialFreeQueries = RemoteConfigService().freeQueryConfig.freeLimit;
  // int kInitialFreeQueries = RemoteConfigService().freeUserCredits;

  bool islogin = false;
  void _goNext() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (_navigated) return;
    _navigated = true;
    await trackCompletedResult();
    _splashTimer?.cancel();
    AdManager.disposeInterstitial(); // ✅ ensure ad cancel/dispose
    // ✅ Give 10 free queries first time
    if (!Get.find<ProScreenController>().isUserPro.value) {
      QueryManager.initialize();
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
    AdManager.disposeInterstitial(); // ✅ cleanup on destroy
    super.onClose();
  }
}
