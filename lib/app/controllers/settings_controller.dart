import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Rx<ThemeMode> currentThemeMode =
      Rx<ThemeMode>(Get.isDarkMode ? ThemeMode.dark : ThemeMode.light);

  AppSettings() {
    loadSettings();

    Get.changeThemeMode(currentThemeMode.value);
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

    currentThemeMode.value =
        _settingsStorage.read<String>(Config.currentThemeMode) == "darkMode"
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  //save one or multiple settings
  Future<void> saveSettings(Map<String, dynamic> newSettings) async {
    for (String key in newSettings.keys) {
      await _settingsStorage.write(key, newSettings[key]);
      loadSettings();
    }
  }

  void switchThemeMode() {
    final newTheme = currentThemeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    Get.changeThemeMode(newTheme);

    saveSettings({
      Config.currentThemeMode:
          newTheme == ThemeMode.light ? "lightMode" : "darkMode"
    });

    currentThemeMode.value = newTheme;
  }
}
