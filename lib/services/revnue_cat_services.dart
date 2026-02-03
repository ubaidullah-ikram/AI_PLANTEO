import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantify/view_model/pro_screen_controller/pro_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class InAppCallback {
  void onPurchaseSuccess(BuildContext context);

  void onPurchaseFailure(BuildContext context);

  void onPurchasedRestored(BuildContext context);

  void onPuchaseExpired(BuildContext context);

  void onPurchaseCancelled(BuildContext context);

  void onPurchaseRestoreFailed(BuildContext context);
}

class RevenueCatHelper {
  static const String entitlementIdentifier = "premium";

  List<String> productIdentifiers = Platform.isAndroid
      ? [
          "planteo_weekly_plan", // Play Store / App Store product ID
          "planteo_yearly_plan",
        ]
      : [
          "planteo_weekly_plan", // Play Store / App Store product ID
          "planteo_yearly_plan",
        ];

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(
        "goog_XeBGUinGEWwNszNoMANmdZClNth",
      );
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(
        "appl_ybVsLEvXIGhiZYQllokuvpqLvpV",
      );
    }
    if (configuration != null) {
      await Purchases.configure(configuration);
    }
    // ✅ Listener setup karein
    await setupPurchaseListener();
    log('listner called');
    Get.put(ProScreenController());
    log(
      "message: RevenueCat Initialized: $configuration",
      name: "revenuecat_init",
    );
  }

  Future<void> buyProduct(
    StoreProduct product,
    InAppCallback callable,
    BuildContext context,
  ) async {
    try {
      PurchaseResult purchaseResult = await Purchases.purchaseStoreProduct(
        product,
      );
      CustomerInfo customerInfo = purchaseResult.customerInfo;
      Map<String, EntitlementInfo> entitlementInformation =
          customerInfo.entitlements.all;
      if (entitlementInformation[RevenueCatHelper.entitlementIdentifier] !=
          null) {
        if (entitlementInformation[RevenueCatHelper.entitlementIdentifier]!
            .isActive) {
          if (context.mounted) {
            callable.onPurchaseSuccess(context);
          }
        }
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        if (context.mounted) {
          callable.onPurchaseCancelled(context);
        }
      }
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    bool isSubscriptionActive = false;
    try {
      log('the subscription is checking');

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      log('Customer info fetched: ${customerInfo.toString()}');

      String appUserID = await Purchases.appUserID;
      log('App user id: $appUserID');

      Map<String, EntitlementInfo> entitlementInformation =
          customerInfo.entitlements.all;
      if (entitlementInformation.isEmpty) {
        log('the user is not pro entitlement is empty');
      } else {
        log('Entitlements: $entitlementInformation');

        if (entitlementInformation[RevenueCatHelper.entitlementIdentifier] !=
            null) {
          if (entitlementInformation[RevenueCatHelper.entitlementIdentifier]!
              .isActive) {
            log('the user is pro now');

            // ✅ Expiration date save karein
            final prefs = await SharedPreferences.getInstance();
            final expirationDate =
                entitlementInformation[RevenueCatHelper.entitlementIdentifier]!
                    .expirationDate;
            if (expirationDate != null) {
              await prefs.setString(
                lastExpirationKey,
                DateTime.parse(expirationDate).toIso8601String(),
                // expirationDate.toIso8601String(),
              );
            }

            return true;
          } else {
            log('the user is not pro its credits are');
            return false;
          }
        } else {
          log(
            '⚠️ No entitlement found with key: ${RevenueCatHelper.entitlementIdentifier}',
          );
        }
      }
    } catch (e, st) {
      log('the subscription error $e\n$st');
    }

    return isSubscriptionActive;
  }

  Future<List<Package>> fetchAvailablePackages() async {
    try {
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        // ✅ Return available packages for the current platform (Android/iOS/macOS)
        return offerings.current!.availablePackages;
      } else {
        // ⚠️ No packages available
        return [];
      }
    } on PlatformException catch (e) {
      // ❌ Handle RevenueCat/Platform errors
      print("Error fetching offerings: ${e.message}");
      return [];
    } catch (e) {
      // ❌ Any other error
      print("Unexpected error: $e");
      return [];
    }
  }

  Future<List<StoreProduct>> getProducts() async {
    log("Fetching products...", name: "revenuecat_products");

    try {
      // RevenueCat se products fetch karo
      List<StoreProduct> products = await Purchases.getProducts(
        productIdentifiers,
      );

      // Agar kam az kam 2 products hain to unko swap kar do
      // if (Platform.isAndroid) {
      //   if (products.length >= 2) {
      //     var temp = products[0];
      //     products[0] = products[1];
      //     products[1] = temp;
      //   }
      // }
      log("Products fetched: ${products.length}", name: "revenuecat_products");
      for (var p in products) {
        log("\n  \n   Products: ${p.identifier} → ${p.priceString}\n");
      }

      return products;
    } catch (e) {
      log('error to fetch products $e');
      return [];
    }
  }

  /// Restores purchases and returns whether the user has any active entitlement
  Future<void> restorePurchases(
    BuildContext context,
    InAppCallback callBack,
  ) async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();

      // ✅ Replace with your actual entitlement identifier from RevenueCat Dashboard
      const entitlementId = entitlementIdentifier;
      final entitlement = customerInfo.entitlements.all[entitlementId];
      final isActive = entitlement?.isActive ?? false;

      if (isActive) {
        log(
          "✅ Purchases restored: user has active entitlement $entitlementIdentifier",
        );
        if (context.mounted) {
          callBack.onPurchasedRestored(context);
        }
      } else {
        log(
          "⚠️ Purchases restored but no active entitlement found $entitlementIdentifier",
        );
        if (context.mounted) {
          callBack.onPuchaseExpired(context);
        }
      }
    } on PlatformException catch (e) {
      log("❌ Restore failed: ${e.message}");
      if (context.mounted) {
        callBack.onPurchaseRestoreFailed(context);
      }
    } catch (e) {
      log("❌ Unexpected error during restore: $e");
      if (context.mounted) {
        callBack.onPurchaseRestoreFailed(context);
      }
    }
  }

  Future<String?> getActivePlan() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[RevenueCatHelper.entitlementIdentifier];

      if (entitlement != null && entitlement.isActive) {
        String productId = entitlement.productIdentifier;
        log("🔑 Active Plan: $productId");

        // ✅ Updated checks
        if (productId == "ai_story_weekly") {
          return "Weekly";
        } else if (productId == "ai_story_monthly") {
          return "Monthly";
        } else if (productId == "ai_story_yearly") {
          return "Yearly";
        } else {
          return productId; // fallback
        }
      } else {
        log("⚠️ User has no active subscription");
        return null;
      }
    } catch (e, st) {
      log("❌ Error getting active plan: $e\n$st");
      return null;
    }
  }

  // RevenueCatHelper class mein add karein
  DateTime? _lastExpirationDate;
  static const String lastExpirationKey = "last_expiration_date";

  Future<void> setupPurchaseListener() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      log('🔄 Customer info updated - checking for renewal');
      await _handleSubscriptionChange(customerInfo);
    });
  }

  Future<void> _handleSubscriptionChange(CustomerInfo customerInfo) async {
    final entitlement = customerInfo.entitlements.all[entitlementIdentifier];

    if (entitlement != null && entitlement.isActive) {
      final newExpiration = entitlement.expirationDate;

      // Previous expiration date load karein
      final prefs = await SharedPreferences.getInstance();
      String? lastExpirationString = prefs.getString(lastExpirationKey);
      log(
        'the lastExpiration ${lastExpirationString} and newExpiration ${newExpiration}',
      );
      if (lastExpirationString != null) {
        DateTime lastExpiration = DateTime.parse(lastExpirationString);

        if (newExpiration != null &&
            DateTime.parse(newExpiration).isAfter(lastExpiration)) {
          // 🎉 RENEWAL DETECTED!
          log('✅ Subscription renewed! Assigning new credits...');
          await _assignCreditsOnRenewal(entitlement.productIdentifier);
        }
      }

      // Save new expiration date
      if (newExpiration != null) {
        await prefs.setString(
          lastExpirationKey,
          // newExpiration ,
          DateTime.parse(newExpiration).toIso8601String(),
        );
      }
    } else {
      log('not renew and credit reached');
    }
  }

  Future<void> _assignCreditsOnRenewal(String productId) async {
    int credits = 0;

    // ✅ Updated product IDs with proper format
    if (productId == "ai_story_weekly") {
      credits = 30000;
    } else if (productId == "ai_story_monthly") {
      credits = 30000;
    } else if (productId == "ai_story_monthly") {
      credits = 30000;
    }

    final prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('remaining_queries', credits);

    await prefs.remove('remaining_queries');

    log('🎁 Credits assigned on renewal: $credits');
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get globalContext => navigatorKey.currentContext!;
