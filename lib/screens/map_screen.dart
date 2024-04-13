import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkio/model/area/get_areas.dart';
import 'package:parkio/service/area_service.dart';
import 'package:parkio/widgets/buttons.dart';
import 'package:parkio/widgets/end_drawer.dart';
import 'package:parkio/widgets/inputs.dart';
import 'package:parkio/widgets/text.dart';

import '../util/assets.dart';
import '../widgets/loading.dart';
import '../widgets/sheets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final AreaService _areaService = AreaService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Area>>? _areasFuture;

  bool _isLoading = false;
  bool _isDrawerOpen = false;
  bool _isCameraMoving = false;

  late String _mapStyle;
  LatLng _currentPosition = const LatLng(0.0, 0.0);
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 18.0,
  );

  double _bottomSheetInitialSize = 0.0;
  double _fabPaddingBottom = 0.0;
  double _searchContainerHeight = 0.0;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _getLocation();
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    _scaffoldKey.currentState!.closeEndDrawer();
  }

  double _recalculateBottomSheetInitialSize(int listSize) {
    final double visibleElementsHeight = listSize >= 2 ? 90.0 * 2 : 90.0;
    final double visibleSpacingHeight =
        listSize > 2 ? 32.0 + (12.0 * 2) : (32.0 * 2) + (12.0 * listSize - 1);
    final double initialSize = (visibleElementsHeight + visibleSpacingHeight) /
        (MediaQuery.of(context).size.height);

    setState(() {
      _searchContainerHeight =
          visibleElementsHeight + visibleSpacingHeight + 40.0 + 38.0;
      _fabPaddingBottom = _searchContainerHeight + 24.0;
      _bottomSheetInitialSize = initialSize;
    });

    return initialSize;
  }

  // Gets user's location and calls the camera update
  _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);
    _updateCamera(location);
  }

  // Updates the camera position
  Future<void> _updateCamera(location) async {
    setState(() {
      _currentPosition = location;
      _cameraPosition = CameraPosition(target: _currentPosition, zoom: 15.0);
    });

    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Initialize the areas list
  List<Area> _parkingAreas = List.empty(growable: true);
  List<Marker> _areaMarkers = List.empty(growable: true);
  List<Polygon> _areaPolygons = List.empty(growable: true);

  // Fetches areas
  Future<List<Area>> _getAreas() async {
    setState(() {
      _isLoading = true;
      _parkingAreas = List.empty(growable: true);
      _areaMarkers = List.empty(growable: true);
      _areaPolygons = List.empty(growable: true);
    });

    try {
      List<Area> response = await _areaService.getAreas();
      final icon =
          await getBitmapDescriptorFromSvgAsset('assets/parking_pin.svg');

      setState(() {
        _isLoading = false;
        _parkingAreas = response;
      });

      for (final area in response) {
        switch (area.coordinates?.length) {
          case null || 0:
            break;
          case 1:
            final coordinates = area.coordinates![0];
            _areaMarkers.add(
              Marker(
                markerId: MarkerId(area.id.toString()),
                icon: icon,
                position: LatLng(
                  double.parse(coordinates.latitude!),
                  double.parse(coordinates.longitude!),
                ),
              ),
            );
            break;
          case > 1:
            final List<LatLng> polygonPoints = List.empty(growable: true);

            for (var coordinates in area.coordinates!) {
              polygonPoints.add(
                LatLng(
                  double.parse(coordinates.latitude!),
                  double.parse(coordinates.longitude!),
                ),
              );
            }

            _areaPolygons.add(
              Polygon(
                polygonId: PolygonId(area.id.toString()),
                fillColor: const Color(0x33837EF3),
                strokeColor: const Color(0xFF837EF3),
                strokeWidth: 2,
                points: polygonPoints,
              ),
            );
            break;
        }
      }

      return response;
    } catch (e) {
      setState(() {
        _isLoading = false;

        // Empty the lists
        _parkingAreas = List.empty(growable: true);
        _areaMarkers = List.empty(growable: true);
        _areaPolygons = List.empty(growable: true);
      });

      final exceptionString = e.toString();
      final editedMessage = exceptionString.substring(
          exceptionString.indexOf(' '), exceptionString.length);
      return Future.error(editedMessage);
    }
  }

  Timer? _areasTimer;

  void _setNewAreasFuture([int milliseconds = 1000]) => {
        _areasTimer?.cancel(),
        _areasTimer = Timer(Duration(milliseconds: milliseconds), () {
          _areasFuture = _getAreas();
        }),
      };

  void _showSearchModalSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
          width: double.infinity,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
        ),
        builder: (BuildContext context) => SearchAreasSheet(
          onClose: () => Navigator.of(context).pop(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _recalculateBottomSheetInitialSize(_parkingAreas.length);

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          // App bar should remain invisible. It is used only to color status bar icons
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              statusBarBrightness:
                  _isDrawerOpen ? Brightness.dark : Brightness.light,
              statusBarIconBrightness:
                  _isDrawerOpen ? Brightness.light : Brightness.dark,
            ),
            elevation: 0.0,
            toolbarHeight: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _cameraPosition,
                myLocationButtonEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                markers: _areaMarkers.toSet(),
                polygons: _areaPolygons.toSet(),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(_mapStyle);
                  _controller.complete(controller);
                },
                onCameraMove: (position) {
                  setState(() {
                    _isCameraMoving = true;
                  });
                },
                onCameraIdle: () {
                  setState(() {
                    _isCameraMoving = false;
                    _setNewAreasFuture();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 60.0, end: 24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MapIconButton(
                      asset: 'assets/ic_menu.svg',
                      backgroundColor: const Color(0xFF2A2C2F),
                      onPressed: _openEndDrawer,
                    ),
                  ],
                ),
              ),
              // Marker of user's location
              _buildUserLocationMarker(),
              // 'My location' FloatingActionButton aligned to bottom-end
              // with padding so it appears above search bar and draggable sheet
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: AnimatedPadding(
                  padding: EdgeInsetsDirectional.only(
                    end: 24.0,
                    bottom: _fabPaddingBottom,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton(
                    shape: const StadiumBorder(),
                    elevation: 0.0,
                    backgroundColor: const Color(0xFF2A2C2F),
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.my_location),
                    onPressed: () {
                      _getLocation();
                    },
                  ),
                ),
              ),
              // Search bar with info messages on blurred semi-transparent bg
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildSearchBar(_searchContainerHeight),
              ),
            ],
          ),
          endDrawer: ParkioEndDrawer(closeEndDrawer: _closeEndDrawer),
          // Hide the sheet with parking areas when user
          // is either loading or if there are no areas to display
          bottomSheet: _isLoading || _parkingAreas.isEmpty
              ? null
              : ParkingAreasSheet(
                  parkingAreaList: _parkingAreas,
                  initialSize: _bottomSheetInitialSize,
                ),
          onEndDrawerChanged: (isOpened) {
            setState(() => _isDrawerOpen = isOpened);
          },
        ),
      ],
    );
  }

  Widget _buildUserLocationMarker() {
    Duration userPinAnimationDuration = const Duration(milliseconds: 300);

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/ic_location_marker_top.svg'),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedOpacity(
                      duration: userPinAnimationDuration,
                      opacity: _isCameraMoving ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Container(
                          height: 6.0,
                          width: 8.0,
                          decoration: const ShapeDecoration(
                            shape: StadiumBorder(),
                            color: Color(0x66000000),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPadding(
                      duration: userPinAnimationDuration,
                      curve: Curves.bounceInOut,
                      padding: EdgeInsets.only(
                        bottom: _isCameraMoving ? 10.0 : 0.0,
                      ),
                      child: SvgPicture.asset(
                          'assets/ic_location_marker_bottom.svg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildSearchBar(double height) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
          color: Color(0x80FFFFFF),
        ),
        height: height,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18.0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 14.0, 24.0, 32.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SearchTextField(
                      controller: _searchController,
                      isEnabled: false,
                      onTap: () => _showSearchModalSheet(),
                    ),
                    const SizedBox(height: 18.0),
                    Expanded(
                      child: FutureBuilder<List<Area>>(
                        future: _areasFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return snapshot.data!.isNotEmpty
                                  ? const SizedBox()
                                  : _buildNoAreasPlaceholder();
                            } else {
                              return _buildErrorMessage();
                            }
                          } else {
                            return buildLoadingPlaceholder(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoAreasPlaceholder() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noAreasMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF101828),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF101828),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6.0),
        TextWithLink(
          text: "{${AppLocalizations.of(context)!.retry}}",
          onTap: (_) {
            _areasFuture = _getAreas();
          },
        ),
      ],
    );
  }
}
