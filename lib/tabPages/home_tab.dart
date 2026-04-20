
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';
import '../assistants/black_theme_google_map.dart';
import '../global/global.dart';
import '../main.dart';
import '../push_notifications/push_notification_system.dart';


class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}



class _HomeTabPageState extends State<HomeTabPage>
{
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  var geoLocator = Geolocator();

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;


  locateDriverPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;
    print(onlineDriverData.id!.toString()+" is the onlin driver di heyyyyyyyyyyyyy");
    FirebaseDatabase.instance.ref().child("drivers").child(onlineDriverData.id!).child("latitude").set({
      "latitude":cPosition.latitude,
    });
    FirebaseDatabase.instance.ref().child("drivers").child(onlineDriverData.id!).child("longitude").set({
      "longitude":cPosition.longitude,
    });
    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
  }

  readCurrentDriverInformation() async {
    currentFirebaseUser = fAuth.currentUser;

    await FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((DatabaseEvent snap)
    {
      if(snap.snapshot.value != null)
      {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"] ?? "";
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_type = (snap.snapshot.value as Map)["car_details"]["type"];

        driverVehicleType = (snap.snapshot.value as Map)["car_details"]["type"];

        print("Car Details :: ");
        print(onlineDriverData.car_color);
        print(onlineDriverData.car_model);
        print(onlineDriverData.car_number);
      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  @override
  void initState()
  {
    super.initState();
    readCurrentDriverInformation();
    AssistantMethods.readDriverEarnings(context);
  }

  @override
  Widget build(BuildContext context) {
    statusText = Locales.string(context, "nowoffline");
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            //black theme google map
            blackThemeGoogleMap(newGoogleMapController);

            locateDriverPosition();
          },
        ),

        //ui for online offline driver
        !isDriverActive
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),

        //button for online offline driver
        Positioned(
          top: !isDriverActive
              ? MediaQuery.of(context).size.height * 0.46
              : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: ()
                {
                  if(isDriverActive != true) //offline
                  {
                    driverIsOnlineNow();
                    updateDriversLocationAtRealTime();

                    setState(() {
                      statusText = Locales.string(context, "nowonline");
                      isDriverActive = true;
                      buttonColor = Colors.transparent;
                    });

                    //display Toast
                    Fluttertoast.showToast(msg: Locales.string(context, "youareonlinenow"));
                  }
                  else //online
                  {
                    driverIsOfflineNow();

                    setState(() {
                      statusText = Locales.string(context, "nowoffline");
                      isDriverActive = false;
                      buttonColor = Colors.grey;
                    });

                    //display Toast
                    Fluttertoast.showToast(msg: Locales.string(context, "youareofflinenow"));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: !isDriverActive
                    ? Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.phonelink_ring,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  driverIsOnlineNow() async
  {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) { });
  }

  updateDriversLocationAtRealTime()
  {
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
          driverCurrentPosition = position;
          if(isDriverActive == true)
          {
            Geofire.setLocation(
                currentFirebaseUser!.uid,
                driverCurrentPosition!.latitude,
                driverCurrentPosition!.longitude
            );
            FirebaseDatabase.instance.ref().child("drivers").child(onlineDriverData.id!).update({
              "id":onlineDriverData.id!,
              "email":onlineDriverData.email!,
              "phone":onlineDriverData.phone ??"",
              "name":onlineDriverData.name!,
              "latitude":position.latitude,
              "longitude":position.longitude,
              "car_details":{
                "car_color":onlineDriverData.car_color,
                "car_model":onlineDriverData.car_model,
                "car_number":onlineDriverData.car_number,
                "type":onlineDriverData.car_type,
              },

            });
          }

          LatLng latLng = LatLng(
              driverCurrentPosition!.latitude,
              driverCurrentPosition!.longitude,
          );

          newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow()
  {
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), ()
    {
      //SystemChannels.platform.invokeMethod("SystemNavigator.pop");;
      MyApp.restartApp(context);
    });
  }
}
