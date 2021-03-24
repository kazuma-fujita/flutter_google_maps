import 'package:flutter/material.dart';
import 'package:flutter_google_maps/map_view.dart';

import 'fixed_position_map_view.dart';

class Const {
  static const routeFirstView = '/first';
}

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      routes: <String, WidgetBuilder>{
        Const.routeFirstView: (BuildContext context) => MapView(),
      },
      home: _FirstView(),
    );
  }
}

class _FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<FixedPositionMapView>(
                  builder: (BuildContext _context) => FixedPositionMapView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, Const.routeFirstView),
          child: const Text('Launch the map'),
        ),
      ),
    );
  }
}
