import 'package:flutter/material.dart';
import '../models/service_category.dart';
import '../models/queue_ticket.dart';

class QueueCounter {
  final String id;
  final String name;
  final String serviceCategoryId;
  final String officerName;

  const QueueCounter({
    required this.id,
    required this.name,
    required this.serviceCategoryId,
    required this.officerName,
  });
}

class QueueState extends ChangeNotifier {
  final List<ServiceCategory> categories = ServiceCategory.defaultCategories;

  final List<QueueCounter> counters = const [
    QueueCounter(
      id: 'loket-1',
      name: 'Loket 1',
      serviceCategoryId: 'cs',
      officerName: 'Siti Rahma (CS)',
    ),
    QueueCounter(
      id: 'loket-2',
      name: 'Loket 2',
      serviceCategoryId: 'cs',
      officerName: 'Ahmad Fauzi (CS)',
    ),
    QueueCounter(
      id: 'loket-3',
      name: 'Loket 3',
      serviceCategoryId: 'kasir',
      officerName: 'Rina Kusuma (Kasir)',
    ),
    QueueCounter(
      id: 'ruang-4',
      name: 'Ruang 4',
      serviceCategoryId: 'konsultasi',
      officerName: 'Dr. Hendra (Konsultan)',
    ),
  ];

  late List<QueueTicket> _activeTickets;
  late List<QueueTicket> _historyTickets;
  final Map<String, QueueTicket?> _counterServingMap = {};
  QueueTicket? _userTicket;

  // Selected counter for admin simulation view
  String _selectedCounterId = 'loket-1';

  QueueState() {
    _initializeInitialData();
  }

  String get selectedCounterId => _selectedCounterId;
  void setSelectedCounterId(String counterId) {
    if (_selectedCounterId != counterId) {
      _selectedCounterId = counterId;
      notifyListeners();
    }
  }

  QueueCounter get selectedCounter =>
      counters.firstWhere((c) => c.id == _selectedCounterId, orElse: () => counters.first);

  List<QueueTicket> get activeTickets => List.unmodifiable(_activeTickets);
  List<QueueTicket> get historyTickets => List.unmodifiable(_historyTickets);
  QueueTicket? get userTicket => _userTicket;

  QueueTicket? get activeUserTicket {
    if (_userTicket == null) return null;
    if (_userTicket!.status == TicketStatus.waiting ||
        _userTicket!.status == TicketStatus.called) {
      return _userTicket;
    }
    return null;
  }

  QueueTicket? getServingTicketForCounter(String counterName) {
    return _counterServingMap[counterName];
  }

  QueueTicket? getServingTicketForCategory(String categoryId) {
    for (final ticket in _counterServingMap.values) {
      if (ticket != null && ticket.serviceCategoryId == categoryId) {
        return ticket;
      }
    }
    return null;
  }

  int getWaitingCountForCategory(String categoryId) {
    return _activeTickets
        .where((t) => t.serviceCategoryId == categoryId && t.status == TicketStatus.waiting)
        .length;
  }

  int getWaitingPeopleAhead(QueueTicket ticket) {
    if (ticket.status == TicketStatus.called) return 0;
    int count = 0;
    for (final item in _activeTickets) {
      if (item.serviceCategoryId == ticket.serviceCategoryId &&
          item.status == TicketStatus.waiting &&
          item.sequenceNumber < ticket.sequenceNumber) {
        count++;
      }
    }
    return count;
  }

  int getEstimatedWaitMinutes(QueueTicket ticket) {
    final ahead = getWaitingPeopleAhead(ticket);
    final category = categories.firstWhere(
      (c) => c.id == ticket.serviceCategoryId,
      orElse: () => categories.first,
    );
    // Estimated time is (people ahead + 1 currently being served) * duration
    return (ahead + 1) * category.averageDurationMinutes;
  }

  int get totalWaitingCount =>
      _activeTickets.where((t) => t.status == TicketStatus.waiting).length;

  int get totalServedToday =>
      _historyTickets.where((t) => t.status == TicketStatus.completed).length;

  // Take a new ticket
  QueueTicket takeTicket({
    required ServiceCategory category,
    String visitorName = 'Pengunjung',
    String? notes,
  }) {
    // Determine next sequence number
    int maxSeq = 0;
    for (final t in [..._activeTickets, ..._historyTickets]) {
      if (t.serviceCategoryId == category.id && t.sequenceNumber > maxSeq) {
        maxSeq = t.sequenceNumber;
      }
    }
    final nextSeq = maxSeq + 1;
    final ticketCode = '${category.codePrefix}-${nextSeq.toString().padLeft(3, '0')}';

    final newTicket = QueueTicket(
      id: 'ticket-${DateTime.now().millisecondsSinceEpoch}',
      ticketNumber: ticketCode,
      sequenceNumber: nextSeq,
      serviceCategoryId: category.id,
      serviceName: category.name,
      counterName: category.defaultCounter,
      createdAt: DateTime.now(),
      status: TicketStatus.waiting,
      isUserTicket: true,
      visitorName: visitorName,
      notes: notes,
    );

    _activeTickets.add(newTicket);
    _userTicket = newTicket;
    notifyListeners();
    return newTicket;
  }

  // Officer / Admin: Call next ticket for a counter
  QueueTicket? callNextTicket(QueueCounter counter) {
    // If current ticket is serving, auto-complete it
    final current = _counterServingMap[counter.name];
    if (current != null) {
      completeCurrentTicket(counter.name);
    }

    // Find next ticket in line for this counter's category
    final nextIndex = _activeTickets.indexWhere(
      (t) => t.serviceCategoryId == counter.serviceCategoryId && t.status == TicketStatus.waiting,
    );

    if (nextIndex == -1) {
      notifyListeners();
      return null;
    }

    final target = _activeTickets[nextIndex];
    final updated = target.copyWith(
      status: TicketStatus.called,
      calledAt: DateTime.now(),
      counterName: counter.name,
    );

    _activeTickets[nextIndex] = updated;
    _counterServingMap[counter.name] = updated;

    if (_userTicket?.id == updated.id) {
      _userTicket = updated;
    }

    notifyListeners();
    return updated;
  }

  // Officer: Complete ticket currently at counter
  void completeCurrentTicket(String counterName) {
    final current = _counterServingMap[counterName];
    if (current == null) return;

    final completedTicket = current.copyWith(
      status: TicketStatus.completed,
      completedAt: DateTime.now(),
    );

    _activeTickets.removeWhere((t) => t.id == current.id);
    _historyTickets.insert(0, completedTicket);
    _counterServingMap[counterName] = null;

    if (_userTicket?.id == current.id) {
      _userTicket = completedTicket;
    }

    notifyListeners();
  }

  // Officer: Skip ticket
  void skipCurrentTicket(String counterName) {
    final current = _counterServingMap[counterName];
    if (current == null) return;

    final skippedTicket = current.copyWith(
      status: TicketStatus.skipped,
      completedAt: DateTime.now(),
    );

    _activeTickets.removeWhere((t) => t.id == current.id);
    _historyTickets.insert(0, skippedTicket);
    _counterServingMap[counterName] = null;

    if (_userTicket?.id == current.id) {
      _userTicket = skippedTicket;
    }

    notifyListeners();
  }

  // User: Cancel their own ticket
  void cancelUserTicket() {
    if (_userTicket == null) return;
    final current = _userTicket!;

    final cancelledTicket = current.copyWith(
      status: TicketStatus.skipped,
      completedAt: DateTime.now(),
      notes: 'Dibatalkan oleh pengunjung',
    );

    _activeTickets.removeWhere((t) => t.id == current.id);
    _historyTickets.insert(0, cancelledTicket);

    for (final entry in _counterServingMap.entries) {
      if (entry.value?.id == current.id) {
        _counterServingMap[entry.key] = null;
      }
    }

    _userTicket = cancelledTicket;
    notifyListeners();
  }

  // Reset to initial dummy state
  void resetToDemo() {
    _initializeInitialData();
    notifyListeners();
  }

  void _initializeInitialData() {
    final now = DateTime.now();

    // Currently called tickets
    final ticketA11 = QueueTicket(
      id: 'ticket-a-011',
      ticketNumber: 'A-011',
      sequenceNumber: 11,
      serviceCategoryId: 'cs',
      serviceName: 'Layanan Umum & CS',
      counterName: 'Loket 1',
      createdAt: now.subtract(const Duration(minutes: 20)),
      calledAt: now.subtract(const Duration(minutes: 2)),
      status: TicketStatus.called,
      visitorName: 'Dewi Lestari',
    );

    final ticketB8 = QueueTicket(
      id: 'ticket-b-008',
      ticketNumber: 'B-008',
      sequenceNumber: 8,
      serviceCategoryId: 'kasir',
      serviceName: 'Kasir & Pembayaran',
      counterName: 'Loket 3',
      createdAt: now.subtract(const Duration(minutes: 15)),
      calledAt: now.subtract(const Duration(minutes: 1)),
      status: TicketStatus.called,
      visitorName: 'Surya Pratama',
    );

    final ticketC4 = QueueTicket(
      id: 'ticket-c-004',
      ticketNumber: 'C-004',
      sequenceNumber: 4,
      serviceCategoryId: 'konsultasi',
      serviceName: 'Konsultasi & Pengaduan',
      counterName: 'Ruang 4',
      createdAt: now.subtract(const Duration(minutes: 25)),
      calledAt: now.subtract(const Duration(minutes: 5)),
      status: TicketStatus.called,
      visitorName: 'Hariyanto',
    );

    // Waiting tickets ahead of user
    final ticketA12 = QueueTicket(
      id: 'ticket-a-012',
      ticketNumber: 'A-012',
      sequenceNumber: 12,
      serviceCategoryId: 'cs',
      serviceName: 'Layanan Umum & CS',
      counterName: 'Loket 1',
      createdAt: now.subtract(const Duration(minutes: 12)),
      status: TicketStatus.waiting,
      visitorName: 'Rudi Hartono',
    );

    final ticketA13 = QueueTicket(
      id: 'ticket-a-013',
      ticketNumber: 'A-013',
      sequenceNumber: 13,
      serviceCategoryId: 'cs',
      serviceName: 'Layanan Umum & CS',
      counterName: 'Loket 2',
      createdAt: now.subtract(const Duration(minutes: 8)),
      status: TicketStatus.waiting,
      visitorName: 'Maya Indah',
    );

    // USER TICKET: A-014 (3 people ahead: A-011 serving, A-012 waiting, A-013 waiting)
    final ticketA14 = QueueTicket(
      id: 'ticket-a-014',
      ticketNumber: 'A-014',
      sequenceNumber: 14,
      serviceCategoryId: 'cs',
      serviceName: 'Layanan Umum & CS',
      counterName: 'Loket 1',
      createdAt: now.subtract(const Duration(minutes: 5)),
      status: TicketStatus.waiting,
      isUserTicket: true,
      visitorName: 'Anda (Pengunjung)',
    );

    final ticketB9 = QueueTicket(
      id: 'ticket-b-009',
      ticketNumber: 'B-009',
      sequenceNumber: 9,
      serviceCategoryId: 'kasir',
      serviceName: 'Kasir & Pembayaran',
      counterName: 'Loket 3',
      createdAt: now.subtract(const Duration(minutes: 6)),
      status: TicketStatus.waiting,
      visitorName: 'Kurnia Fitri',
    );

    final ticketC5 = QueueTicket(
      id: 'ticket-c-005',
      ticketNumber: 'C-005',
      sequenceNumber: 5,
      serviceCategoryId: 'konsultasi',
      serviceName: 'Konsultasi & Pengaduan',
      counterName: 'Ruang 4',
      createdAt: now.subtract(const Duration(minutes: 10)),
      status: TicketStatus.waiting,
      visitorName: 'Tri Wahyudi',
    );

    _activeTickets = [
      ticketA11,
      ticketB8,
      ticketC4,
      ticketA12,
      ticketA13,
      ticketA14,
      ticketB9,
      ticketC5,
    ];

    _userTicket = ticketA14;

    _counterServingMap['Loket 1'] = ticketA11;
    _counterServingMap['Loket 2'] = null;
    _counterServingMap['Loket 3'] = ticketB8;
    _counterServingMap['Ruang 4'] = ticketC4;

    _historyTickets = [
      QueueTicket(
        id: 'hist-1',
        ticketNumber: 'A-010',
        sequenceNumber: 10,
        serviceCategoryId: 'cs',
        serviceName: 'Layanan Umum & CS',
        counterName: 'Loket 1',
        createdAt: now.subtract(const Duration(minutes: 40)),
        calledAt: now.subtract(const Duration(minutes: 25)),
        completedAt: now.subtract(const Duration(minutes: 15)),
        status: TicketStatus.completed,
        visitorName: 'Bambang Sudiro',
      ),
      QueueTicket(
        id: 'hist-2',
        ticketNumber: 'B-007',
        sequenceNumber: 7,
        serviceCategoryId: 'kasir',
        serviceName: 'Kasir & Pembayaran',
        counterName: 'Loket 3',
        createdAt: now.subtract(const Duration(minutes: 35)),
        calledAt: now.subtract(const Duration(minutes: 22)),
        completedAt: now.subtract(const Duration(minutes: 16)),
        status: TicketStatus.completed,
        visitorName: 'Mega Puspita',
      ),
      QueueTicket(
        id: 'hist-3',
        ticketNumber: 'A-009',
        sequenceNumber: 9,
        serviceCategoryId: 'cs',
        serviceName: 'Layanan Umum & CS',
        counterName: 'Loket 2',
        createdAt: now.subtract(const Duration(minutes: 50)),
        calledAt: now.subtract(const Duration(minutes: 38)),
        completedAt: now.subtract(const Duration(minutes: 28)),
        status: TicketStatus.completed,
        visitorName: 'Joko Susanto',
      ),
      QueueTicket(
        id: 'hist-4',
        ticketNumber: 'C-003',
        sequenceNumber: 3,
        serviceCategoryId: 'konsultasi',
        serviceName: 'Konsultasi & Pengaduan',
        counterName: 'Ruang 4',
        createdAt: now.subtract(const Duration(minutes: 55)),
        calledAt: now.subtract(const Duration(minutes: 42)),
        completedAt: now.subtract(const Duration(minutes: 30)),
        status: TicketStatus.completed,
        visitorName: 'Anita Wijaya',
      ),
    ];
  }
}

class QueueScope extends InheritedNotifier<QueueState> {
  const QueueScope({
    super.key,
    required QueueState queueState,
    required super.child,
  }) : super(notifier: queueState);

  static QueueState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<QueueScope>();
    assert(scope != null, 'No QueueScope found in context');
    return scope!.notifier!;
  }
}
