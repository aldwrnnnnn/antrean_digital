import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/queue_ticket.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

class StatusBadge extends StatelessWidget {
  final TicketStatus status;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    Color borderColor;
    IconData icon;
    String labelText;

    switch (status) {
      case TicketStatus.waiting:
        textColor = AppColors.statusWaiting;
        bgColor = AppColors.statusWaitingBg;
        borderColor = AppColors.statusWaitingBorder;
        icon = AppIcons.clock;
        labelText = 'Menunggu';
        break;
      case TicketStatus.called:
        textColor = AppColors.statusActive;
        bgColor = AppColors.statusActiveBg;
        borderColor = AppColors.statusActiveBorder;
        icon = AppIcons.bell;
        labelText = 'Dipanggil';
        break;
      case TicketStatus.completed:
        textColor = AppColors.statusDone;
        bgColor = AppColors.statusDoneBg;
        borderColor = AppColors.statusDoneBorder;
        icon = AppIcons.checkCircle;
        labelText = 'Selesai';
        break;
      case TicketStatus.skipped:
        textColor = AppColors.statusSkipped;
        bgColor = AppColors.statusSkippedBg;
        borderColor = AppColors.statusSkippedBorder;
        icon = AppIcons.skipForward;
        labelText = 'Dilewati';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 12 : 14,
            color: textColor,
          ),
          const SizedBox(width: 5),
          Text(
            labelText,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
