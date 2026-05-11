import 'package:flutter/material.dart';

enum CommissionPaymentStatus { all, paid, unpaid }
enum CommissionBillStatus { all, open, closed }

// ── Stat card ─────────────────────────────────────────────────────────────────

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

// ── Trend data point ──────────────────────────────────────────────────────────

class TrendDataPoint {
  final String month;
  final double value;

  const TrendDataPoint({required this.month, required this.value});

  factory TrendDataPoint.fromJson(Map<String, dynamic> e) {
    return TrendDataPoint(
      month: e['month']?.toString() ?? '',
      value: (e['totalCommission'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// ── Commission list item ──────────────────────────────────────────────────────

class CommissionListItem {
  final String id;
  final String saleId;
  final String repName;
  final String repInitials;
  final String facilityName;
  final double saleAmount;
  final double commissionAmount;
  final int commissionRate;
  final String date;
  final CommissionBillStatus billStatus;
  final String status; // 'paid' | 'unpaid'

  const CommissionListItem({
    required this.id,
    required this.saleId,
    required this.repName,
    required this.repInitials,
    required this.facilityName,
    required this.saleAmount,
    required this.commissionAmount,
    required this.commissionRate,
    required this.date,
    required this.billStatus,
    required this.status,
  });

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw ?? '';
    }
  }

  factory CommissionListItem.fromJson(Map<String, dynamic> e) {
    final saleMap = e['sale'] is Map ? e['sale'] as Map<String, dynamic> : <String, dynamic>{};
    final facilityMap = saleMap['facility'] is Map ? saleMap['facility'] as Map<String, dynamic> : <String, dynamic>{};
    final billingMap = saleMap['billing'] is Map ? saleMap['billing'] as Map<String, dynamic> : <String, dynamic>{};
    final repsMap = saleMap['representatives'] is Map ? saleMap['representatives'] as Map<String, dynamic> : <String, dynamic>{};
    final repUsers = repsMap['users'] is List ? repsMap['users'] as List : [];
    final invoiceMap = saleMap['invoice'] is Map ? saleMap['invoice'] as Map<String, dynamic> : <String, dynamic>{};

    final status = e['status']?.toString() ?? 'unpaid';
    final invoiceStatus = invoiceMap['status']?.toString() ?? '';

    // Rep name from representativeName field or createdBy
    final repName = e['representativeName']?.toString() ?? '';

    // Commission amount & rate from representatives
    final myCommission = (repsMap['myCommission'] as num?)?.toDouble() ?? 0.0;
    final totalCommission = (repsMap['totalCommission'] as num?)?.toDouble() ?? 0.0;
    final commissionAmount = myCommission > 0 ? myCommission : totalCommission;

    final commissionRate = repUsers.isNotEmpty && repUsers.first is Map
        ? ((repUsers.first as Map)['commissionRate'] as num?)?.toInt() ?? 0
        : 0;

    return CommissionListItem(
      id: e['_id']?.toString() ?? '',
      saleId: saleMap['saleId']?.toString() ?? '',
      repName: repName,
      repInitials: _initials(repName),
      facilityName: facilityMap['facilityName']?.toString() ??
          facilityMap['name']?.toString() ?? '',
      saleAmount: (billingMap['totalAmount'] as num?)?.toDouble() ?? 0.0,
      commissionAmount: commissionAmount,
      commissionRate: commissionRate,
      date: _formatDate(saleMap['procedureDate']?.toString()),
      billStatus: invoiceStatus == 'paid'
          ? CommissionBillStatus.closed
          : CommissionBillStatus.open,
      status: status,
    );
  }
}

// ── Commission detail ─────────────────────────────────────────────────────────

class CommissionDetailModel {
  final String id;
  final String repName;
  final String repRole;
  final String? repAvatarUrl;
  final CommissionPaymentStatus paymentStatus;

  final double totalCommissionDue;
  final double saleAmount;
  final double rate;
  final String date;

  final String saleId;
  final String facility;
  final String territory;

  final List<CommissionBillItem> bills;
  final List<CommissionSplitItem> splits;
  final double totalCommissionPool;

  const CommissionDetailModel({
    required this.id,
    required this.repName,
    required this.repRole,
    this.repAvatarUrl,
    required this.paymentStatus,
    required this.totalCommissionDue,
    required this.saleAmount,
    required this.rate,
    required this.date,
    required this.saleId,
    required this.facility,
    required this.territory,
    required this.bills,
    required this.splits,
    required this.totalCommissionPool,
  });

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) { return raw; }
  }

  factory CommissionDetailModel.fromJson(Map<String, dynamic> e) {
    final saleMap = e['sale'] is Map ? e['sale'] as Map<String, dynamic> : <String, dynamic>{};
    final createdByMap = saleMap['createdBy'] is Map ? saleMap['createdBy'] as Map<String, dynamic> : <String, dynamic>{};
    final facilityMap = saleMap['facility'] is Map ? saleMap['facility'] as Map<String, dynamic> : <String, dynamic>{};
    final billingMap = saleMap['billing'] is Map ? saleMap['billing'] as Map<String, dynamic> : <String, dynamic>{};
    final invoiceMap = saleMap['invoice'] is Map ? saleMap['invoice'] as Map<String, dynamic> : <String, dynamic>{};
    final repsMap = saleMap['representatives'] is Map ? saleMap['representatives'] as Map<String, dynamic> : <String, dynamic>{};
    final repUsers = repsMap['users'] is List ? repsMap['users'] as List : [];

    final status = e['status']?.toString() ?? 'unpaid';
    final totalAmount = (billingMap['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final totalCommission = (repsMap['totalCommission'] as num?)?.toDouble() ?? 0.0;

    // Build splits from rep users
    final splits = repUsers.map((u) {
      final uMap = u is Map ? u as Map<String, dynamic> : <String, dynamic>{};
      return CommissionSplitItem(
        name: uMap['assignRole']?.toString() ?? '',
        splitPercent: (uMap['commissionRate'] as num?)?.toInt() ?? 0,
        splitAmount: (uMap['commission'] as num?)?.toDouble(),
        role: uMap['assignRole']?.toString(),
      );
    }).toList();

    // Invoice as bill
    final bills = invoiceMap.isNotEmpty
        ? [
            CommissionBillItem(
              billId: invoiceMap['invoiceNumber']?.toString() ?? '',
              date: _formatDate(invoiceMap['invoiceDate']?.toString()),
              amount: (invoiceMap['invoiceAmount'] as num?)?.toDouble() ?? 0.0,
              status: invoiceMap['status']?.toString().toUpperCase() ?? '',
            )
          ]
        : <CommissionBillItem>[];

    return CommissionDetailModel(
      id: e['_id']?.toString() ?? '',
      repName: createdByMap['fullName']?.toString() ?? '',
      repRole: 'Sales Representative',
      repAvatarUrl: createdByMap['profileUrl']?.toString(),
      paymentStatus: status == 'paid'
          ? CommissionPaymentStatus.paid
          : CommissionPaymentStatus.unpaid,
      totalCommissionDue: totalCommission,
      saleAmount: totalAmount,
      rate: repUsers.isNotEmpty
          ? (repUsers.first is Map
              ? (repUsers.first as Map)['commissionRate'] as num? ?? 0
              : 0).toDouble()
          : 0.0,
      date: _formatDate(saleMap['procedureDate']?.toString()),
      saleId: saleMap['saleId']?.toString() ?? '',
      facility: facilityMap['address']?.toString() ?? '',
      territory: '',
      bills: bills,
      splits: splits,
      totalCommissionPool: totalCommission,
    );
  }

  static const CommissionDetailModel empty = CommissionDetailModel(
    id: '', repName: '', repRole: '', paymentStatus: CommissionPaymentStatus.unpaid,
    totalCommissionDue: 0, saleAmount: 0, rate: 0, date: '',
    saleId: '', facility: '', territory: '', bills: [], splits: [], totalCommissionPool: 0,
  );
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

// ── Transaction detail ────────────────────────────────────────────────────────

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

  static const TransactionDetailModel empty = TransactionDetailModel(
    amount: 0, isPaid: false, date: '', transactionId: '',
    invoiceLink: '', expenseLink: '', paymentMethod: '',
    payoutSchedule: '', relatedSaleId: '', surgeon: '', facility: '',
  );
}

// ── Commission manage (rep rate) ──────────────────────────────────────────────

class CommissionRepRate {
  final String id;             // commission-manage document _id
  final String representativeId; // representative user _id
  final String name;
  final String role;
  final String? avatarUrl;
  final String updatedDate;
  final double currentRate;
  final double commissionAmount;

  const CommissionRepRate({
    required this.id,
    required this.representativeId,
    required this.name,
    required this.role,
    this.avatarUrl,
    required this.updatedDate,
    required this.currentRate,
    required this.commissionAmount,
  });

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}';
    } catch (_) { return raw; }
  }

  factory CommissionRepRate.fromJson(Map<String, dynamic> e) {
    // representative field can be a Map (populated) or a String (ID only)
    final repMap = e['representative'] is Map
        ? e['representative'] as Map<String, dynamic>
        : <String, dynamic>{};
    final representativeId = repMap.isNotEmpty
        ? repMap['_id']?.toString() ?? ''
        : e['representative']?.toString() ?? '';

    return CommissionRepRate(
      id: e['_id']?.toString() ?? '',
      representativeId: representativeId,
      name: repMap['fullName']?.toString() ?? '',
      role: repMap['role']?.toString() ?? 'Representative',
      avatarUrl: repMap['profileUrl']?.toString(),
      updatedDate: _formatDate(e['updatedAt']?.toString()),
      currentRate: (e['commissionRate'] as num?)?.toDouble() ?? 0.0,
      commissionAmount: (e['commissionAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
