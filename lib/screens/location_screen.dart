import 'package:flutter/material.dart';
import '../widgets/bottomnavigation_widget.dart';
import '../widgets/searchlocation_widget.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';



import 'dart:async';

class GetLocation extends StatefulWidget{
  _GetLocationState createState() => _GetLocationState();

  }
  
  class _GetLocationState extends State<GetLocation>{
    var location = new Location();
    String userLocation;
    String fullAddress;
  
    void initState() {
      super.initState();
      // this.nameScreen = "From initState";
      _getLocation().then((value){
        setState((){
          userLocation = value;
          print("$userLocation");
        });
      });
    }
      // }_getLocation().then((value){
      //               setState((){
      //                 userLocation = value;
      //                 print("$userLocation");
      //                 // getAddressLocation(userLocation);
      //               });
      //             });
    Widget build(BuildContext context){
      return Text(
        "$userLocation"
      );
  }

  Future<String> _getLocation() async{
    
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    final coordinates = new Coordinates(currentLocation["latitude"], currentLocation["longitude"]);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String first = addresses.first.addressLine.toString();
    print("$first"+" "+"hey");
    return first;
  }

}
