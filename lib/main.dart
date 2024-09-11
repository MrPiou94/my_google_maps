import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Google Maps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Google Maps Cross-Platform'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(50.0, 4.0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> markers = <Marker>{};

  void moveCam(double lat, double lon, double zoom){
    CameraPosition kPointer = CameraPosition(
      target: LatLng(lat,lon),
      zoom: zoom, tilt: 50.0, bearing: 0.0,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(kPointer),);
  }

  final TextEditingController _get = TextEditingController();

  void getAPI(String address) async {

    moveCam(50.0, 4.0, 4.0);

    var bodyEncode = jsonEncode({"address": address});
    Uri uri = Uri.https("www.exemple.com", "/map/geocoding.php");
    http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: bodyEncode,
        encoding: Encoding.getByName("utf-8")
    );
    dynamic value = jsonDecode(response.body);
    value = jsonDecode(value["msg"]);
    print("Status Code: ${response.statusCode}");
    print("Response Body: $value");

    markers.clear();

    if(value["results"].length>1){
      print("${value["results"].length} adresse trouvées");
    }
    for(int i=0; i<value["results"].length ;i++){
      try{
        var coordinates = jsonCoordinate(value["results"][i]);
        double latitudeAPI = coordinates.$1;
        double longitudeAPI = coordinates.$2;
        List<dynamic> address = value["results"][i]["address_components"];
        String streetNumber = "";
        String route = "";
        String locality = "";
        String country = "";
        String postalCode = "";
        for(int i=0; i< address.length; i++){
          if(address[i]["types"][0] == "street_number"){
            streetNumber = address[i]["long_name"];
          }else if(address[i]["types"][0] == "route"){
            route = address[i]["long_name"];
          }else if(address[i]["types"][0] == "locality"){
            locality = address[i]["long_name"];
          }else if(address[i]["types"][0] == "country"){
            country = address[i]["short_name"];
          }else if(address[i]["types"][0] == "postal_code"){
            postalCode = address[i]["long_name"];
          }
        }
        setState(() {
          markers.add(
              Marker(
                markerId: MarkerId('id-${i+1}'),
                position: LatLng(latitudeAPI, longitudeAPI),
                infoWindow: InfoWindow(
                  title: '$locality $postalCode',
                  snippet: "$route $streetNumber",
                ),
                onTap: () {
                  _get.text = '$streetNumber $route, $locality $postalCode, $country';
                  moveCam(latitudeAPI, longitudeAPI, 18);
                },
              )
          );
        });
        if(value["results"].length==1){
          Future.delayed(const Duration(milliseconds: 200), (){
            if(mounted){
              moveCam(latitudeAPI, longitudeAPI, 18);
            }
          });
        }
      }catch(e){
        print("Error add Marker");
      }
    }
  }

  (double, double) jsonCoordinate(dynamic value){
    double getLat = 0;
    double getLng = 0;
    try{
      getLat = value["geometry"]["location"]["lat"];
      getLng = value["geometry"]["location"]["lng"];
    }catch(e){
      print("Error jsonCoordinate");
    }
    return (getLat,getLng);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    markers.add(
      Marker(
        markerId: const MarkerId('marker-1'),
        position: const LatLng(45, 5),
        infoWindow: InfoWindow(
            title: 'mon marker 1',
            snippet: 'information',
            onTap: (){}
        ),
        onTap: (){},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('marker-2'),
        position: const LatLng(50, 4),
        infoWindow: InfoWindow(
            title: 'mon marker 2',
            snippet: 'information',
            onTap: (){}
        ),
        onTap: (){},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );

  }

  @override
  void dispose() {
    try {
      mapController.dispose();
    } catch (e) {
      print('mapController n\'a pas été initialisé : $e');
    }
    _get.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.5,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                mapType: MapType.hybrid,
                onCameraMove:(CameraPosition cameraPosition) async{
                  double mapCurrentLatitude = cameraPosition.target.latitude;
                  double mapCurrentLongitude = cameraPosition.target.longitude;
                  print('mapCurrentLatitude $mapCurrentLatitude \nmapCurrentLongitude $mapCurrentLongitude ');
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.5 < 300 ? 300 :MediaQuery.of(context).size.width*0.5,
                child: TextFormField(controller: _get),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(onPressed: (){getAPI(_get.text);}, // "2 rue du pont"
                child: const Text('GET API'),),
            ),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
