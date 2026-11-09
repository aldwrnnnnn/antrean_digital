import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/queue_ticket.dart';
import '../state/queue_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../widgets/status_badge.dart';

class CounterAdminScreen extends StatelessWidget {
  final VoidCallback onSwitchToVisitorMode;

  const CounterAdminScreen({
    super.key,
    required this.onSwitchToVisitorMode,
  });

  @override
  Widget build(BuildContext context) {
    final queueState = QueueScope.of(context);
    final currentCounter = queueState.selectedCounter;
    final servingTicket = queueState.getServingTicketForCounter(currentCounter.name);

    // Waiting list for this counter's category
    final waitingList = queueState.activeTickets
        .where((t) =>
            t.serviceCategoryId == currentCounter.serviceCategoryId &&
            t.status == TicketStatus.waiting)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'PETUGAS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Panel Loket',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Switch to Visitor Mode Button
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: OutlinedButton.icon(
              onPressed: onSwitchToVisitorMode,
              icon: const Icon(AppIcons.user, size: 14),
              label: const Text('Pengunjung'),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(0, 36),
                textStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Officer badge header
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(AppIcons.userCheck, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Petugas Aktif: ${currentCounter.officerName}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Counter Selector Tabs
              Text(
                'Pilih Loket Bertugas',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: queueState.counters.map((c) {
                    final isSelected = c.id == currentCounter.id;
                    final activeInCounter = queueState.getServingTicketForCounter(c.name);

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            queueState.setSelectedCounterId(c.id);
                          }
                        },
                        avatar: Icon(
                          isSelected ? AppIcons.userCheck : AppIcons.user,
                          size: 14,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                        label: Text('${c.name} ${activeInCounter != null ? '(${activeInCounter.ticketNumber})' : ''}'),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // Active Serving Card
              _buildActiveServingPanel(context, queueState, currentCounter, servingTicket),
              const SizedBox(height: 20),

              // Action Controls
              _buildOfficerActions(context, queueState, currentCounter, servingTicket, waitingList),
              const SizedBox(height: 24),

              // Waiting Queue Section for this counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Antrean Menunggu',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${waitingList.length} orang',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (waitingList.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(AppIcons.checkCircle, size: 36, color: AppColors.statusActive),
                      const SizedBox(height: 10),
                      Text(
                        'Semua Antrean Selesai',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tidak ada pengunjung yang sedang menunggu di ${currentCounter.name}.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: waitingList.length,
                  itemBuilder: (context, index) {
                    final ticket = waitingList[index];
                    final isUser = ticket.isUserTicket;
                    final timeFormat = DateFormat('HH:mm');

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.primarySoft : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isUser ? AppColors.primary : AppColors.border,
                          width: isUser ? 1.5 : 1,
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isUser ? AppColors.primary : AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ticket.ticketNumber,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isUser ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ticket.visitorName,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isUser)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'User Demo',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Diambil ${timeFormat.format(ticket.createdAt)} • Urutan ke-${index + 1}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(status: ticket.status, isCompact: true),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveServingPanel(
    BuildContext context,
    QueueState queueState,
    QueueCounter counter,
    QueueTicket? servingTicket,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: servingTicket != null ? AppColors.statusActive : AppColors.border,
          width: servingTicket != null ? 2 : 1,
        ),
        boxShadow: servingTicket != null
            ? [
                BoxShadow(
                  color: AppColors.statusActive.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              ]
            : AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: servingTicket != null
                          ? AppColors.statusActive
                          : AppColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    servingTicket != null
                        ? 'SEDANG MELAYANI DI ${counter.name.toUpperCase()}'
                        : '${counter.name.toUpperCase()} TERSISA KOSONG',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: servingTicket != null
                          ? AppColors.statusActive
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              if (servingTicket != null)
                StatusBadge(status: servingTicket.status),
            ],
          ),
          const SizedBox(height: 16),

          // Big number or empty
          if (servingTicket != null) ...[
            Text(
              servingTicket.ticketNumber,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 58,
                fontWeight: FontWeight.w800,
                color: AppColors.statusActive,
                letterSpacing: -1,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pengunjung: ${servingTicket.visitorName}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (servingTicket.isUserTicket) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Ini adalah Tiket Aktif Pengunjung Anda',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              servingTicket.calledAt != null
                  ? 'Dipanggil pada ${DateFormat('HH:mm:ss').format(servingTicket.calledAt!)}'
                  : 'Siap dilayani',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ] else ...[
            const Icon(AppIcons.bell, size: 42, color: AppColors.borderSubtle),
            const SizedBox(height: 8),
            Text(
              'Belum Ada Panggilan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tekan tombol "Panggil Antrean Berikutnya" untuk memanggil tiket pertama yang menunggu.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOfficerActions(
    BuildContext context,
    QueueState queueState,
    QueueCounter counter,
    QueueTicket? servingTicket,
    List<QueueTicket> waitingList,
  ) {
    return Column(
      children: [
        // Main Action Button: Panggil Antrean Berikutnya
        ElevatedButton.icon(
          onPressed: waitingList.isEmpty && servingTicket == null
              ? null
              : () {
                  final called = queueState.callNextTicket(counter);
                  if (called != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nomor ${called.ticketNumber} dipanggil ke ${counter.name}'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tidak ada antrean tersisa untuk ${counter.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
          icon: const Icon(AppIcons.bell, size: 20),
          label: Text(
            servingTicket != null
                ? 'Selesaikan & Panggil Berikutnya'
                : 'Panggil Antrean Berikutnya',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 10),

        // Sub Actions: Panggil Ulang, Selesai, Lewati
        Row(
          children: [
            // Panggil Ulang
            Expanded(
              child: OutlinedButton.icon(
                onPressed: servingTicket == null
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Panggilan diulang: Nomor ${servingTicket.ticketNumber} silakan ke ${counter.name}!',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.textPrimary,
                          ),
                        );
                      },
                icon: const Icon(AppIcons.refresh, size: 16),
                label: const Text('Ulang'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(0, 46),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Lewati
            Expanded(
              child: OutlinedButton.icon(
                onPressed: servingTicket == null
                    ? null
                    : () {
                        queueState.skipCurrentTicket(counter.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nomor ${servingTicket.ticketNumber} dilewati (tidak hadir)',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.statusSkipped,
                          ),
                        );
                      },
                icon: const Icon(AppIcons.skipForward, size: 16, color: AppColors.statusSkipped),
                label: Text(
                  'Lewati',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppColors.statusSkipped,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.statusSkippedBorder),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(0, 46),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Selesai
            Expanded(
              child: ElevatedButton.icon(
                onPressed: servingTicket == null
                    ? null
                    : () {
                        queueState.completeCurrentTicket(counter.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nomor ${servingTicket.ticketNumber} telah selesai dilayani',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.statusActive,
                          ),
                        );
                      },
                icon: const Icon(AppIcons.checkCircle, size: 16),
                label: const Text('Selesai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusActive,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(0, 46),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
