import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/queue_ticket.dart';
import '../state/queue_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../widgets/status_badge.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _activeFilter = 'all'; // 'all', 'completed', 'skipped'

  @override
  Widget build(BuildContext context) {
    final queueState = QueueScope.of(context);
    final allHistory = queueState.historyTickets;

    final filteredList = allHistory.where((ticket) {
      if (_activeFilter == 'completed') {
        return ticket.status == TicketStatus.completed;
      } else if (_activeFilter == 'skipped') {
        return ticket.status == TicketStatus.skipped;
      }
      return true;
    }).toList();

    final completedCount = allHistory.where((t) => t.status == TicketStatus.completed).length;
    final skippedCount = allHistory.where((t) => t.status == TicketStatus.skipped).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat Antrean',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Catatan antrean selesai dan terlewat hari ini',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'Semua (${allHistory.length})'),
                    const SizedBox(width: 8),
                    _buildFilterChip('completed', 'Selesai ($completedCount)'),
                    const SizedBox(width: 8),
                    _buildFilterChip('skipped', 'Dilewati ($skippedCount)'),
                  ],
                ),
              ),
            ),

            // History List
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final ticket = filteredList[index];
                        return _buildHistoryItem(context, ticket);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _activeFilter == key;

    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _activeFilter = key;
        });
      },
      label: Text(label),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, QueueTicket ticket) {
    final isCompleted = ticket.status == TicketStatus.completed;
    final timeFormat = DateFormat('HH:mm');
    final completedTimeStr = ticket.completedAt != null
        ? timeFormat.format(ticket.completedAt!)
        : timeFormat.format(ticket.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ticket.isUserTicket ? AppColors.primary : AppColors.border,
          width: ticket.isUserTicket ? 1.5 : 1,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primarySoft : AppColors.statusSkippedBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ticket.ticketNumber,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isCompleted ? AppColors.primary : AppColors.statusSkipped,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket.serviceName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (ticket.isUserTicket) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Tiket Saya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${ticket.visitorName} • ${ticket.counterName}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selesai pukul $completedTimeStr WIB',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    StatusBadge(status: ticket.status, isCompact: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(AppIcons.history, size: 36, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Riwayat',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Daftar tiket yang selesai atau dilewati pada sesi ini akan dicatat di sini.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
