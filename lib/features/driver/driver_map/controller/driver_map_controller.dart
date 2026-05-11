import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../driverjob/data/driver_job_repository.dart';
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
  final mapJob = Rxn<MapJobModel>();

  // Fallback static camera — updated once real coords load
  static const CameraPosition initialCamera = CameraPosition(
    target: LatLng(23.7776, 90.4055),
    zoom: 13,
  );

  @override
  void onInit() {
    super.onInit();
    // jobId is passed via DriverMapScreen constructor and fetchJobForMap is called from there
    _buildDefaultMarkers();
    _buildDefaultRoute();
  }

  Future<void> fetchJobForMap(String id) async {
    try {
      isLoading.value = true;
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
      );

      _buildMarkers();
      _buildRoute();

      // Move camera to pickup location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(pickupLat, pickupLng), 13),
        );
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
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: job.pickup.name),
      ),
      Marker(
        markerId: const MarkerId('intermediate'),
        position: job.intermediate.position,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: job.intermediate.name),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: job.destination.position,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: job.destination.name),
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
    if (job == null) return;
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.changeStatus(token, job.id, 'picked_up');
      currentProgress.value = DeliveryProgressStatus.pickedUp;
      ToastMessageHelper.showSuccessMessage(
          'Marked as arrived at destination');
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> markAsDelivered(BuildContext context) async {
    final job = mapJob.value;
    if (job == null) {
      context.push(AppRoutes.completeDeliveryScreen);
      return;
    }
    try {
      final token = await PrefsHelper.getString('auth_token');
      await _repo.changeStatus(token, job.id, 'delivered');
      currentProgress.value = DeliveryProgressStatus.delivered;
      if (context.mounted) {
        context.push(AppRoutes.completeDeliveryScreen);
      }
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> pickDeliveryPhoto() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) deliveryPhotoPath.value = picked.path;
  }

  void completeDelivery(BuildContext context) {
    context.go(AppRoutes.deliveryCompletedScreen);
  }

  void callDestination() {
    Get.snackbar('Calling', 'Calling destination...',
        snackPosition: SnackPosition.BOTTOM);
  }

  void toggleBottomSheet() =>
      isBottomSheetExpanded.value = !isBottomSheetExpanded.value;

  @override
  void onClose() {
    mapController?.dispose();
    deliveryNotes.dispose();
    super.onClose();
  }
}
