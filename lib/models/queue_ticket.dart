import 'package:flutter/material.dart';

enum TicketStatus {
  waiting,
  called,
  completed,
  skipped;

  String get label {
    switch (this) {
      case TicketStatus.waiting:
        return 'Menunggu';
      case TicketStatus.called:
        return 'Sedang Dilayani';
      case TicketStatus.completed:
        return 'Selesai';
      case TicketStatus.skipped:
        return 'Dilewati';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.waiting:
        return const Color(0xFFD97706); // Amber 600
      case TicketStatus.called:
        return const Color(0xFF059669); // Emerald 600
      case TicketStatus.completed:
        return const Color(0xFF475569); // Slate 600
      case TicketStatus.skipped:
        return const Color(0xFFE11D48); // Rose 600
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TicketStatus.waiting:
        return const Color(0xFFFEF3C7); // Amber 100
      case TicketStatus.called:
        return const Color(0xFFD1FAE5); // Emerald 100
      case TicketStatus.completed:
        return const Color(0xFFF1F5F9); // Slate 100
      case TicketStatus.skipped:
        return const Color(0xFFFFE4E6); // Rose 100
    }
  }
}

class QueueTicket {
  final String id;
  final String ticketNumber;
  final int sequenceNumber;
  final String serviceCategoryId;
  final String serviceName;
  final String counterName;
  final DateTime createdAt;
  final DateTime? calledAt;
  final DateTime? completedAt;
  final TicketStatus status;
  final bool isUserTicket;
  final String visitorName;
  final String? notes;

  const QueueTicket({
    required this.id,
    required this.ticketNumber,
    required this.sequenceNumber,
    required this.serviceCategoryId,
    required this.serviceName,
    required this.counterName,
    required this.createdAt,
    this.calledAt,
    this.completedAt,
    required this.status,
    this.isUserTicket = false,
    this.visitorName = 'Pengunjung',
    this.notes,
  });

  QueueTicket copyWith({
    String? id,
    String? ticketNumber,
    int? sequenceNumber,
    String? serviceCategoryId,
    String? serviceName,
    String? counterName,
    DateTime? createdAt,
    DateTime? calledAt,
    DateTime? completedAt,
    TicketStatus? status,
    bool? isUserTicket,
    String? visitorName,
    String? notes,
  }) {
    return QueueTicket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      serviceName: serviceName ?? this.serviceName,
      counterName: counterName ?? this.counterName,
      createdAt: createdAt ?? this.createdAt,
      calledAt: calledAt ?? this.calledAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      isUserTicket: isUserTicket ?? this.isUserTicket,
      visitorName: visitorName ?? this.visitorName,
      notes: notes ?? this.notes,
    );
  }
}
