import 'package:flutter/material.dart';

class PaymentCardModel {
  final String id;
  final String cardType;
  final String holderName;
  final String lastFour;
  final bool isDefault;
  final Color cardColor;

  const PaymentCardModel({
    required this.id,
    required this.cardType,
    required this.holderName,
    required this.lastFour,
    required this.isDefault,
    required this.cardColor,
  });

  PaymentCardModel copyWith({bool? isDefault}) {
    return PaymentCardModel(
      id: id,
      cardType: cardType,
      holderName: holderName,
      lastFour: lastFour,
      isDefault: isDefault ?? this.isDefault,
      cardColor: cardColor,
    );
  }
}