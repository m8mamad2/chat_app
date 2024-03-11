

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart' as location0;
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import '../../../../core/common/sizes.dart';
import '../../../data/repo/group_repo_body.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';





class LocationSendWidget extends StatefulWidget {
  final bool isGroup;
  final String receiverId;
  const LocationSendWidget({super.key,required this.receiverId,required this.isGroup});

  @override
  State<LocationSendWidget> createState() => _LocationSendWidgetState();
}
class _LocationSendWidgetState extends State<LocationSendWidget> {

  bool isLoadin = true;
  MapController controller = MapController();
  late Marker marker;
  late LocationData? initCurrent;
  late LatLng latLng;

  Future<LocationData?> _currentLocatio()async{
    
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    Location location  = Location();

    serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
      if(!serviceEnabled)return null;
    }

    permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied){
      permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted)return null;
    }

    return  await location.getLocation();
  }
  
  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
      initCurrent = await _currentLocatio();
      marker = Marker(point: LatLng( initCurrent!.latitude!.toDouble(),initCurrent!.longitude!.toDouble()), child: Icon(Icons.location_on,size: sizeW(context)*0.1,));
      isLoadin = false;
      setState(() {});
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoadin 
          ? Center(child: Container(child: loading(context)))
          : FlutterMap(
            options:MapOptions(
              initialCenter: LatLng(initCurrent?.latitude ?? 33.98308 ,initCurrent?.longitude ?? 51.43644),
              initialRotation: 0,
              
              initialZoom: 14,
              keepAlive: true,
              onTap: (tapPosition, point) => setState((){
                marker = Marker(point: LatLng( point.latitude, point.longitude), child: Icon(Icons.location_on,size: sizeW(context)*0.1,));
              }),
              interactionOptions: const InteractionOptions(
                cursorKeyboardRotationOptions: CursorKeyboardRotationOptions(setNorthOnClick: false,),
                debugMultiFingerGestureWinner: false,
                enableMultiFingerGestureRace: false,)
            ), 
            mapController: controller,
            children: [
              
              //! config
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer( markers: [ marker ]),
              
              //! button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.01,vertical: sizeH(context)*0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        backgroundColor: theme(context).primaryColorDark,
                        onPressed: ()async => getLocation(context),
                        child: Icon(Icons.check,color: theme(context).primaryColorLight,),
                      ),
                      FloatingActionButton(
                        backgroundColor: theme(context).primaryColorDark,
                        onPressed:  ()async {
                          setState(()=>marker = Marker(point: LatLng( initCurrent!.latitude!,initCurrent!.longitude!), child: Icon(Icons.location_on,size: sizeW(context)*0.1,)));
                          controller.move(LatLng( initCurrent!.latitude!,initCurrent!.longitude!), 14); },
                        child:  Icon(Icons.my_location_rounded,color: theme(context).primaryColorLight),
                      ),
                    ],
                  ),
                ),
              ),
    
            ]),
        ),
    );
  }

      //! location
    location0.Location location = location0.Location();

    getLocation(BuildContext context) async {
      
        final GeoCoderModel res = await GeocodingApiRepo.reverseGeo(marker.point.latitude.toString(), marker.point.longitude.toString());
        try{
          String data = '${res.lat},${res.lon}';
          GroupRepoBody repo = GroupRepoBody();

          widget.isGroup 
            ? await repo.sendGroupLocationMessage(data, widget.receiverId)
            : context.read<ChatBloc>().add(SendLocationMessageEvent(receiverId: widget.receiverId, message: data,replyMessage: null));


          context.navigationBack(context);
          context.navigationBack(context);
        }
        catch(e){ log(e.toString()); return ''; }
    }

}

            
class GeocodingApiRepo{

  static const String _uri = 'https://geocod.xyz/api/public/getAddress?apikey=abd266d3-5668-45be-8ba8-e71b91c9ceb4';


  static Future<GeoCoderModel> reverseGeo(String lat,String lon)async{

    final http.Response response = await http.get(Uri.parse('$_uri&lat=$lat&lon=$lon'));
    GeoCoderModel model = GeoCoderModel.fromJson((jsonDecode(response.body)) as Map<String,dynamic>) ;
    return model;
  }
}


class GeoCoderModel{
  final double? lat;
  final double? lon;
  final String? postaladdress;
  final String? zipcode ;
  final String? city;
  final String? state;
  final String? country;
  GeoCoderModel({
      required this.lat,
      required this.lon,
      required this.postaladdress,
      required this.zipcode ,
      required this.city,
      required this.state,
      required this.country,
    });

  factory GeoCoderModel.fromJson(Map<String,dynamic> json)=>GeoCoderModel(
    lat:json['lat'],
    lon:json['lon'],
    postaladdress:json['postaladdress'],
    zipcode :json['zipcode '],
    city:json['city'],
    state:json['state'],
    country:json['country'],
  );
}