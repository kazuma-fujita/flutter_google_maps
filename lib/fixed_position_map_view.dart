import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class FixedPositionMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Position Maps View'),
      ),
      body: _ScrollBodyWidget(),
    );
  }
}

class _ScrollBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 560,
              child: Container(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 240,
              child: Card(
                child: _MapView(),
              ),
            ),
            SizedBox(
              height: 560,
              child: Container(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final _url =
      'https://www.google.com/maps/search/?api=1&q=35.667097,139.740178';
  // 初期表示位置を新宿駅に設定
  final Position _initialPosition = Position(
    latitude: 35.667097,
    longitude: 139.740178,
    timestamp: DateTime.now(),
    altitude: 0,
    accuracy: 0,
    heading: 0,
    floor: null,
    speed: 0,
    speedAccuracy: 0,
  );

  @override
  Widget build(BuildContext context) {
    // 初期表示座標のMarkerを設定
    final initialMarkers = {
      _initialPosition.timestamp.toString(): Marker(
        markerId: MarkerId(_initialPosition.timestamp.toString()),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      ),
    };

    return Scaffold(
      body: GoogleMap(
        onTap: (LatLng latLng) {
          _launchURL();
        },
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 16,
        ),
        markers: initialMarkers.values.toSet(),
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        rotateGesturesEnabled: false,
        compassEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }

  Future<void> _launchURL() async => await canLaunch(_url)
      ? await launch(
          _url,
          forceSafariVC: false,
          forceWebView: false,
        )
      : throw Exception('Could not launch $_url');
}
