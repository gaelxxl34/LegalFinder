import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

import 'mailverification_controller.dart';



class NetworkListener extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late bool _hasInternet;

  bool get hasInternet => _hasInternet;

  NetworkListener() {
    _init();
  }

  Future<void> _init() async {
    _hasInternet = await _checkInternetConnection();
    notifyListeners();

    _connectivity.onConnectivityChanged.listen((result) async {
      bool previousStatus = _hasInternet;
      bool currentStatus = await _checkInternetConnection();

      if (previousStatus != currentStatus) {
        _hasInternet = currentStatus;
        notifyListeners();
      }
    });
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}