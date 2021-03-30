import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  static const _url =
      'https://www.google.com/maps/search/?api=1&q=35.667097,139.740178';

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(35.667097, 139.740178),
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    final _initialMarkers = {
      'initialMarker': Marker(
        markerId: MarkerId('initialMarker'),
        position: const LatLng(35.667097, 139.740178),
      ),
    };

    return Scaffold(
      body: GoogleMap(
        onTap: (LatLng latLng) {
          _launchURL();
        },
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: _initialMarkers.values.toSet(),
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
