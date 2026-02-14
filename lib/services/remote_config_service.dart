import 'dart:developer';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:plantify/models/query_model_remoteConfig.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 5),
      ),
    );

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log('Remote config error: $e');
    }
  }

  /// 🔥 JSON → Model
  FreeQueryConfig get freeQueryConfig {
    try {
      final jsonString = _remoteConfig.getString('query_manager');

      if (jsonString.isEmpty) {
        return _defaultFreeQueryConfig();
      }

      return FreeQueryConfig.fromString(jsonString);
    } catch (e) {
      log('FreeQueryConfig parse error: $e');
      return _defaultFreeQueryConfig();
    }
  }

  String get api_key_gemini => _remoteConfig.getString('gemini_api_key');
  int get force_update_version => _remoteConfig.getInt('force_update_version');

  bool get intersitial_ads_for_android =>
      _remoteConfig.getBool('intersitial_ads_for_android');
  bool get intersitial_ads_for_ios =>
      _remoteConfig.getBool('intersitial_ads_for_ios');
  bool get app_open_Ads_for_IOS =>
      _remoteConfig.getBool('app_open_ads_for_ios');
  bool get app_open_Ads_for_android =>
      _remoteConfig.getBool('app_open_ads_for_android');
  bool get banner_ads_for_android =>
      _remoteConfig.getBool('banner_ads_for_android');
  bool get banner_ads_for_IOS => _remoteConfig.getBool('banner_ads_for_ios');
  FreeQueryConfig _defaultFreeQueryConfig() {
    return FreeQueryConfig(freeLimit: 0, weekly: 0, yearly: 0);
  }
}
