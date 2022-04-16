import 'package:background_location/background_location.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pawgo/models/currentUser.dart';
import 'package:pawgo/models/dogsList.dart';
import 'package:pawgo/models/loggedUser.dart';
import 'package:pawgo/utils/mobile_library.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;


extension LocationDataExt on loc.LocationData {
  GeoPoint toGeoPoint() {
    return GeoPoint(latitude: this.latitude!, longitude: this.longitude!);
  }

  Location toBGLocation() {
    return Location(
        longitude: longitude,
        latitude: latitude,
        altitude: altitude,
        accuracy: accuracy,
        bearing: null,
        speed: speed,
        time: time,
        isMock: isMock);
  }
}

extension LocationExt on Location {
  GeoPoint toGeoPoint() {
    return GeoPoint(latitude: this.latitude!, longitude: this.longitude!);
  }
}

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController controller = MapController(initMapWithUserPosition: true);
  bool _hasPermissions = false;
  bool _isRecording = false;
  bool _shouldInitialize = true;
  FaIcon markerdog = FaIcon(FontAwesomeIcons.dog);
  List<GeoPoint> path = [];
  RoadInfo? _roadInfo;
  OSMFlutter? map;
  Location? currentLocation;
  LoggedUser _miUser = LoggedUser.instance!;

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      print("Map ready");
      if (_shouldInitialize) {
        BackgroundLocation.startLocationService(distanceFilter: 4.0);
        currentLocation =
            (await loc.Location.instance.getLocation()).toBGLocation();
        controller.changeLocation(currentLocation!.toGeoPoint());
        BackgroundLocation.getLocationUpdates((location) async {
          controller.removeMarker(currentLocation!.toGeoPoint());
          currentLocation = location;
          controller.changeLocation(location.toGeoPoint());
        });
        setState(() {
          _shouldInitialize = false;
        });
      }
      controller.setZoom(stepZoom: 10.0);
    }
  }

  void getLocationPermission() async {
    var status = Permission.locationWhenInUse.request();
    if (await status.isGranted) {
      var status = Permission.locationAlways.request();
      if (await status.isGranted) {
        setState(() {
          _hasPermissions = true;
        });
      }
    }
  }

  void parseLocation(Location location) {
    if (path.last.latitude == location.latitude &&
        path.last.longitude == location.longitude) {
      print("No need to save the current position");
    } else {
      if (_isRecording) {
        path.add(GeoPoint(
            latitude: location.latitude!, longitude: location.longitude!));
        double newAltitude = location.altitude!;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // controller.addObserver(this);
    // WidgetsBinding.instance?.addObserver(this);
    getLocationPermission();
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    controller.dispose();
    // WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  List<GeoPoint> convertPathList(List<GeoPoint> path) {
    List<GeoPoint> listToReturn = [];

    for (var point in path) {
      listToReturn.add(GeoPoint(
          latitude: point.latitude, longitude: point.longitude));
    }

    return listToReturn;
  }

  @override
  Widget build(BuildContext context) {
    if (map == null && _hasPermissions) {
      map = OSMFlutter(
        controller: controller,
        trackMyPosition: true,
        mapIsLoading: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator(), Text("Map is Loading..")],
          ),
        ),
        initZoom: 17,
        minZoomLevel: 8,
        maxZoomLevel: 19,
        stepZoom: 1.0,
        key: widget.key,
        androidHotReloadSupport: true,
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              markerdog.icon,
              color: Colors.deepOrange,
              size: 90,
            ),
          ),
          directionArrowMarker: MarkerIcon(
            icon: Icon(
              markerdog.icon,
              size: 90,
            ),
          ),
        ),
          showContributorBadgeForOSM: false,
          showDefaultInfoWindow: false,
          // TODO: To implement at some point to show user's profile once tapped on the icon
          // onGeoPointClicked: (geoPoint) async {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         "${geoPoint.toMap().toString()}",
          //       ),
          //       action: SnackBarAction(
          //         onPressed: () =>
          //             ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          //         label: "hide",
          //       ),
          //     ),
          //   );
          // },
        );
      }

    Size size = MediaQuery.of(context).size;
    return _hasPermissions
        ? Scaffold(
      body: OrientationBuilder(
        builder: (ctx, orientation) {
          return Container(
            child: Stack(
              children: [
                map!,
                Positioned(
                    bottom: size.height / 13,
                    width: size.width / 1,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: StatefulBuilder(
                          builder: (context, internalState) {
                            return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  SizedBox(width: size.width/5),
                                ]);
                          },
                        )
                    ),
                ),
              ],
            ),
          );
        },
      ),
    )
        : Container();
  }


  showAlertDialog(BuildContext context, String text) {
    final snackBar = SnackBar(
        elevation: 25.0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  String nStringToNNString(String? str) {
    return str ?? "";
  }

}
