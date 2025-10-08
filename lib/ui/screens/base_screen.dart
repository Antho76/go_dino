import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_dino/service/logger.dart';
import 'package:go_dino/ui/menu_overlay.dart';
import 'package:go_dino/ui/theme/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


late String _mapStyleString;

class Pos {
  Pos({required this.longitude, required this.latitude});
  double longitude;
  double latitude;
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key, required this.title});

  final String title;

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  late GoogleMapController _mapController;

  bool _mapStyleLoaded = false;
  bool _defaultPosLoaded = false;

  //LatLng _currentPos = LatLng(50.3235827, 3.5141984); //coordonnées defaut Valenciennes
  //LatLng _currentPos = LatLng(50.6329700, 3.0585800); //coordonnées Lille
  late LatLng _currentPos;
  double _currentBearing = 0.0;

  @override
  void initState() {
    getLocation().then((position) {
      _currentPos = LatLng(position.latitude, position.longitude);
      _defaultPosLoaded = true;
      setState(() {
      });
    });
    rootBundle.loadString("assets/map_style/map_style.json").then((value) {
      _mapStyleString = value;
      _mapStyleLoaded = true;
      setState(() {
      });
    },);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (!_mapStyleLoaded || !_defaultPosLoaded){return Stack(children: [const LinearProgressIndicator(color: AppColors.leafGreen,backgroundColor: AppColors.softGold,), Image.asset("assets/icons/icon.png",)]);}
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        body: Stack(
          children: [GestureDetector(
            
            onVerticalDragUpdate: (details) {
              double delta = details.primaryDelta ?? 0;
              double newBearing = (_currentBearing + delta*0.3) % 360;
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _currentPos,
                    zoom: 17,
                    bearing: newBearing,
                  ),
                ),
              );
              _currentBearing = newBearing;
            },
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _currentPos, zoom: 17),
              style: _mapStyleString,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(17, 22),
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
              ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.8,
            child: MenuOverlay(),
          ),
          ]
        ),
    );
  }
}

//Récupérer position appareil
Future<Pos> getLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    LogManager.info('Service de localisation désactivé');
    return Pos(latitude: 0,longitude: 0);
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      LogManager.info('Permission refusée');
      return Pos(latitude: 0,longitude: 0);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    LogManager.error('Permission refusée définitivement');
    return Pos(latitude: 0,longitude: 0);
  }

  Position position = await Geolocator.getCurrentPosition();

  LogManager.debug('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  return Pos(latitude: position.latitude, longitude:  position.longitude);
}
