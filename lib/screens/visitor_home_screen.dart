import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_category.dart';
import '../state/queue_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../widgets/active_ticket_hero_card.dart';
import '../widgets/service_category_card.dart';
import '../widgets/take_ticket_bottom_sheet.dart';

class VisitorHomeScreen extends StatelessWidget {
  final VoidCallback onSwitchToOfficerMode;

  const VisitorHomeScreen({
    super.key,
    required this.onSwitchToOfficerMode,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    final queueState = QueueScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(AppIcons.ticket, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'Antrean Digital',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.refresh, size: 18, color: AppColors.textSecondary),
            tooltip: 'Reset Data Demo',
            onPressed: () {
              queueState.resetToDemo();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data antrean dikembalikan ke status demo'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, Pengunjung',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.statusActive,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Layanan Buka • 08.00 - 16.00 WIB',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: onSwitchToOfficerMode,
                    icon: const Icon(AppIcons.userCheck, size: 14),
                    label: const Text('Mode Petugas'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      backgroundColor: AppColors.primarySoft,
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(0, 36),
                      textStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hero Section: Tiket Aktif Saya
              ActiveTicketHeroCard(
                onTakeTicketPressed: () => TakeTicketBottomSheet.show(context),
              ),
              const SizedBox(height: 24),

              // Live Counter Status Strip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Papan Panggilan Loket',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Langsung Terhubung',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.statusActive,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildLiveCounterBoard(context, queueState),
              const SizedBox(height: 24),

              // Service Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih Layanan Antrean',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${queueState.totalWaitingCount} antrean aktif',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List of Service Category Cards
              ...queueState.categories.map((category) {
                final waiting = queueState.getWaitingCountForCategory(category.id);
                return ServiceCategoryCard(
                  category: category,
                  waitingCount: waiting,
                  onTap: () => _openTakeTicketForCategory(context, category),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => TakeTicketBottomSheet.show(context),
          icon: const Icon(AppIcons.ticket, size: 20),
          label: const Text('Ambil Nomor Antrean'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveCounterBoard(BuildContext context, QueueState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: state.counters.take(3).map((counter) {
              final serving = state.getServingTicketForCounter(counter.name);
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: serving != null ? AppColors.primarySoft : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: serving != null
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        counter.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serving?.ticketNumber ?? 'Kosong',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: serving != null ? 18 : 13,
                          fontWeight: FontWeight.w800,
                          color: serving != null
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        serving != null ? 'Sedang Layani' : 'Tersedia',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: serving != null
                              ? AppColors.statusActive
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _openTakeTicketForCategory(BuildContext context, ServiceCategory category) {
    TakeTicketBottomSheet.show(context, initialCategory: category);
  }
}
