import 'package:flutter/material.dart';

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? profileUrl;
  final String? bio;
  final String? designation;
  final String? address;
  final String? employeeId;
  final String? territory;
  // Stats
  final int totalPos;
  final String commYtd;
  final double rating;
  final String phone;
  // Representative stats
  final int totalPurchaseOrderCount;
  final double totalCommission;
  // Manager stats
  final int totalSalesCount;
  final double totalSalesAmount;
  final int activeReps;
  // Driver stats
  final double totalEarnings;
  final int totalDeliveries;
  final double successRate;

  final double? latitude;
  final double? longitude;

  const UserProfileModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.role = '',
    this.profileUrl,
    this.bio,
    this.designation,
    this.address,
    this.employeeId,
    this.territory,
    this.totalPos = 0,
    this.commYtd = '',
    this.rating = 0.0,
    this.phone = '',
    this.totalPurchaseOrderCount = 0,
    this.totalCommission = 0.0,
    this.totalSalesCount = 0,
    this.totalSalesAmount = 0.0,
    this.activeReps = 0,
    this.totalEarnings = 0.0,
    this.totalDeliveries = 0,
    this.successRate = 0.0,
    this.latitude,
    this.longitude,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    final stats = json['userStats'] as Map<String, dynamic>? ?? {};

    return UserProfileModel(
      id: user['_id'] ?? '',
      fullName: user['fullName'] ?? '',
      email: user['email'] ?? '',
      role: user['role'] ?? '',
      profileUrl: user['profileUrl'],
      bio: user['bio'],
      designation: user['designation'],
      address: user['address'],
      employeeId: user['employeeId'],
      territory: user['territory'],
      // Representative stats
      totalPurchaseOrderCount:
          (stats['totalPurchaseOrderCount'] as num?)?.toInt() ?? 0,
      totalCommission:
          (stats['totalCommission'] as num?)?.toDouble() ?? 0.0,
      // Manager stats
      totalSalesCount:
          (stats['totalSalesCount'] as num?)?.toInt() ?? 0,
      totalSalesAmount:
          (stats['totalSalesAmount'] as num?)?.toDouble() ?? 0.0,
      activeReps: (stats['activeReps'] as num?)?.toInt() ?? 0,
      // Driver stats
      totalEarnings:
          (stats['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      totalDeliveries:
          (stats['totalDeliveries'] as num?)?.toInt() ?? 0,
      successRate:
          (stats['successRate'] as num?)?.toDouble() ?? 0.0,
      // Location — GeoJSON stores as [lng, lat]
      longitude: () {
        final coords =
            (user['location'] as Map<String, dynamic>?)?['coordinates'] as List?;
        return coords != null && coords.length >= 2
            ? (coords[0] as num?)?.toDouble()
            : null;
      }(),
      latitude: () {
        final coords =
            (user['location'] as Map<String, dynamic>?)?['coordinates'] as List?;
        return coords != null && coords.length >= 2
            ? (coords[1] as num?)?.toDouble()
            : null;
      }(),
    );
  }
}

class SettingsTileModel {
  final String iconPath;
  final String title;
  final String subtitle;
  final String route;
  final IconData? fallbackIcon;

  const SettingsTileModel({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.route,
    this.fallbackIcon,
  });
}

class OthersTileModel {
  final String iconPath;
  final String title;
  final String route;

  const OthersTileModel({
    required this.iconPath,
    required this.title,
    required this.route,
  });
}

class ContentModel {
  final String id;
  final String content;
  final String description;

  const ContentModel({
    required this.id,
    required this.content,
    required this.description,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
