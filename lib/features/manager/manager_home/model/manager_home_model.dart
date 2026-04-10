import 'package:flutter/material.dart';

class ManagerStatModel {
  final String iconPath;
  final String label;
  final String value;
  final Color? valueColor;

  const ManagerStatModel({
    required this.iconPath,
    required this.label,
    required this.value,
    this.valueColor,
  });
}

class TeamActivityModel {
  final String memberName;
  final String action;
  final String timeAgo;
  final String location;
  final String? avatarAsset;

  const TeamActivityModel({
    required this.memberName,
    required this.action,
    required this.timeAgo,
    required this.location,
    this.avatarAsset,
  });
}