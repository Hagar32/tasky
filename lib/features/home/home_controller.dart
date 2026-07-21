

import 'package:flutter/material.dart';


import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';

class HomeController with ChangeNotifier {
  String? username;
  String? motivationQuote;

  String? userImagePath;

  init() {
    loadUserData();
  }

  void loadUserData() {
    username = PreferencesManager().getString(StorageKey.username);

    motivationQuote = PreferencesManager().getString(
      StorageKey.motivationQuote,
    );
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }
}
