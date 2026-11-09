# 📱 Antrean Digital

Aplikasi sistem antrean digital modern berbasis **Flutter** untuk mengoptimalkan alur pelayanan publik dan manajemen loket. Aplikasi ini mengintegrasikan portal pengunjung untuk pengambilan nomor antrean, panel petugas loket untuk pemanggilan tiket, serta rekapitulasi riwayat pelayanan dalam satu antarmuka yang responsif.

---

## 🚀 Fitur Utama

- **Portal Pengunjung (Visitor Screen)**
  - Pengambilan tiket antrean digital berdasarkan kategori layanan yang dipilih.
  - Estimasi durasi pelayanan dan waktu tunggu secara otomatis.
  - Kartu tiket digital aktif (*Hero Card*) dan dialog rincian nomor tiket.
  
- **Kategori Layanan Fleksibel**
  - **Layanan Umum & CS (Kode A)**: Pelayanan administrasi dan informasi umum.
  - **Kasir & Pembayaran (Kode B)**: Pembayaran tagihan, retribusi, dan konfirmasi transaksi.
  - **Konsultasi & Pengaduan (Kode C)**: Bimbingan teknis dan penyampaian aduan.

- **Panel Petugas / Admin Loket (Counter Admin Screen)**
  - Pemanggilan nomor antrean berikutnya (*Call Next*).
  - Pemanggilan ulang (*Recall*) untuk pengunjung yang belum merespons.
  - Penyelesaian antrean (*Mark Completed*) dan penanganan pengunjung tidak hadir (*Skip / No-Show*).
  - Pilihan nomor loket aktif sesuai tugas masing-masing petugas.

- **Riwayat & Monitoring Pelayanan (History Screen)**
  - Pencatatan seluruh alur antrean (selesai, dilewati, maupun dibatalkan).
  - Transparansi status dan waktu pelayanan tiket.

- **Arsitektur Multi-Platform**
  - Mendukung penyesuaian tata letak untuk perangkat Mobile (Android/iOS), Desktop (Windows/macOS/Linux), dan Web.

---

## 📂 Struktur Proyek

```text
lib/
├── main.dart                  # Entry point aplikasi & inisialisasi state
├── models/                    # Model data (QueueTicket, ServiceCategory)
├── screens/                   # Tampilan antarmuka utama (Visitor, Admin, History)
├── state/                     # Pengelolaan status antrean reaktif (QueueState)
├── theme/                     # Konfigurasi palet warna, tipografi, dan ikon
└── widgets/                   # Komponen UI modular (Hero Card, Dialog, Badge, Sheet)
```

---

## 🛠️ Prasyarat & Cara Menjalankan

1. **Prasyarat**:
   - Flutter SDK (versi >= 3.0.0)
   - Dart SDK
   - Editor (VS Code / Android Studio)

2. **Langkah Instalasi**:
   ```bash
   # Clone repositori
   git clone https://github.com/aldwrnnnnn/antrean_digital.git
   cd antrean_digital

   # Unduh dependencies
   flutter pub get

   # Jalankan aplikasi di perangkat / emulator yang terhubung
   flutter run
   ```

---

## 🛡️ Hak Cipta, Lisensi & Kepemilikan (Proprietary Notice)

> **PEMBERITAHUAN HAK CIPTA & KEPEMILIKAN EKSKLUSIF**
>
> Proyek **Antrean Digital** ini sepenuhnya dirancang, dibangun, dan dimiliki oleh **[aldwrnnnnn](https://github.com/aldwrnnnnn) (Gede Aldi Irawan)**.

```
Copyright (c) 2026 aldwrnnnnn (Gede Aldi Irawan). All Rights Reserved.
```

- **Hak Eksklusif**: Seluruh kode sumber, desain tata letak UI/UX, arsitektur data, komponen logika, dan aset di dalam repositori ini merupakan hak cipta eksklusif dari pembuat asli (**aldwrnnnnn**).
- **Larangan Plagiasi & Redistribusi**: Dilarang keras menyalin, menduplikasi, memodifikasi, mempublikasikan ulang, menjual, mengklaim sebagai karya sendiri, atau menggunakan materi proyek ini untuk portofolio pribadi pihak lain tanpa persetujuan tertulis resmi dari pemilik hak cipta.
- Segala bentuk pelanggaran terhadap hak cipta ini dapat diproses sesuai dengan ketentuan hukum kekayaan intelektual yang berlaku.

---

**Author / Maintainer**:  
👤 **aldwrnnnnn (Gede Aldi Irawan)**  
🔗 GitHub: [@aldwrnnnnn](https://github.com/aldwrnnnnn)  
📧 Email: `gedealdiirawan5@gmail.com`
