import 'package:flutter/material.dart';

import '../model/payment_model.dart';

class PaymentMethodsController extends ChangeNotifier {
  List<PaymentCardModel> cards = [
    const PaymentCardModel(
      id: '1',
      cardType: 'Visa Card',
      holderName: 'Alex Rodriguez',
      lastFour: '4892',
      isDefault: true,
      cardColor: Color(0xFF3B5BDB),
    ),
    const PaymentCardModel(
      id: '2',
      cardType: 'Visa Debit',
      holderName: 'Alex Rodriguez',
      lastFour: '3456',
      isDefault: false,
      cardColor: Color(0xFF9C36B5),
    ),
  ];

  void setDefault(String id) {
    cards = cards.map((c) => c.copyWith(isDefault: c.id == id)).toList();
    notifyListeners();
  }

  void deleteCard(String id) {
    cards.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void addCard(PaymentCardModel card) {
    cards.add(card);
    notifyListeners();
  }
}