import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetworkListener extends ChangeNotifier {
  bool _hasInternet = false;

  bool get hasInternet => _hasInternet;

  NetworkListener() {
    _init();
  }

  Future<void> _init() async {
    _hasInternet = await _checkInternetConnection();
    notifyListeners();

    const fiveSec = const Duration(seconds: 5);
    Timer.periodic(fiveSec, (Timer t) async {
      bool previousStatus = _hasInternet;
      bool currentStatus = await _checkInternetConnection();
      if (previousStatus != currentStatus) {
        _hasInternet = currentStatus;
        notifyListeners();
      }
    });
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com/'));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}