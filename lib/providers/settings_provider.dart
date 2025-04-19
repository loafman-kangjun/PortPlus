import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  bool darkMode = false;
  String serverAddress = '';

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners(); // 添加更新提醒
  }

  void setServerAddress(String value) {
    serverAddress = value;
    notifyListeners();
  }
}