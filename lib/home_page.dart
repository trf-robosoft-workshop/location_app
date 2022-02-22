import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_app/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? longitude;
  double? latitude;

  getPermission() async {
    await Geolocator.requestPermission();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      print("LONGITUDE:$longitude");
      print("Latitude:$latitude");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/images/dashboard.jpeg'),
              height: 300,
              width: 300,
            ),
            const Text('Current Location',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
            longitude != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Longitude:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                          Text("${longitude?.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Latitude:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                          Text("${latitude?.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24)),
                        ],
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
            ElevatedButton(
                onPressed: () {
                  getCurrentLocation();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => WebViewScreen(
                                latitude: latitude!,
                                longitude: longitude!,
                              )));
                },
                child: const Text('Web View')),
            ElevatedButton(
                onPressed: () {
                  getCurrentLocation();
                  String googleUrl =
                      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

                  try {
                    launch(googleUrl);
                  } catch (e) {
                    print(e);
                    const SnackBar(
                      content: Text("Something went wrong"),
                    );
                  }
                },
                child: const Text('Google Map')),
          ],
        ),
      ),
    );
  }
}
