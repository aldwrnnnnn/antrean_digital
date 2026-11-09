import 'package:flutter_test/flutter_test.dart';
import 'package:antrean_digital/models/queue_ticket.dart';
import 'package:antrean_digital/state/queue_state.dart';

void main() {
  group('QueueState Unit Tests', () {
    late QueueState state;

    setUp(() {
      state = QueueState();
    });

    test('Initial demo state is correctly populated', () {
      expect(state.activeUserTicket, isNotNull);
      expect(state.activeUserTicket!.ticketNumber, equals('A-014'));
      expect(state.activeUserTicket!.status, equals(TicketStatus.waiting));

      // Serving ticket at Loket 1
      final servingA = state.getServingTicketForCounter('Loket 1');
      expect(servingA, isNotNull);
      expect(servingA!.ticketNumber, equals('A-011'));
      expect(servingA.status, equals(TicketStatus.called));

      // People ahead of A-014 should be 2 (A-012, A-013)
      final ahead = state.getWaitingPeopleAhead(state.activeUserTicket!);
      expect(ahead, equals(2));

      // Estimated wait time (ahead + 1) * 5 mins = 15 mins
      final est = state.getEstimatedWaitMinutes(state.activeUserTicket!);
      expect(est, equals(15));

      // History should have 4 records
      expect(state.historyTickets.length, equals(4));
    });

    test('Officer calls next ticket sequentially', () {
      final counter = state.counters.firstWhere((c) => c.name == 'Loket 1');

      // Next ticket is A-012
      final called1 = state.callNextTicket(counter);
      expect(called1, isNotNull);
      expect(called1!.ticketNumber, equals('A-012'));
      expect(called1.status, equals(TicketStatus.called));

      // Previous serving A-011 moved to history
      expect(state.historyTickets.any((t) => t.ticketNumber == 'A-011'), isTrue);

      // Now call next: A-013
      final called2 = state.callNextTicket(counter);
      expect(called2!.ticketNumber, equals('A-013'));

      // Now call next: USER TICKET A-014!
      final calledUser = state.callNextTicket(counter);
      expect(calledUser!.ticketNumber, equals('A-014'));
      expect(state.activeUserTicket!.status, equals(TicketStatus.called));
    });

    test('Visitor takes a new ticket', () {
      final category = state.categories.firstWhere((c) => c.id == 'kasir');
      final newTicket = state.takeTicket(
        category: category,
        visitorName: 'Rudi',
      );

      expect(newTicket.ticketNumber.startsWith('B-'), isTrue);
      expect(newTicket.isUserTicket, isTrue);
      expect(state.activeUserTicket!.id, equals(newTicket.id));
    });

    test('Visitor cancels ticket', () {
      expect(state.activeUserTicket, isNotNull);
      state.cancelUserTicket();
      expect(state.activeUserTicket, isNull);
      expect(state.historyTickets.first.status, equals(TicketStatus.skipped));
    });
  });
}
