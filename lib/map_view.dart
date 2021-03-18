import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps View'),
      ),
      body: _MapView(),
    );
  }
}

class _MapView extends HookWidget {
  final Completer<GoogleMapController> _mapController = Completer();
  // 初期表示位置を渋谷駅に設定
  final Position _initialPosition = Position(
    latitude: 35.658034,
    longitude: 139.701636,
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
        markerId: MarkerId(
          _initialPosition.timestamp.toString(),
        ),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      )
    };
    final position = useState<Position>(_initialPosition);
    final markers = useState<Map<String, Marker>>(initialMarkers);

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
      (Position currentPosition) {
        // 現在地座標にMarkerを立てる
        final marker = Marker(
          markerId: MarkerId(currentPosition.timestamp.toString()),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
        );
        markers.value.clear();
        markers.value[currentPosition.timestamp.toString()] = marker;
        // 現在地座標のstateを更新する
        position.value = currentPosition;
        print('position:${position.value}');
      },
    );

    // _latLngListener(context);
    _animateCamera(position);

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        // 初期表示位置は渋谷駅に設定
        initialCameraPosition: CameraPosition(
          // target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          target: LatLng(position.value.latitude, position.value.longitude),
          zoom: 14.4746,
        ),
        onMapCreated: _mapController.complete,
        markers: markers.value.values.toSet(),
      ),
    );
  }

  Future<void> _animateCamera(ValueNotifier<Position> position) async {
    final mapController = await _mapController.future;
    // 現在地座標が取得できたらカメラを現在地に移動する
    await mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.value.latitude, position.value.longitude),
      ),
    );
  }

  Future<void> _latLngListener(BuildContext context) async {
    final screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    final screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    final middleX = screenWidth / 2;
    final middleY = screenHeight / 2;

    final screenCoordinate =
        ScreenCoordinate(x: middleX.round(), y: middleY.round());
    final mapController = await _mapController.future;
    final latLng = await mapController.getLatLng(screenCoordinate);

    print('latLng:$latLng');
  }

  // Future<void> _goToTheLake() async {
  //   final controller = await _mapController.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // 設定画面へ遷移
        // await Geolocator.openAppSettings();
        // 設定画面へ遷移
        await Geolocator.openLocationSettings();
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Position position = await Geolocator.getLastKnownPosition();
    print('position: $position}');
    return position;
  }
}
