import 'package:flutter_test/flutter_test.dart';
import 'package:antrean_digital/main.dart';
import 'package:antrean_digital/state/queue_state.dart';

void main() {
  testWidgets('Antrean Digital smoke test and initial state verification',
      (WidgetTester tester) async {
    final queueState = QueueState();

    await tester.pumpWidget(AntreanDigitalApp(queueState: queueState));
    await tester.pumpAndSettle();

    // Verify user active ticket is displayed
    expect(find.text('TIKET AKTIF SAYA'), findsOneWidget);
    expect(find.text('A-014'), findsOneWidget);

    // Verify service categories are present
    expect(find.text('Layanan Umum & CS'), findsWidgets);
    expect(find.text('Kasir & Pembayaran'), findsWidgets);
    expect(find.text('Konsultasi & Pengaduan'), findsWidgets);
  });
}
