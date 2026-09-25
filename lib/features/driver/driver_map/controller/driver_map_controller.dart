import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../driverjob/controller/driver_job_controller.dart';
import '../../driverjob/data/driver_job_repository.dart';
import '../helpers/marker_helper.dart';
import '../model/driver_map_model.dart';

class DriverMapController extends GetxController {
  final _repo = DriverJobRepository();

  GoogleMapController? mapController;
  final Completer<GoogleMapController> mapCompleter = Completer();

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final currentProgress = DeliveryProgressStatus.inTransit.obs;
  final isBottomSheetExpanded = true.obs;
  final deliveryPhotoPath = ''.obs;
  final deliveryNotes = TextEditingController();

  final isLoading = false.obs;
  final isArrivingAtDestination = false.obs;
  final isCompleting = false.obs;
  final hasNoActiveJob = false.obs;
  final mapJob = Rxn<MapJobModel>();

  // Live location
  final currentPosition = Rxn<LatLng>();
  final distanceToPickup = '-- km'.obs;
  final etaToPickup = '-- min'.obs;
  final locationStatus = 'Locating...'.obs;
  StreamSubscription<Position>? _locationSubscription;
  DateTime? _lastServerUpdate;

  // Cached custom marker icons
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropoffIcon;
  BitmapDescriptor? _waypointIcon;
  Future<void>? _markerIconsFuture;

  // Fallback static camera — updated once real coords load
  static const CameraPosition initialCamera = CameraPosition(
    target: LatLng(23.7776, 90.4055),
    zoom: 13,
  );

  @override
  void onInit() {
    super.onInit();
    _markerIconsFuture = _loadMarkerIcons();
    _buildDefaultMarkers();
    _buildDefaultRoute();
    _startLocationTracking();
  }

  Future<void> _loadMarkerIcons() async {
    final results = await Future.wait([
      MarkerHelper.pickup(),
      MarkerHelper.dropoff(),
      MarkerHelper.waypoint(),
    ]);
    _pickupIcon = results[0];
    _dropoffIcon = results[1];
    _waypointIcon = results[2];
  }

  /// Used by the Map tab (no jobId passed): shows the driver's first active job.
  Future<void> loadActiveJob() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      hasNoActiveJob.value = false;
      final jobCtrl = Get.isRegistered<DriverJobController>()
          ? Get.find<DriverJobController>()
          : Get.put(DriverJobController());
      await jobCtrl.fetchActiveJobs();
      if (jobCtrl.activeJobs.isEmpty) {
        mapJob.value = null;
        hasNoActiveJob.value = true;
        isLoading.value = false;
        return;
      }
      isLoading.value = false;
      await fetchJobForMap(jobCtrl.activeJobs.first.id);
    } catch (e) {
      isLoading.value = false;
      hasNoActiveJob.value = mapJob.value == null;
    }
  }

  Future<void> fetchJobForMap(String id) async {
    try {
      isLoading.value = true;
      hasNoActiveJob.value = false;
      await _markerIconsFuture; // ensure custom icons are ready
      final token = await PrefsHelper.getString('auth_token');
      final response = await _repo.getSingleJob(token, id);
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return;

      // Pickup coords — GeoJSON [lng, lat]
      final pickupCoords =
          data['pickupInfo']?['location']?['coordinates'] as List<dynamic>?;
      final pickupLng = (pickupCoords != null && pickupCoords.length >= 2)
          ? (pickupCoords[0] as num).toDouble()
          : 90.4055;
      final pickupLat = (pickupCoords != null && pickupCoords.length >= 2)
          ? (pickupCoords[1] as num).toDouble()
          : 23.7776;

      // Dropoff coords
      final dropoffCoords =
          data['dropoffInfo']?['location']?['coordinates'] as List<dynamic>?;
      final dropoffLng = (dropoffCoords != null && dropoffCoords.length >= 2)
          ? (dropoffCoords[0] as num).toDouble()
          : 90.4498;
      final dropoffLat = (dropoffCoords != null && dropoffCoords.length >= 2)
          ? (dropoffCoords[1] as num).toDouble()
          : 23.7980;

      final pickupAddress =
          data['pickupInfo']?['address']?.toString() ?? 'Pickup';
      final dropoffAddress =
          data['dropoffInfo']?['address']?.toString() ?? 'Dropoff';

      final facilityRaw = data['dropoffInfo']?['facility'];
      String facilityName = dropoffAddress;
      if (facilityRaw is Map) {
        facilityName = facilityRaw['name']?.toString() ?? dropoffAddress;
      }

      final shipmentStatus =
          _formatStatus(data['shipmentStatus']?.toString() ?? '');
      final totalDistance =
          data['totalDistance']?.toString() ?? '';

      mapJob.value = MapJobModel(
        id: data['_id']?.toString() ?? id,
        shipmentId: data['shipmentId']?.toString() ?? '',
        status: shipmentStatus,
        pickup: RouteStopModel(
          name: pickupAddress,
          address: pickupAddress,
          eta: '',
          position: LatLng(pickupLat, pickupLng),
        ),
        intermediate: RouteStopModel(
          name: dropoffAddress,
          address: dropoffAddress,
          eta: '',
          position: LatLng(dropoffLat, dropoffLng),
        ),
        destination: RouteStopModel(
          name: facilityName,
          address: dropoffAddress,
          eta: '',
          position: LatLng(dropoffLat, dropoffLng),
        ),
        etaToPickup: '',
        distanceMi: totalDistance,
        destinationPhone:
            data['dropoffInfo']?['phoneNumber']?.toString() ?? '',
      );

      _buildMarkers();
      _buildRoute();

      // Move camera to pickup location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(pickupLat, pickupLng), 13),
        );
      }

      // If we already have current position, recalculate distance to new pickup
      final pos = currentPosition.value;
      if (pos != null) {
        _updateCurrentToPickupPolyline(pos);
        _calculateDistanceToPickup(pos);
      }
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  String _formatStatus(String raw) {
    switch (raw) {
      case 'pending_approval':
        return 'Pending Approval';
      case 'accepted':
        return 'Accepted';
      case 'picked_up':
        return 'Picked Up';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      default:
        return raw;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (!mapCompleter.isCompleted) mapCompleter.complete(controller);
    _setDarkMapStyle(controller);
  }

  Future<void> _setDarkMapStyle(GoogleMapController controller) async {
    const style = '''[
      {"elementType":"geometry","stylers":[{"color":"#1d2c4d"}]},
      {"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},
      {"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},
      {"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},
      {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#255763"}]},
      {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2c6675"}]},
      {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]},
      {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#283d6a"}]}
    ]''';
    await controller.setMapStyle(style);
  }

  void _buildMarkers() {
    final job = mapJob.value;
    if (job == null) return;
    markers.assignAll({
      Marker(
        markerId: const MarkerId('pickup'),
        position: job.pickup.position,
        icon: _pickupIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: job.pickup.address,
        ),
        zIndex: 2,
      ),
      Marker(
        markerId: const MarkerId('intermediate'),
        position: job.intermediate.position,
        icon: _waypointIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: 'Waypoint',
          snippet: job.intermediate.address,
        ),
        zIndex: 1,
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: job.destination.position,
        icon: _dropoffIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff',
          snippet: job.destination.address,
        ),
        zIndex: 2,
      ),
    });
  }

  void _buildDefaultMarkers() {
    markers.assignAll({
      Marker(
        markerId: const MarkerId('pickup'),
        position: const LatLng(23.7776, 90.4055),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    });
  }

  void _buildRoute() {
    final job = mapJob.value;
    if (job == null) return;
    polylines.assignAll({
      Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFFEC0101),
        width: 4,
        points: [
          job.pickup.position,
          job.destination.position,
        ],
      ),
    });
  }

  void _buildDefaultRoute() {
    polylines.assignAll({
      Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFFEC0101),
        width: 4,
        points: const [
          LatLng(23.7776, 90.4055),
          LatLng(23.7980, 90.4498),
        ],
      ),
    });
  }

  Future<void> arrivedAtDestination() async {
    final job = mapJob.value;
    if (job == null || isArrivingAtDestination.value) return;
    try {
      isArrivingAtDestination.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.changeStatus(token, job.id, 'in_transit');
      currentProgress.value = DeliveryProgressStatus.inTransit;
      ToastMessageHelper.showSuccessMessage('Marked as arrived at destination');
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isArrivingAtDestination.value = false;
    }
  }

  void markAsDelivered(BuildContext context) {
    context.push(AppRoutes.completeDeliveryScreen);
  }

  Future<void> completeDelivery(BuildContext context) async {
    final job = mapJob.value;
    if (isCompleting.value) return;
    try {
      isCompleting.value = true;
      final token = await PrefsHelper.getString('auth_token');
      if (job != null) {
        // Step 1: picked_up with photo proof + notes
        await _repo.submitDelivery(
          token: token,
          id: job.id,
          notes: deliveryNotes.text.trim(),
          photoPath: deliveryPhotoPath.value.isNotEmpty
              ? deliveryPhotoPath.value
              : null,
        );
        // Step 2: mark as delivered to move job to Completed tab
        await _repo.changeStatus(token, job.id, 'delivered');
      }
      // Refresh job lists so Active tab is up-to-date when user navigates back
      if (Get.isRegistered<DriverJobController>()) {
        Get.find<DriverJobController>().fetchCompletedJobs();
      }
      _resetDeliveryState();
      // Map tab moves on to the next active job (or shows empty state)
      loadActiveJob();
      if (context.mounted) {
        context.go(AppRoutes.deliveryCompletedScreen);
      }
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    } finally {
      isCompleting.value = false;
    }
  }

  void _resetDeliveryState() {
    mapJob.value = null;
    currentProgress.value = DeliveryProgressStatus.inTransit;
    deliveryPhotoPath.value = '';
    deliveryNotes.clear();
    _buildDefaultMarkers();
    _buildDefaultRoute();
  }

  Future<void> pickDeliveryPhoto({ImageSource source = ImageSource.camera}) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) deliveryPhotoPath.value = picked.path;
  }

  Future<void> callDestination() async {
    final phone =
        (mapJob.value?.destinationPhone ?? '').replaceAll(RegExp(r'[^0-9+]'), '');
    if (phone.isEmpty) {
      ToastMessageHelper.showErrorMessage('No phone number available');
      return;
    }
    try {
      final launched = await launchUrl(Uri(scheme: 'tel', path: phone));
      if (!launched) {
        ToastMessageHelper.showErrorMessage('Could not open phone dialer');
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Could not open phone dialer');
    }
  }

  void toggleBottomSheet() =>
      isBottomSheetExpanded.value = !isBottomSheetExpanded.value;


  Future<void> _startLocationTracking() async {
    if (!await _checkLocationPermission()) return;

    // One-shot initial position
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _onPositionUpdate(pos);
    } catch (_) {}

    // Continuous stream — updates every ≥30 m
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 30,
      ),
    ).listen(_onPositionUpdate);
  }

  Future<bool> _checkLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  void _onPositionUpdate(Position pos) {
    final latLng = LatLng(pos.latitude, pos.longitude);
    currentPosition.value = latLng;
    locationStatus.value = 'Live';
    _updateCurrentToPickupPolyline(latLng);
    _calculateDistanceToPickup(latLng);

    // Server update throttled to once per minute
    final now = DateTime.now();
    if (_lastServerUpdate == null ||
        now.difference(_lastServerUpdate!).inSeconds >= 60) {
      _lastServerUpdate = now;
      _updateLocationToServer(pos);
    }
  }

  void _updateCurrentToPickupPolyline(LatLng current) {
    final job = mapJob.value;
    if (job == null) return;
    final updated = Set<Polyline>.from(polylines);
    updated.removeWhere((p) => p.polylineId.value == 'current_to_pickup');
    updated.add(Polyline(
      polylineId: const PolylineId('current_to_pickup'),
      color: const Color(0xFF4A90E2),
      width: 3,
      points: [current, job.pickup.position],
      patterns: [PatternItem.dash(15), PatternItem.gap(10)],
    ));
    polylines.assignAll(updated);
  }

  void _calculateDistanceToPickup(LatLng current) {
    final job = mapJob.value;
    if (job == null) return;
    final meters = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      job.pickup.position.latitude,
      job.pickup.position.longitude,
    );
    final km = meters / 1000;
    distanceToPickup.value = '${km.toStringAsFixed(1)} km';
    final etaMins = (km / 30 * 60).round();
    etaToPickup.value = '$etaMins min';
  }

  Future<void> _updateLocationToServer(Position pos) async {
    try {
      String address = '';
      try {
        final placemarks = await geo.placemarkFromCoordinates(
            pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String>[];
          if (p.subLocality != null && p.subLocality!.isNotEmpty) {
            parts.add(p.subLocality!);
          }
          if (p.locality != null && p.locality!.isNotEmpty) {
            parts.add(p.locality!);
          }
          address = parts.join(', ');
        }
      } catch (_) {}

      final token = await PrefsHelper.getString('auth_token');
      // GeoJSON order: [longitude, latitude]
      await _repo.updateLocation(token, pos.longitude, pos.latitude, address);
      locationStatus.value = 'Updated ✓';
      // revert back to "Live" after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (currentPosition.value != null) locationStatus.value = 'Live';
      });
    } catch (_) {}
  }


  @override
  void onClose() {
    _locationSubscription?.cancel();
    mapController?.dispose();
    deliveryNotes.dispose();
    super.onClose();
  }
}
