import 'package:flutter/material.dart';
import '../theme/app_icons.dart';

class ServiceCategory {
  final String id;
  final String name;
  final String codePrefix;
  final String description;
  final IconData icon;
  final String defaultCounter;
  final int averageDurationMinutes;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.codePrefix,
    required this.description,
    required this.icon,
    required this.defaultCounter,
    required this.averageDurationMinutes,
  });

  static List<ServiceCategory> get defaultCategories => const [
        ServiceCategory(
          id: 'cs',
          name: 'Layanan Umum & CS',
          codePrefix: 'A',
          description: 'Pendaftaran, informasi umum, dan administrasi berkas',
          icon: AppIcons.users,
          defaultCounter: 'Loket 1',
          averageDurationMinutes: 5,
        ),
        ServiceCategory(
          id: 'kasir',
          name: 'Kasir & Pembayaran',
          codePrefix: 'B',
          description: 'Pembayaran tagihan, retribusi, dan konfirmasi transaksi',
          icon: AppIcons.creditCard,
          defaultCounter: 'Loket 3',
          averageDurationMinutes: 4,
        ),
        ServiceCategory(
          id: 'konsultasi',
          name: 'Konsultasi & Pengaduan',
          codePrefix: 'C',
          description: 'Bimbingan teknis perizinan dan penyampaian aspirasi',
          icon: AppIcons.help,
          defaultCounter: 'Ruang 4',
          averageDurationMinutes: 10,
        ),
      ];
}
