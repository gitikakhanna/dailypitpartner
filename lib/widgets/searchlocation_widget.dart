import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import '../screens/location_screen.dart';
import 'bottomnavigation_widget.dart';
import 'dart:async';

const kGoogleApiKey = "AIzaSyB3UCjf7qRPy-IJNLlElVL2Fb8qwM6QG-Y";
//to get detailed places with lat and long
GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchLocation extends StatefulWidget{
  _SearchLocationState createState()=>_SearchLocationState();

}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchLocationState extends State<SearchLocation>{
  Mode _mode = Mode.overlay;

   Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: new Container(
          child: Column(
            children: <Widget>[
              GetLocation(),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _handlePressButton,
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDropdownMenu(),
          RaisedButton(
            onPressed: _handlePressButton,
            child: Text("Search places"),
          ),
          // RaisedButton(
          //   child: Text("Custom"),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed("/search");
          //   },
          // ),
        ],
      )),
      bottomNavigationBar: BottomNavigation(),
    );
}

  Widget _buildDropdownMenu() => DropdownButton(
        value: _mode,
        items: <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            child: Text("Overlay"),
            value: Mode.overlay,
          ),
          DropdownMenuItem<Mode>(
            child: Text("Fullscreen"),
            value: Mode.fullscreen,
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m;
          });
        },
    );

  void onError(PlacesAutocompleteResponse response){
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async{
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "in",
      components: [Component(Component.country, "in")],
    );
    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async{
    if(p!=null){
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
}


