import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DeliveryProgressStatus { accepted, pickedUp, inTransit, delivered }

class RouteStopModel {
  final String name;
  final String address;
  final String eta;
  final LatLng position;

  const RouteStopModel({
    required this.name,
    required this.address,
    required this.eta,
    required this.position,
  });
}

class MapJobModel {
  final String id;
  final String shipmentId;
  final String status;
  final RouteStopModel pickup;
  final RouteStopModel intermediate;
  final RouteStopModel destination;
  final String etaToPickup;
  final String distanceMi;
  final String destinationPhone;

  const MapJobModel({
    required this.id,
    required this.shipmentId,
    required this.status,
    required this.pickup,
    required this.intermediate,
    required this.destination,
    required this.etaToPickup,
    required this.distanceMi,
    this.destinationPhone = '',
  });
}

class PickupDetailModel {
  final String location;
  final String recipient;
  final String items;

  const PickupDetailModel({
    required this.location,
    required this.recipient,
    required this.items,
  });
}
