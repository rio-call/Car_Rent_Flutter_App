import 'dart:async';
// we only use mp.MapboxMap instead of mapbox_maps_flutter.MapboxMap
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:carrental/models/car.dart';

class CarLocationMap extends StatefulWidget {
  final Car? car;

  const CarLocationMap.fromCar({super.key, required this.car});
  @override
  State<CarLocationMap> createState() => _CarLocationMapState();
}

class _CarLocationMapState extends State<CarLocationMap> {
  mp.MapboxMap? _mapboxMap;
  mp.CircleAnnotationManager? _circleAnnotationManager;

  @override
  void dispose() {
    // Clean up the annotation manager
    // unwaited is used to ignore the returned future
    // because dispose cannot be async By Abdalrouf

    // final mgr = _circleAnnotationManager;
    // if (mgr != null) {
    //   unawaited(mgr.deleteAll());
    // }
    super.dispose();
  }

  // for futyre releases
// the marker is fixed on the car location for now
  // @override
  // void didUpdateWidget(covariant CarLocationMap oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   final oldLat = oldWidget.car?.latitude;
  //   final oldLng = oldWidget.car?.longitude;
  //   final newLat = widget.car?.latitude;
  //   final newLng = widget.car?.longitude;
  //   if (oldLat != newLat || oldLng != newLng) {
  //     unawaited(_renderCarMarkerAndCamera());
  //   }
  // }

  Future<void> _renderCarMarkerAndCamera() async {
    final lat = widget.car?.latitude;
    final lng = widget.car?.longitude;
    // if either lat or lng is null or map is not initialized return
    if (lat == null || lng == null || _mapboxMap == null) return;

    _circleAnnotationManager ??= await _mapboxMap!.annotations
        .createCircleAnnotationManager();
    // await _circleAnnotationManager!.deleteAll();

    final options = mp.CircleAnnotationOptions(
      geometry: mp.Point(coordinates: mp.Position(lng, lat)),
      circleRadius: 8,
      circleColor: const Color(0xFF00C2A8).toARGB32(),
      circleStrokeColor: Colors.white.toARGB32(),
      circleStrokeWidth: 2,
    );
    await _circleAnnotationManager!.create(options);
    _mapboxMap!.setCamera(
      mp.CameraOptions(
        zoom: 14,
        center: mp.Point(coordinates: mp.Position(lng, lat)),
      ),
    );
  }

  void _onMapCreated(mp.MapboxMap controller) {
    _mapboxMap = controller;
    // Show only the car location marker. 
    // and center the camera on it 
    // _onmapCreated Cannot be async
    // so we use unawaited
    // By Abdalrouf
    unawaited(_renderCarMarkerAndCamera());
  }

  @override



  Widget build(BuildContext context) {
    if (widget.car?.longitude == null || widget.car?.latitude == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B1628),
        body: Center(
          child: Text(
            'This car has no location yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }



// if lat and lng are not null
    return Scaffold(
      backgroundColor: const Color(0xFF0B1628),
      body: mp.MapWidget(
        onMapCreated: _onMapCreated,
        styleUri: mp.MapboxStyles.DARK,
      ),
    );
  }
}
