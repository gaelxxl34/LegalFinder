import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'network_listener.dart';

class NetworkController extends StatefulWidget {
  @override
  _NetworkControllerState createState() => _NetworkControllerState();
}

class _NetworkControllerState extends State<NetworkController> {
  late NetworkListener networkListener;
  bool isSnackBarVisible = false;
  int imageCacheBuster = 0;

  @override
  void initState() {
    super.initState();
    networkListener = NetworkListener();
    networkListener.addListener(_onNetworkChange);
  }

  void _onNetworkChange() {
    if (networkListener.hasInternet) {
      hideSnackBar();
      refreshScreen(); // Automatically refresh the screen when the internet is restored
    } else {
      showNoInternetSnackBar();
    }
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
              Icon(Icons.wifi_off, color: Colors.red, size: 18,),
              SizedBox(width: 8),
              Text('No internet connection', style: TextStyle(color: Colors.red, fontSize: 15)),
              SizedBox(width: 8),
              Icon(Icons.signal_cellular_off, color: Colors.red, size: 18,),
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
  void dispose() {
    networkListener.removeListener(_onNetworkChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}