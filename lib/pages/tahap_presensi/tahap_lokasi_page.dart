import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_satwa/components/buttons.dart';
import 'package:galaxy_satwa/components/dialog.dart';
import 'package:galaxy_satwa/config/theme.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
import 'package:galaxy_satwa/pages/base/base.dart';
import 'package:galaxy_satwa/services/attendance_service.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:gps_connectivity/gps_connectivity.dart';

class TahapLokasiPage extends StatefulWidget {
  final String jenisAbsen;
  final String tanggal;
  final String? idAttendance;
  const TahapLokasiPage(
      {Key? key,
      required this.jenisAbsen,
      required this.tanggal,
      this.idAttendance = '0'})
      : super(key: key);

  @override
  State<TahapLokasiPage> createState() => _TahapLokasiPageState();
}

class _TahapLokasiPageState extends State<TahapLokasiPage> {
  bool isLoading = true;
  CameraPosition? _kGooglePlex;

  int createMarker = 0;

  final Set<Marker> _markers = {};

  List<dynamic> _me = [];

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  List<Circle> circle = [
    Circle(
      circleId: const CircleId('circle_id_1'),
      center: const LatLng(
        -7.3162798,
        112.7254854,
      ),
      radius: 100,
      fillColor: Colors.blue.withOpacity(0.5),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    ),
  ];

  void requestPermission() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      TrustLocation.start(1);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  }

  String? latitude;
  String? longitude;
  String? status;
  bool isGpsEnabled = true;
  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) async {
        if (mounted) {
          latitude = result.latitude;
          longitude = result.longitude;
          print(latitude);
          print(longitude);
          isGpsEnabled = await (GpsConnectivity().checkGpsConnectivity());

          // isMock = result.isMockLocation;
          if (latitude != null) {
            _me = [
              {
                "name": "Me",
                "position":
                    LatLng(double.parse(latitude!), double.parse(longitude!)),
                "marker": 'assets/ic_marker.png',
              },
            ];
            _kGooglePlex = CameraPosition(
              target: LatLng(double.parse(latitude!), double.parse(longitude!)),
              zoom: 14.4746,
            );
            double distance = calculateDistance(
              -7.3162798,
              112.7254854,
              double.parse(latitude!),
              double.parse(longitude!),
            );
            status = distance <= 10 ? 'Di dalam area' : 'Di luar area';

            isLoading = false;
          }

          setState(() {});
        }
      });
    } catch (e) {
      print('Error');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Radius Bumi dalam meter
    double phi1 = lat1 * pi / 180;
    double phi2 = lat2 * pi / 180;
    double deltaPhi = (lat2 - lat1) * pi / 180;
    double deltaLambda = (lon2 - lon1) * pi / 180;

    double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  void _createdAttendance() async {
    ApiResponse response;
    if (widget.jenisAbsen == 'Absen Masuk') {
      response = await createAttendance(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          checkIn: DateFormat('HH:mm:ss').format(DateTime.now()));
    } else {
      response = await updateAttendance(
          idAttendance: widget.idAttendance!,
          checkOut: DateFormat('HH:mm:ss').format(DateTime.now()));
    }

    if (response.error == null) {
      String role = await getRole();
      String name = await getName();
      String image = await getImage();

      // ignore: use_build_context_synchronously
      customDialog(
          'Absensi', 'Berhasil melakukan absen', 'assets/ic_presensi.png', () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BasePage(role: role, name: name, image: image)),
            (route) => false);
      }, () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BasePage(role: role, name: name, image: image)),
            (route) => false);
        return true;
      }, context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    createMarkers(context);

    return Scaffold(
        body: SafeArea(
      child: isGpsEnabled != null
          ? Stack(
              children: [
                !isLoading
                    ? GoogleMap(
                        initialCameraPosition: _kGooglePlex!,
                        markers: _markers,
                        circles: Set<Circle>.from(circle),
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) {},
                      )
                    : Container(),
                if (!isGpsEnabled!)
                  Container(
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 100, left: 20),
                    decoration: BoxDecoration(
                        color: danger, borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aktifkan GPS',
                          style: plusJakartaSans.copyWith(
                              fontWeight: bold, color: const Color(0xFFFBFBFB)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Silahkan aktifkan GPS terlebih dahulu',
                          style: plusJakartaSans.copyWith(
                              fontSize: 12, color: const Color(0xFFFBFBFB)),
                        )
                      ],
                    ),
                  ),
                Positioned(
                  top: 30,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                              color: neutral100, shape: BoxShape.circle),
                          child: const Center(
                              child: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 16,
                          )),
                        ),
                      ),
                      if (status == 'Di luar area' && status != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: danger,
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width - 48,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Di luar jangkauan',
                                style: plusJakartaSans.copyWith(
                                    fontWeight: bold,
                                    color: const Color(0xFFFBFBFB)),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Lokasi Anda berada di luar jangkauan . Atur lokasi kamu dalam jarak yang sudah ditetapkan agar Jam Absen Masuk / Absen Pulang kamu bisa tercatat.',
                                style: plusJakartaSans.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFFFBFBFB)),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                        decoration: BoxDecoration(
                            color: neutral100,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 4,
                                width: 85,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                    color: neutral200,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            Text(widget.jenisAbsen,
                                style: plusJakartaSans.copyWith(
                                    fontWeight: semiBold,
                                    fontSize: 28,
                                    color: neutral00)),
                            const SizedBox(
                              height: 3.5,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/ic_kalender_rounded.png',
                                  width: 16,
                                  color: neutral00,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Text('${widget.tanggal} (08.00 - 22.00)',
                                    style: plusJakartaSans.copyWith(
                                        fontWeight: bold,
                                        fontSize: 12,
                                        color: neutral00)),
                              ],
                            ),
                            const SizedBox(
                              height: 23.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              child: CustomFilledButton(
                                  title: 'Kirim Presensi',
                                  isActive:
                                      isGpsEnabled && status == 'Di dalam area',
                                  onPressed: () {
                                    if (isGpsEnabled &&
                                        status == 'Di dalam area') {
                                      _createdAttendance();
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Container(),
    ));
  }

  createMarkers(BuildContext context) {
    if (createMarker < 20) {
      Marker marker;

      // ignore: avoid_function_literals_in_foreach_calls
      _me.forEach((contact) async {
        marker = Marker(
          markerId: MarkerId(contact['name']),
          position: contact['position'],
          icon: await _getAssetIcon(
            context,
            contact['marker'],
          ).then(
            (value) => value,
          ),
          infoWindow: InfoWindow(
            title: contact['name'],
            // snippet: 'Street 6 . 2min ago',
          ),
        );

        setState(() {
          _markers.add(marker);
          createMarker++;
        });
      });
    }
  }

  Future<BitmapDescriptor> _getAssetIcon(
      BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: const Size(5, 5));

    AssetImage(icon)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }
}
