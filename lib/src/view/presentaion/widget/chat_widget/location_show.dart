// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationShowWidget extends StatefulWidget {
  final MessageModel data;
  const LocationShowWidget({super.key,required this.data});

  @override
  State<LocationShowWidget> createState() => _LocationShowWidgetState();
}

class _LocationShowWidgetState extends State<LocationShowWidget> {
  late double late;
  late double long;
  late MapController controller;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.navigationBack(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed:() async => await openMap(late,long), icon: const Icon(Icons.open_in_browser))
        ],
      ),
      body: OSMFlutter(
        controller:controller,
        staticPoints: [
          StaticPositionGeoPoint(
            'first', 
            MarkerIcon(icon: Icon(Icons.location_on_sharp,color: Colors.black,size:sizeW(context)*0.08,),), 
            [ GeoPoint(latitude: late, longitude: long) ])
        ],
        initZoom: 15,
        minZoomLevel: 3,
        maxZoomLevel: 19,
        ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    List<String> latLong = widget.data.messsage.split(',');
    late = double.parse(latLong.first);
    long = double.parse(latLong.last);
    
    controller = MapController.withPosition(initPosition: GeoPoint(latitude: late, longitude: long));

  }


  Future<void> openMap(double latitude, double longitude) async {
    final Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if ( await launchUrl(googleUrl)) { await launchUrl(googleUrl); } 
    else { throw 'Could not open the map.'; }
  }
} 