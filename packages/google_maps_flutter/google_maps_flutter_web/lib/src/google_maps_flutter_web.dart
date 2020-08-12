part of google_maps_flutter_web;

/// The web implementation of [GoogleMapsFlutterPlatform].
///
/// This class implements the `package:google_maps_flutter` functionality for the web.
class GoogleMapsPlugin extends GoogleMapsFlutterPlatform {
  /// Registers this class as the default instance of [GoogleMapsFlutterPlatform].
  static void registerWith(Registrar registrar) {
    GoogleMapsFlutterPlatform.instance = GoogleMapsPlugin();
  }

  // A cache of map controllers by map Id.
  Map _mapById = Map<int, GoogleMapController>();

  // Convenience getter for a stream of events filtered by their mapId.
  Stream<MapEvent> _events(int mapId) => _map(mapId).events;

  // Convenience getter for a map controller by its mapId.
  GoogleMapController _map(int mapId) {
    final controller = _mapById[mapId];
    assert(controller != null,
        'Attempted to retrieve a map before its initialization!');
    return controller;
  }

  @override
  Future<void> init(int mapId) async {
    _map(mapId).init();
  }

  /// Updates the options of a given `mapId`.
  ///
  /// This attempts to merge the new `optionsUpdate` passed in, with the previous
  /// options passed to the map (in other updates, or when creating it).
  @override
  Future<void> updateMapOptions(
    Map<String, dynamic> optionsUpdate, {
    @required int mapId,
  }) async {
    _map(mapId).updateRawOptions(optionsUpdate);
  }

  /// Applies the passed in `markerUpdates` to the `mapId`.
  @override
  Future<void> updateMarkers(
    MarkerUpdates markerUpdates, {
    @required int mapId,
  }) async {
    _map(mapId).updateMarkers(markerUpdates);
  }

  /// Applies the passed in `polygonUpdates` to the `mapId`.
  @override
  Future<void> updatePolygons(
    PolygonUpdates polygonUpdates, {
    @required int mapId,
  }) async {
    _map(mapId).updatePolygons(polygonUpdates);
  }

  /// Applies the passed in `polylineUpdates` to the `mapId`.
  @override
  Future<void> updatePolylines(
    PolylineUpdates polylineUpdates, {
    @required int mapId,
  }) async {
    _map(mapId).updatePolylines(polylineUpdates);
  }

  /// Applies the passed in `circleUpdates` to the `mapId`.
  @override
  Future<void> updateCircles(
    CircleUpdates circleUpdates, {
    @required int mapId,
  }) async {
    _map(mapId).updateCircles(circleUpdates);
  }

  /// Applies the given `cameraUpdate` to the current viewport (with animation).
  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    @required int mapId,
  }) async {
    return moveCamera(cameraUpdate, mapId: mapId);
  }

  /// Applies the given `cameraUpdate` to the current viewport.
  @override
  Future<void> moveCamera(
    CameraUpdate cameraUpdate, {
    @required int mapId,
  }) async {
    return _map(mapId).moveCamera(cameraUpdate);
  }

  /// Sets the passed-in `mapStyle` to the map.
  ///
  /// This function just adds a 'styles' option to the current map options.
  ///
  /// Subsequent calls to this method override previous calls, you need to
  /// pass full styles.
  @override
  Future<void> setMapStyle(
    String mapStyle, {
    @required int mapId,
  }) async {
    _map(mapId).updateRawOptions({
      'styles': _mapStyles(mapStyle),
    });
  }

  /// Returns the bounds of the current viewport.
  @override
  Future<LatLngBounds> getVisibleRegion({
    @required int mapId,
  }) {
    return _map(mapId).getVisibleRegion();
  }

  /// Returns the screen coordinate (in pixels) of a given `latLng`.
  @override
  Future<ScreenCoordinate> getScreenCoordinate(
    LatLng latLng, {
    @required int mapId,
  }) {
    return _map(mapId).getScreenCoordinate(latLng);
  }

  /// Returns the [LatLng] of a [ScreenCoordinate] of the viewport.
  @override
  Future<LatLng> getLatLng(
    ScreenCoordinate screenCoordinate, {
    @required int mapId,
  }) {
    return _map(mapId).getLatLng(screenCoordinate);
  }

  /// Shows the [InfoWindow] (if any) of the [Marker] identified by `markerId`.
  @override
  Future<void> showMarkerInfoWindow(
    MarkerId markerId, {
    @required int mapId,
  }) async {
    _map(mapId).showInfoWindow(markerId);
  }

  /// Hides the [InfoWindow] (if any) of the [Marker] identified by `markerId`.
  @override
  Future<void> hideMarkerInfoWindow(
    MarkerId markerId, {
    @required int mapId,
  }) async {
    _map(mapId).hideInfoWindow(markerId);
  }

  /// Returns true if the [InfoWindow] of the [Marker] identified by `markerId` is shown.
  @override
  Future<bool> isMarkerInfoWindowShown(
    MarkerId markerId, {
    @required int mapId,
  }) {
    return _map(mapId).isInfoWindowShown(markerId);
  }

  /// Returns the zoom level of the `mapId`.
  @override
  Future<double> getZoomLevel({
    @required int mapId,
  }) {
    return _map(mapId).getZoomLevel();
  }

  // The following are the 11 possible streams of data from the native side
  // into the plugin

  @override
  Stream<CameraMoveStartedEvent> onCameraMoveStarted({@required int mapId}) {
    return _events(mapId).whereType<CameraMoveStartedEvent>();
  }

  @override
  Stream<CameraMoveEvent> onCameraMove({@required int mapId}) {
    return _events(mapId).whereType<CameraMoveEvent>();
  }

  @override
  Stream<CameraIdleEvent> onCameraIdle({@required int mapId}) {
    return _events(mapId).whereType<CameraIdleEvent>();
  }

  @override
  Stream<MarkerTapEvent> onMarkerTap({@required int mapId}) {
    return _events(mapId).whereType<MarkerTapEvent>();
  }

  @override
  Stream<InfoWindowTapEvent> onInfoWindowTap({@required int mapId}) {
    return _events(mapId).whereType<InfoWindowTapEvent>();
  }

  @override
  Stream<MarkerDragEndEvent> onMarkerDragEnd({@required int mapId}) {
    return _events(mapId).whereType<MarkerDragEndEvent>();
  }

  @override
  Stream<PolylineTapEvent> onPolylineTap({@required int mapId}) {
    return _events(mapId).whereType<PolylineTapEvent>();
  }

  @override
  Stream<PolygonTapEvent> onPolygonTap({@required int mapId}) {
    return _events(mapId).whereType<PolygonTapEvent>();
  }

  @override
  Stream<CircleTapEvent> onCircleTap({@required int mapId}) {
    return _events(mapId).whereType<CircleTapEvent>();
  }

  @override
  Stream<MapTapEvent> onTap({@required int mapId}) {
    return _events(mapId).whereType<MapTapEvent>();
  }

  @override
  Stream<MapLongPressEvent> onLongPress({@required int mapId}) {
    return _events(mapId).whereType<MapLongPressEvent>();
  }

  /// Disposes of the current map. It can't be used afterwards!
  @override
  void dispose({@required int mapId}) {
    _map(mapId)?.dispose();
    _mapById.remove(mapId);
  }

  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated) {
    int mapId = creationParams.remove('_webOnlyMapCreationId');

    if (mapId == null) {
      throw PlatformException(
        code: 'maps_web_missing_creation_map_id',
        message:
            'Pass a `_webOnlyMapCreationId` in creationParams to prevent reloads in web.',
      );
    }

    // Bail fast if we've already rendered this mapId...
    if (_mapById[mapId]?.widget != null) {
      return _mapById[mapId].widget;
    }

    final StreamController<MapEvent> controller =
        StreamController<MapEvent>.broadcast();

    final mapController = GoogleMapController(
      mapId: mapId,
      streamController: controller,
      rawOptions: creationParams,
    );

    _mapById[mapId] = mapController;

    onPlatformViewCreated.call(mapId);

    return mapController.widget;
  }
}
