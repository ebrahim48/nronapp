import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/app-routes/app_routes.dart';
import '../model/driver_map_model.dart';


class DriverMapController extends GetxController {
  GoogleMapController? mapController;
  final Completer<GoogleMapController> mapCompleter = Completer();

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final currentProgress = DeliveryProgressStatus.inTransit.obs;
  final isBottomSheetExpanded = true.obs;
  final deliveryPhotoPath = ''.obs;
  final deliveryNotes = TextEditingController();

  final mapJob = const MapJobModel(
    shipmentId: 'SH-2847',
    status: 'En Route to Pickup',
    etaToPickup: '0 mins',
    distanceMi: '2.4 mi',
    pickup: RouteStopModel(
      name: 'Main Warehouse',
      address: '2847 Industrial Ave',
      eta: '8 min',
      position: LatLng(37.7749, -122.4194),
    ),
    intermediate: RouteStopModel(
      name: 'City Hospital',
      address: '4521 Medical Plaza',
      eta: '32 min',
      position: LatLng(37.7849, -122.4094),
    ),
    destination: RouteStopModel(
      name: 'Valley Medical Center',
      address: '',
      eta: '',
      position: LatLng(37.7649, -122.4294),
    ),
  );

  final pickupDetail = const PickupDetailModel(
    location: 'Main Warehouse',
    recipient: 'Sarah Johnson',
    items: '3 containers',
  );

  static const CameraPosition initialCamera = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 13,
  );

  @override
  void onInit() {
    super.onInit();
    _buildMarkers();
    _buildRoute();
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
    markers.assignAll({
      Marker(
        markerId: const MarkerId('pickup'),
        position: mapJob.pickup.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: mapJob.pickup.name),
      ),
      Marker(
        markerId: const MarkerId('intermediate'),
        position: mapJob.intermediate.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: mapJob.intermediate.name),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: mapJob.destination.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: mapJob.destination.name),
      ),
    });
  }

  void _buildRoute() {
    polylines.assignAll({
      Polyline(
        polylineId: const PolylineId('route'),
        color: const Color(0xFFEC0101),
        width: 4,
        points: [
          mapJob.pickup.position,
          const LatLng(37.7789, -122.4144),
          const LatLng(37.7719, -122.4244),
          mapJob.destination.position,
        ],
      ),
    });
  }

  void arrivedAtDestination() {
    currentProgress.value = DeliveryProgressStatus.delivered;
    Get.snackbar('Arrived', 'Marked as arrived at destination',
        snackPosition: SnackPosition.BOTTOM);
  }

  void markAsDelivered(BuildContext context) {
    context.push(AppRoutes.completeDeliveryScreen);
  }

  Future<void> pickDeliveryPhoto() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.camera);
    if (picked != null) deliveryPhotoPath.value = picked.path;
  }

  void completeDelivery(BuildContext context) {
    context.go(AppRoutes.deliveryCompletedScreen);
  }

  void callDestination() {
    Get.snackbar('Calling', 'Calling Valley Medical Center...',
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