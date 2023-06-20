import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/config.dart';

class AppSettings extends GetxService {
  final _settingsStorage = GetStorage();

  final formKey = GlobalKey<FormState>();

  String? username;
  String? password;

  String? preferedTheme;
  String? preferredLanguage;

  bool? isNotFirstLogin;

  bool? isDeviceTokenRegistered;

  bool? showGeneralNotifications;
  bool? playNotificationSound;

  double markTotal = 20;

  AppSettings() {
    loadSettings();
  }

  get appSettings => _settingsStorage;

  static AppSettings get to => Get.find();

  //load the settings from storage
  void loadSettings() {
    username = _settingsStorage.read(Config.username);
    password = _settingsStorage.read(Config.password);
    markTotal = _settingsStorage.read(Config.markTotal) ?? 20;
    isNotFirstLogin = _settingsStorage.read<bool>(Config.isNotFirstLogin);
    isDeviceTokenRegistered =
        _settingsStorage.read<bool>(Config.isDeviceTokenRegistered);

    preferredLanguage = _settingsStorage.read<String>(Config.preferredLanguage);

    showGeneralNotifications =
        _settingsStorage.read<bool>(Config.showGeneralNotifications);

    playNotificationSound =
        _settingsStorage.read<bool>(Config.playNotificationSound);
  }

  //save one or multiple settings
  Future<void> saveSettings(Map<String, dynamic> newSettings) async {
    for (String key in newSettings.keys) {
      await _settingsStorage.write(key, newSettings[key]);
      loadSettings();
    }
  }
}
