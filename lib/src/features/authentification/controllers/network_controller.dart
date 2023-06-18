import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class NetworkController extends StatefulWidget {
  @override
  _NetworkControllerState createState() => _NetworkControllerState();
}

class _NetworkControllerState extends State<NetworkController> {
  Stream<ConnectivityResult> connectivityStream = Connectivity().onConnectivityChanged;
  bool isSnackBarVisible = false;
  int imageCacheBuster = 0;

  @override
  void initState() {
    super.initState();
    connectivityStream.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        hideSnackBar();
        refreshScreen(); // Automatically refresh the screen when the internet is restored
      } else {
        showNoInternetSnackBar();
      }
    });
  }

  void showNoInternetSnackBar() {
    if (!isSnackBarVisible) {
      setState(() {
        isSnackBarVisible = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text('No internet connection', style: TextStyle(color: Colors.red)),
              SizedBox(width: 8),
              Icon(Icons.signal_cellular_off, color: Colors.red),
            ],
          ),
          duration: Duration(days: 365), // Set a long duration to keep the SnackBar visible
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  void showInternetRestoredSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.wifi, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Internet connection restored',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.signal_cellular_alt, color: Colors.white),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void hideSnackBar() {
    if (isSnackBarVisible) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      setState(() {
        isSnackBarVisible = false;
      });
      showInternetRestoredSnackBar();
    }
  }

  void refreshScreen() {
    // Implement your logic to refresh the screen here
    setState(() {
      imageCacheBuster++; // Increment the cache buster value to force the image reload
    });
  }

  String getImageUrl(String originalUrl) {
    // Append the cache buster value as a query parameter to the image URL
    return '$originalUrl?cacheBuster=$imageCacheBuster';
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}