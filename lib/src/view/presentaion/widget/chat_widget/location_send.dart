

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart' as location0;
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import '../../../../core/common/sizes.dart';
import 'package:geocode/geocode.dart' as geocode;

class LocationSendWidget extends StatefulWidget {
  final String receiverId;
  const LocationSendWidget({super.key,required this.receiverId});

  @override
  State<LocationSendWidget> createState() => _LocationSendWidgetState();
}

class _LocationSendWidgetState extends State<LocationSendWidget> {
  PickerMapController controller = PickerMapController(initMapWithUserPosition: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomPickerLocation(
        controller: controller,
        bottomWidgetPicker: Positioned(
          bottom: 15,
          right: 15,
          child:  FloatingActionButton(
            onPressed:()=> getLocation(context),
            child: Icon(Icons.check,size: sizeW(context)*0.03,),
          ),
        ),
        pickerConfig: CustomPickerLocationConfig(
          initZoom: 15,
          advancedMarkerPicker: MarkerIcon(icon: Icon(Icons.location_on_rounded,size: sizeW(context)*0.05,),
      )
        ),
        ),
    );
  }



    //! location
    location0.Location location = location0.Location();

    //! geoCode
    // geocode.GeoCode geoCode = geocode.GeoCode(apiKey: '418901075211681383141x26553');
    getLocation(BuildContext context) async {
        GeoPoint? p = await controller.selectAdvancedPositionPicker();
        try{
          //! get addres
          // geocode.Address address = await geoCode.reverseGeocoding(latitude: p.latitude, longitude: p.longitude);
          // String? data = '${address.countryName ?? ''},${address.city ?? ''},${address.streetAddress ?? ''}';
          String data = '${p.latitude},${p.longitude}';
          context.read<ChatBloc>().add(SendLocationMessageEvent(receiverId: widget.receiverId, message: data));

          context.navigationBack(context);
        }
        catch(e){ log(e.toString()); return ''; }
    }

}