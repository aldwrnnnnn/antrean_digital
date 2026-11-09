# 🎫 Antrean Digital (Digital Queue System)

[![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Author](https://img.shields.io/badge/Author-Gede%20Aldi%20Irawan-blueviolet)](https://github.com/aldwrnnnnn)

**Antrean Digital** adalah aplikasi sistem manajemen antrean digital modern berbasis **Flutter**. Aplikasi ini dirancang untuk mempermudah alur pelayanan publik maupun komersial, menghubungkan pengunjung yang mengambil nomor antrean secara mandiri dengan petugas loket yang melayani pemanggilan secara terstruktur dan real-time.

---

## 🌟 Fitur Utama

### 1. 👥 Antarmuka Pengunjung (Visitor Flow)
- **Katalog Layanan & Informasi Real-Time**: Menampilkan kategori layanan (Layanan Umum & CS, Kasir & Pembayaran, Konsultasi & Pengaduan) lengkap dengan kuota antrean dan perkiraan waktu tunggu (*waiting time*).
- **Pengambilan Tiket Mandiri**: Pengunjung dapat mengambil tiket dengan satu ketukan melalui dialog konfirmasi interaktif.
- **Hero Card Tiket Aktif**: Menampilkan tiket yang sedang aktif dimiliki oleh pengunjung, status terkini (*Menunggu*, *Dipanggil*, *Sedang Dilayani*, *Selesai*), nomor loket tujuan, dan sisa orang di depan antrean.
- **Digital Ticket Pass / QR**: Tampilan tiket digital interaktif yang siap ditunjukkan kepada petugas saat dipanggil.

### 2. 🖥️ Panel Petugas / Loket (Counter Admin Flow)
- **Manajemen Multi-Loket**: Petugas dapat memilih loket aktif (Loket 1, Loket 2, Loket 3, Ruang 4) dengan identitas petugas.
- **Alur Kontrol Antrean Lengkap**:
  - 📢 **Panggil Berikutnya (*Call Next*)**: Memanggil antrean terdepan pada kategori layanan loket tersebut.
  - 🔁 **Panggil Ulang (*Recall*)**: Memanggil kembali nomor tiket yang sedang aktif.
  - ⏱️ **Mulai Layani (*Serve*)**: Mengubah status antrean menjadi sedang dalam penanganan.
  - ✅ **Selesaikan (*Complete*)**: Menyelesaikan proses pelayanan tiket dan memindahkan ke riwayat.

### 3. 📋 Riwayat Pelayanan (Queue History)
- Pencatatan seluruh alur antrean yang telah selesai maupun dibatalkan.
- Informasi lengkap mengenai waktu pengambilan, waktu pemanggilan, petugas yang melayani, dan durasi penanganan.

### 4. 🎨 Desain Modern & Responsif
- Dibangun dengan panduan **Material 3** yang bersih dan elegan.
- Tipografi modern menggunakan **Google Fonts**.
- Tata letak responsif yang nyaman digunakan pada perangkat mobile (Android & iOS).

---

## 🏗️ Arsitektur & Struktur Proyek

Aplikasi dikembangkan dengan pola arsitektur modular yang rapi:

```text
lib/
├── main.dart                  # Entry point aplikasi & inisialisasi state/locale
├── models/
│   ├── queue_ticket.dart      # Model data tiket antrean & enum status
│   └── service_category.dart  # Model kategori layanan & konfigurasi loket
├── screens/
│   ├── main_navigation_screen.dart # Navigasi utama (BottomNavigationBar)
│   ├── visitor_home_screen.dart    # Beranda pengunjung & ambil antrean
│   ├── counter_admin_screen.dart   # Panel simulasi loket & pemanggilan
│   └── history_screen.dart         # Halaman riwayat pelayanan
├── state/
│   └── queue_state.dart       # State management antrean (ChangeNotifier & Scope)
├── theme/
│   ├── app_colors.dart        # Palet warna konsisten
│   ├── app_icons.dart         # Pemetaan ikon sistem
│   └── app_theme.dart         # Konfigurasi ThemeData Material 3
└── widgets/
    ├── active_ticket_hero_card.dart  # Kartu banner tiket aktif pengguna
    ├── digital_ticket_dialog.dart    # Modal dialog detail tiket digital
    ├── service_category_card.dart    # Kartu pemilihan kategori layanan
    ├── status_badge.dart             # Indikator status tiket (Waiting/Called/dll.)
    └── take_ticket_bottom_sheet.dart # Bottom sheet konfirmasi ambil nomor
```

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.13.5 atau lebih baru)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code dengan ekstensi Flutter & Dart
- Emulator Android / iOS atau perangkat fisik

### Langkah Instalasi

1. **Clone Repositori**:
   ```bash
   git clone https://github.com/aldwrnnnnn/antrean_digital.git
   cd antrean_digital
   ```

2. **Pasang Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```

4. **Menjalankan Pengujian (Testing)**:
   ```bash
   flutter test
   ```

---

## 📦 Dependensi Utama

| Paket | Penggunaan |
|---|---|
| [`google_fonts`](https://pub.dev/packages/google_fonts) | Tipografi antarmuka modern |
| [`intl`](https://pub.dev/packages/intl) | Format tanggal, waktu, dan lokalisasi `id_ID` |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | Asset ikon pendukung |

---

## 👤 Penulis & Pengembang (Author)

Proyek ini dibuat dan dikembangkan sepenuhnya oleh:

- **Nama**: Gede Aldi Irawan
- **GitHub**: [@aldwrnnnnn](https://github.com/aldwrnnnnn)
- **Email**: gedealdiirawan5@gmail.com

---

## 📄 Hak Cipta & Lisensi (Copyright & License)

Hak Cipta © 2026 **Gede Aldi Irawan** ([@aldwrnnnnn](https://github.com/aldwrnnnnn)).

Proyek ini dilindungi hak cipta dan didistribusikan di bawah lisensi resmi **MIT License**. Anda diizinkan untuk menggunakan, memodifikasi, dan mendistribusikan kode ini sesuai dengan ketentuan yang tertera pada berkas [LICENSE](LICENSE).
