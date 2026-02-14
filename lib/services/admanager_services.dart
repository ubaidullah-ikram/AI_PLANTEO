import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsShowCallBack {
  void onAdDismissedFullScreenContent();
  void onAdFailedToShowFullScreenContent();
  void onAdShowedFullScreenContent();
  void onAdFailedToLoad();
}

class AdManager {
  late AdsShowCallBack callback;

  static InterstitialAd? interstitialAd;
  static AppOpenAd? appOpenAd;
  static bool isInterstitialAdLoading = false;
  static bool isOpenAppAdLoading = false;
  static NativeAd? nativeAd;
  static bool isNativeAdLoaded = false;

  static void requestConsentForm() {
    // Create a ConsentRequestParameters object.
    final params = ConsentRequestParameters(
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: ["96F02817EE8A9DBEE0B037F65B96A1E8"],
      ),
    );

    // Request an update to consent information on every app launch.
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
          if (error != null) {
            log("Error showing consent form: ${error.message}");
          } else {
            log("Consent form dismissed");
          }
        });
        log("Consent information successfully updated.");
        // Called when consent information is successfully updated.
      },
      (FormError error) {
        log("Error updating consent information: ${error.message} ${error}");
        // Called when there's an error updating consent information.
      },
    );
  }

  static bool _isAdRequestActive = false;
  static void cancelAdRequest() {
    _isAdRequestActive = false;
    disposeInterstitial();
    log('🛑 Ad request cancelled');
  }

  /// Load Interstitial Ad
  static void loadInterstitialAd({
    required Function onAdLoaded,
    required Function onAdFailedToLoad,
    required BuildContext context,
    bool? istoShowLoadingAdAlert,
  }) {
    InterstitialAd.load(
      adUnitId: AdIds.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log("✅ InterstitialAd Loaded");
          interstitialAd = ad;
          // if (istoShowLoadingAdAlert == null) {
          //   // AdLoadingDialog.hide(context);
          // }
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          // if (istoShowLoadingAdAlert == null) {
          //   // AdLoadingDialog.hide(context);
          // }
          onAdFailedToLoad();
          log("❌ InterstitialAd Failed to load: $error");
          interstitialAd = null;
        },
      ),
    );
  }

  static void disposeInterstitial() {
    interstitialAd?.dispose();
    interstitialAd = null;
  }

  /// Show Interstitial Ad
  static void showInterstitialAd({
    Function? onDismiss,
    Function? onAddFailedToShow,
  }) {
    if (interstitialAd == null) {
      log("⚠ InterstitialAd not ready yet");
      onDismiss?.call();

      // loadInterstitialAd(); // try to load again

      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        log("Interstitial dismissed");
        ad.dispose();
        onDismiss?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log("Interstitial failed to show: $error");
        ad.dispose();

        onDismiss?.call();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  static void loadNativeAd({
    required void Function(NativeAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) {
    // if (Get.find<ProScreenController>().isUserPro.value) {
    //   log("🚫 Pro user hai → native add skip");
    //   onAdFailedToLoad;
    //   return;
    // }

    final nativeAd = NativeAd(
      adUnitId: AdIds.nativeAdId, // ✅ test id
      // factoryId:
      //     Platform.isAndroid
      //         ? "listTileMedium"
      //         : "listTileMedium", // ye zaroori hai (UI banane ke liye)
      request: const AdRequest(),
      // ✅ Selection ke hisaab se bhej do

      // customOptions: {"theme": 'girl'},
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          onAdLoaded(ad as NativeAd);
        },

        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(error);
        },
      ),
    );

    nativeAd.load();
  }

  static void showIntAd({required Function() onAdDissmissed}) {
    // if (interstitialAd != null) {
    interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      // Called when the ad showed the full screen content.
      onAdShowedFullScreenContent: (ad) {},
      // Called when an impression occurs on the ad.
      onAdImpression: (ad) {},
      // Called when the ad failed to show full screen content.
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        // AdManager.loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        interstitialAd = null;
        onAdDissmissed();
        ad.dispose();
        // AdManager.loadAd();
      },
      // Called when a click is recorded for an ad.
      onAdClicked: (ad) {},
    );
    interstitialAd!.show();
    // }
  }

  // static bool getOpenAppId() {
  //   return PreferencesService.getBool(AdIds.openAdIDSuccess) ?? false;
  // }
  /// Load AppOpenAd
  static void loadAppOpenAd({
    required Function() onAdLoaded,
    required Function() onAdFailedToLoad,
  }) {
    AppOpenAd.load(
      adUnitId: AdIds.appOpenApAdId, // test id (Android)
      // orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          onAdLoaded();
          log("AppOpenAd Loaded ✅");
          appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad();
          log("AppOpenAd Failed to load: $error");
        },
      ),
    );
  }

  /// Show ad (if available)
  static void showAppOpenAd({Function? onDismiss}) {
    if (appOpenAd == null) {
      log("⚠ No AppOpenAd available");
      onDismiss?.call();
      return;
    }

    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        log("Ad dismissed");
        ad.dispose();
        appOpenAd = null;
        // loadAppOpenAd(); // next ad load
        onDismiss?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log("Ad failed to show: $error");
        ad.dispose();
        appOpenAd = null;
        // loadAppOpenAd();
        onDismiss?.call();
      },
    );

    appOpenAd!.show();
    appOpenAd = null;
  }

  static BannerAd? _bannerAd;
  static bool _isAdLoaded = false;

  static BannerAd? loadBannerAd({
    required BuildContext context,
    required Function(BannerAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    BannerAd bannerAd = BannerAd(
      adUnitId: AdIds.bannerAdIdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner Loaded");
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Failed: $error");
          onAdFailedToLoad(error);
        },
      ),
    );

    bannerAd.load();
    return bannerAd;
  }

  static Widget getBannerWidget(BannerAd? bannerAd) {
    if (bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }

  /// Dispose banner
  /// Dispose specific banner
  static void disposeBanner(BannerAd? bannerAd) {
    bannerAd?.dispose();
    debugPrint("🗑️ Banner Disposed");
  }
}

class AdIds {
  static String bannerAdIdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/9214589741"
            : "ca-app-pub-9804021071767799/8769309248"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/2435281174"
      : "ca-app-pub-9804021071767799/6164151617";
  static String interstitialAdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/1033173712"
            : "ca-app-pub-9804021071767799/6143145908"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/4411468910"
      : "ca-app-pub-9804021071767799/4851069945";
  static String appOpenApAdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/9257395921"
            : "ca-app-pub-9804021071767799/5048614136"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/5575463023"
      : "ca-app-pub-9804021071767799/3537988276";
  static String nativeAdId = Platform.isAndroid
      ? kDebugMode
            ? "ca-app-pub-3940256099942544/2247696110"
            : "ca-app-pub-9804021071767799/2614022488"
      : kDebugMode
      ? "ca-app-pub-3940256099942544/3986624511"
      : "ca-app-pub-9804021071767799/7353110205";
}
