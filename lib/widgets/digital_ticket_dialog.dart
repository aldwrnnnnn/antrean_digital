import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/queue_ticket.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import 'status_badge.dart';

class DigitalTicketDialog extends StatelessWidget {
  final QueueTicket ticket;

  const DigitalTicketDialog({
    super.key,
    required this.ticket,
  });

  static Future<void> show(BuildContext context, QueueTicket ticket) {
    return showDialog(
      context: context,
      builder: (context) => DigitalTicketDialog(ticket: ticket),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id');
    final timeStr = dateFormat.format(ticket.createdAt);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.heroCardShadow,
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              AppIcons.ticket,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ANTREAN DIGITAL',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withValues(alpha: 0.85),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  'Pusat Layanan Terpadu',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(AppIcons.close, color: Colors.white, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),

                    // Main Ticket Body
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Column(
                        children: [
                          Text(
                            ticket.serviceName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Big Ticket Number
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              ticket.ticketNumber,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          StatusBadge(status: ticket.status),
                        ],
                      ),
                    ),

                    // Dashed separator with punch holes
                    Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-12, 0),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              const dashWidth = 5.0;
                              const dashSpace = 4.0;
                              final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(count, (_) {
                                  return SizedBox(
                                    width: dashWidth,
                                    height: 1.5,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(color: AppColors.borderSubtle),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(12, 0),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Ticket Details
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                      child: Column(
                        children: [
                          _buildDetailRow('Nama Pengunjung', ticket.visitorName),
                          const SizedBox(height: 10),
                          _buildDetailRow('Tujuan Loket', ticket.counterName),
                          const SizedBox(height: 10),
                          _buildDetailRow('Waktu Cetak', timeStr),
                          const SizedBox(height: 16),

                          // Pseudo Barcode lines
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(36, (index) {
                                final isThick = index % 3 == 0 || index % 7 == 0;
                                return Container(
                                  width: isThick ? 3.0 : 1.5,
                                  height: double.infinity,
                                  color: AppColors.textPrimary.withValues(alpha: 0.85),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'KODE TIKET: ${ticket.id.toUpperCase()}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tiket berhasil disimpan ke perangkat'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(AppIcons.printer, size: 16),
                              label: const Text('Simpan / Cetak'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                minimumSize: const Size(0, 46),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                minimumSize: const Size(0, 46),
                              ),
                              child: const Text('Tutup'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
