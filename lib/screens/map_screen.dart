import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helper/dimensions.dart';

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition myPosition;
  // PanelController controller = new PanelController();
  Set<Marker> markers = Set<Marker>();
  late double vpH;
  late double vpW;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    markers.add(
      Marker(
        visible: true,
        position: LatLng(27.914262305553116, 78.07734304941607),
        markerId: MarkerId("AMURoboclub Id"),
        infoWindow: InfoWindow(title: "AMURoboclub"),
      ),
    );

    myPosition = CameraPosition(
      bearing: 192,
      target: LatLng(27.91491500914645, 78.07680603242314),
      tilt: 0,
      zoom: 18,
    );
    return new Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text(
          "MapView",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "BalooTamma2",
            fontSize: vpH * 0.03,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
            height: vpH,
            width: vpW,
            child: GoogleMap(
              buildingsEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              trafficEnabled: true,
              mapType: MapType.hybrid,
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: markers,
              initialCameraPosition: myPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )),
      ),
    );
  }

  // Widget _scrollingList(ScrollController sc) {
  //   return ListView.builder(
  //     key: listViewKey,
  //     controller: sc,
  //     padding: EdgeInsets.only(top: vpH * 0.03),
  //     shrinkWrap: true,
  //     scrollDirection: Axis.vertical,
  //     itemBuilder: (context, int index) {
  //       return HospitalListViewItem(
  //         inputDistance: inputDistance,
  //         panelController: controller,
  //         controller: _controller,
  //         hospital: hospitals[index],
  //       );
  //     },
  //     itemCount: hospitals.length,
  //   );
  // }
  /* Future<void> _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await getLocation().then((value) {
      if (value != null) {
        locationProvider.setLocation = value;
        myLocationData = value;
        myPosition = CameraPosition(
          bearing: 192,
          target: LatLng(myLocationData.latitude, myLocationData.longitude),
          tilt: 0,
          zoom: 18,
        );
        controller.animateCamera(CameraUpdate.newCameraPosition(myPosition));
      }
    });
  }*/
}
