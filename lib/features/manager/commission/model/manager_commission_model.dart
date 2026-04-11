import 'package:flutter/material.dart';

enum CommissionPaymentStatus { all, paid, unpaid }

enum CommissionBillStatus { all, open, closed }

class ManagerCommissionStat {
  final String label;
  final String value;
  final Color valueColor;

  const ManagerCommissionStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });
}

class CommissionListItem {
  final String saleId;
  final String repName;
  final String repInitials;
  final String area;
  final CommissionBillStatus billStatus;

  const CommissionListItem({
    required this.saleId,
    required this.repName,
    required this.repInitials,
    required this.area,
    required this.billStatus,
  });
}

class CommissionDetailModel {
  final String repName;
  final String repRole;
  final String? repAvatarAsset;
  final CommissionPaymentStatus paymentStatus;

  // Transaction Details card
  final double totalCommissionDue;
  final double saleAmount;
  final double rate;
  final String date;

  // Transaction Details table
  final String saleId;
  final String facility;
  final String territory;
  final String? saleAmount2; // for image7 variant

  // Close Bills
  final List<CommissionBillItem> bills;

  // Split Commission
  final List<CommissionSplitItem> splits;
  final double totalCommissionPool;

  const CommissionDetailModel({
    required this.repName,
    required this.repRole,
    this.repAvatarAsset,
    required this.paymentStatus,
    required this.totalCommissionDue,
    required this.saleAmount,
    required this.rate,
    required this.date,
    required this.saleId,
    required this.facility,
    required this.territory,
    this.saleAmount2,
    required this.bills,
    required this.splits,
    required this.totalCommissionPool,
  });
}

class CommissionBillItem {
  final String billId;
  final String date;
  final double amount;
  final String status;

  const CommissionBillItem({
    required this.billId,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class CommissionSplitItem {
  final String name;
  final int splitPercent;
  final double? splitAmount;
  final String? role;

  const CommissionSplitItem({
    required this.name,
    required this.splitPercent,
    this.splitAmount,
    this.role,
  });
}

class TransactionDetailModel {
  final double amount;
  final bool isPaid;
  final String date;
  final String transactionId;
  final String invoiceLink;
  final String expenseLink;
  final String paymentMethod;
  final String payoutSchedule;
  final String relatedSaleId;
  final String surgeon;
  final String facility;

  const TransactionDetailModel({
    required this.amount,
    required this.isPaid,
    required this.date,
    required this.transactionId,
    required this.invoiceLink,
    required this.expenseLink,
    required this.paymentMethod,
    required this.payoutSchedule,
    required this.relatedSaleId,
    required this.surgeon,
    required this.facility,
  });
}

class CommissionRepRate {
  final String name;
  final String role;
  final String? avatarAsset;
  final String updatedDate;
  final double currentRate;

  const CommissionRepRate({
    required this.name,
    required this.role,
    this.avatarAsset,
    required this.updatedDate,
    required this.currentRate,
  });
}

class TrendDataPoint {
  final String month;
  final double value;

  const TrendDataPoint({required this.month, required this.value});
}