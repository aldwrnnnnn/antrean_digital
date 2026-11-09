import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/queue_ticket.dart';
import '../state/queue_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'digital_ticket_dialog.dart';
import 'status_badge.dart';

class ActiveTicketHeroCard extends StatelessWidget {
  final VoidCallback onTakeTicketPressed;

  const ActiveTicketHeroCard({
    super.key,
    required this.onTakeTicketPressed,
  });

  @override
  Widget build(BuildContext context) {
    final queueState = QueueScope.of(context);
    final userTicket = queueState.activeUserTicket;

    if (userTicket == null) {
      return _buildEmptyTicketCard(context);
    }

    final isCalled = userTicket.status == TicketStatus.called;
    final currentlyServing = queueState.getServingTicketForCategory(userTicket.serviceCategoryId);
    final peopleAhead = queueState.getWaitingPeopleAhead(userTicket);
    final estMinutes = queueState.getEstimatedWaitMinutes(userTicket);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCalled ? AppColors.statusActive : AppColors.border,
          width: isCalled ? 2 : 1,
        ),
        boxShadow: isCalled
            ? [
                BoxShadow(
                  color: AppColors.statusActive.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                )
              ]
            : AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCalled ? AppColors.statusActiveBg : AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isCalled ? AppIcons.bell : AppIcons.ticket,
                        size: 18,
                        color: isCalled ? AppColors.statusActive : AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIKET AKTIF SAYA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Text(
                          userTicket.serviceName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge(status: userTicket.status),
              ],
            ),
          ),

          // Called Banner Notification
          if (isCalled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.statusActiveBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.statusActiveBorder),
              ),
              child: Row(
                children: [
                  const Icon(AppIcons.bell, size: 18, color: AppColors.statusActive),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Giliran Anda! Silakan menuju ${userTicket.counterName}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.statusActive,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Center: Large glanceable queue number
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Nomor Antrean Anda',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userTicket.ticketNumber,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 54,
                      fontWeight: FontWeight.w800,
                      color: isCalled ? AppColors.statusActive : AppColors.primary,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tujuan: ${userTicket.counterName}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // Glanceable Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Sedang Dilayani',
                    value: currentlyServing?.ticketNumber ?? '-',
                    highlightColor: AppColors.textPrimary,
                  ),
                ),
                Container(width: 1, height: 38, color: AppColors.border),
                Expanded(
                  child: _buildStatItem(
                    label: 'Sisa di Depan',
                    value: isCalled ? 'Giliran Anda' : '$peopleAhead orang',
                    highlightColor: isCalled ? AppColors.statusActive : AppColors.statusWaiting,
                  ),
                ),
                Container(width: 1, height: 38, color: AppColors.border),
                Expanded(
                  child: _buildStatItem(
                    label: 'Estimasi Waktu',
                    value: isCalled ? 'Sekarang' : '~$estMinutes mnt',
                    highlightColor: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    onPressed: () => DigitalTicketDialog.show(context, userTicket),
                    icon: const Icon(AppIcons.ticket, size: 16),
                    label: const Text('Tiket Digital'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextButton.icon(
                    onPressed: () => _confirmCancelTicket(context, queueState),
                    icon: const Icon(AppIcons.close, size: 16, color: AppColors.statusSkipped),
                    label: Text(
                      'Batalkan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusSkipped,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color highlightColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: highlightColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyTicketCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              AppIcons.ticket,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Belum Ada Antrean Aktif',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pilih salah satu layanan di bawah untuk mengambil nomor tiket antrean digital Anda.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onTakeTicketPressed,
            icon: const Icon(AppIcons.ticket, size: 18),
            label: const Text('Ambil Antrean Baru'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancelTicket(BuildContext context, QueueState queueState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Batalkan Antrean?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Nomor antrean Anda akan dihapus dan dipindahkan ke riwayat. Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              queueState.cancelUserTicket();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nomor antrean berhasil dibatalkan'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusSkipped,
              minimumSize: const Size(100, 44),
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }
}
