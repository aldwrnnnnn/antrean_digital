import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/main_navigation_screen.dart';
import 'state/queue_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final queueState = QueueState();
  runApp(AntreanDigitalApp(queueState: queueState));
}

class AntreanDigitalApp extends StatelessWidget {
  final QueueState queueState;

  const AntreanDigitalApp({
    super.key,
    required this.queueState,
  });

  @override
  Widget build(BuildContext context) {
    return QueueScope(
      queueState: queueState,
      child: MaterialApp(
        title: 'Antrean Digital',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
