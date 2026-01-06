import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// initialize karna hoga app start mai
  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 5), // testing
      ),
    );

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log('log the remote config error $e');
    }
  }

  // ✅ Yahan apke console ke parameter key likho

  String get api_key_gemini => _remoteConfig.getString('gemini_api_key');
}
