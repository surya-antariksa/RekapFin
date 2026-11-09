# 14. Status Desain RekapFin.pen terhadap Dokumen

> Ringkasan: perbandingan RekapFin.pen (dibaca lewat MCP pen.dev pada 9 November 2026, hanya baca) dengan [03-inventaris-layar.md](03-inventaris-layar.md) dan [11-perubahan-pen.md](11-perubahan-pen.md). Dari 96 layar dan varian yang dibutuhkan, 16 sudah ada dan sesuai, 27 sudah ada tetapi perlu koreksi, dan 53 belum ada. File .pen sudah berubah sejak analisis pertama: 62 variabel (token baru dan token layout), varian komponen (PrimaryButton, BottomNavBar, TransactionItem), halaman dokumentasi diperbarui, Pak Hendra 30 Nov 2026, varian Kosong diganti nama, dan satu layar baru Beranda - Konten Penuh; 43 layar produk lain belum disentuh. Tidak ada item di file yang memblokir Sprint 0 sampai 3.

Status: Draft. Label status: **ADA & SESUAI**, **ADA TAPI PERLU KOREKSI**, **BELUM ADA**. Bukti diambil dari teks dan variabel di file (bukan dari kesan visual). Kolom Sprint merujuk [13-sprint-plan.md](13-sprint-plan.md) (sprint Flutter pertama yang memakai layar itu; sprint desain ada di bagian 4). "MEMBLOKIR" berarti modul Flutter pemakai bergantung keras pada desain itu menurut 13.

## 1. Rekap angka

| Kelompok | Jumlah |
|---|---|
| Layar dan varian di file saat ini | 43 |
| - ADA & SESUAI | 16 |
| - ADA TAPI PERLU KOREKSI | 27 |
| Layar, sheet, dialog, dan state yang BELUM ADA (jumlah frame) | 53 (dalam 41 baris) |
| - semua baris yang BELUM ADA sudah punya prompt di 11 dan item D di 13 | ya |
| **Total dibutuhkan** | **96** |
| Selesai dan sesuai | 16 (17%) |
| Komponen dan token yang perlu koreksi (di luar hitungan layar) | 1 dari 11 baris |

## 2. Tabel status

### 2.1 Layar dan varian yang sudah ada di file

| # | Nama | Route | Fase | Status | Alasan | Prompt di 11 | Item D → sprint desain | Sprint Flutter | Memblokir |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Masuk (`VKph5`) | /login | 1 | ADA TAPI PERLU KOREKSI | Tombol Apple dan teks "Masuk dengan Face ID" masih ada; rilis Android memakai Google dan "Biometrik" | P1-13 | D-04* → S4 | S5 | MEMBLOKIR S5 |
| 2 | Masuk - Error (`RuMoh`) | /login | 1 | ADA TAPI PERLU KOREKSI | Sama seperti Masuk (Apple, Face ID) | P1-13 | D-04* → S4 | S5 | MEMBLOKIR S5 |
| 3 | Masuk - Loading (`HpYhk`) | /login | 1 | ADA TAPI PERLU KOREKSI | Sama seperti Masuk (Apple, Face ID) | P1-13 | D-04* → S4 | S5 | MEMBLOKIR S5 |
| 4 | Daftar (`RbM3v`) | /signup | 1 | ADA TAPI PERLU KOREKSI | Tombol Apple masih ada | P1-13 | D-04* → S4 | S5 | MEMBLOKIR S5 |
| 5 | Profil (`QlEkO`) | /profile | 1 | ADA TAPI PERLU KOREKSI | Belum ada baris Dompet dan Pengaturan (masih "Keamanan & Face ID"); statistik "Rp 24,7 jt" harus "Rp 24,8 jt"; layout Keluar perlu dirata-tengahkan | P1-8 | D-04 → S4 | S7 | tidak (placeholder boleh) |
| 6 | Edit Profil (`uRAc5`) | /edit-profile | 1 | ADA & SESUAI | Semua elemen dibutuhkan ada (dialog Hapus Akun terpisah, lihat Bagian B) | - | - | S7 | - |
| 7 | Beranda (`ir3EN`) | /home | 2 | ADA TAPI PERLU KOREKSI | Transaksi Terbaru masih memuat Gaji November dan tidak memuat Kopi Kenangan; harus 5 baris sesuai set demo | P1-2 | D-08 → S5 | S11 | MEMBLOKIR S11 |
| 8 | Transaksi (`vj0kJ`) | /transactions | 2 | ADA TAPI PERLU KOREKSI | Belum ada baris contoh Transfer; tanda minus memakai tanda hubung (11 P3-1) | P1-2, P3-1 | D-08 → S5 | S12 | tidak (placeholder boleh) |
| 9 | Tambah Transaksi - Pengeluaran (`XQW61`) | (sheet) | 2 | ADA TAPI PERLU KOREKSI | Kategori "Investasi" masih ada; belum ada field Dompet | P0-1 | D-05 → S4 | S12 | MEMBLOKIR S12 |
| 10 | Tambah Transaksi - Pemasukan (`paxrS`) | (sheet) | 2 | ADA TAPI PERLU KOREKSI | Belum ada field Dompet | P0-1 | D-05 → S4 | S12 | MEMBLOKIR S12 |
| 11 | Tambah Transaksi - Terisi (`l9Zn5t`) | (sheet) | 2 | ADA TAPI PERLU KOREKSI | Belum ada field Dompet | P0-1 | D-05 → S4 | S12 | MEMBLOKIR S12 |
| 12 | Anggaran (`mqN4J`) | /budget | 3 | ADA TAPI PERLU KOREKSI | Angka lama (Terpakai Rp 4.100.000, 75/50/90/80%); belum ada warna hijau/amber/merah 70/90; harus Rp 5.230.000, 87% | P1-1 | D-09 → S10 | S15 | MEMBLOKIR S15 |
| 13 | Analitik (`QBrxb`) | /analytics | 3 | ADA TAPI PERLU KOREKSI | Toggle bawaan "6 Bulan"; harus "Bulan Ini" (bawaan toggle belum diverifikasi ulang) | P1-2 | D-08 → S5 | S16 | tidak (placeholder boleh) |
| 14 | Scan Nota (`i3J3oQ`) | /scan | 4 | ADA TAPI PERLU KOREKSI | Placeholder nota masih "WARUNG PADANG Rp 85.000"; harus "TOKO SUMBER REJEKI Rp 103.400" | P1-9 | D-12 → S15 | S19 | MEMBLOKIR S19 |
| 15 | Scan Nota - Memproses (`x3TMj`) | /scan | 4 | ADA TAPI PERLU KOREKSI | Placeholder nota sama seperti Scan Nota | P1-9 | D-12 → S15 | S19 | MEMBLOKIR S19 |
| 16 | Hasil Scan (`N9WYl`) | /scan-result | 4 | ADA TAPI PERLU KOREKSI | Tag amber "Periksa kembali" baru di Total; perlu juga di Pajak 10% | P1-9 | D-12 → S15 | S20 | tidak (placeholder boleh) |
| 17 | Asisten RekapFin (`iuNsn`) | /chat | 7 | ADA TAPI PERLU KOREKSI | Jawaban masih Rp 1.500.000 (harus Rp 1.990.000, 83%); ikon mikrofon masih ada (harus disembunyikan) | P1-4 | D-08 → S5 | S30 | tidak (placeholder boleh) |
| 18 | Hutang & Piutang (`daAfZ`) | /debts | 5 | ADA & SESUAI | Angka dan teks sesuai set demo (5 piutang, 3 hutang, jatuh tempo Pak Hendra piutang 30 Nov) | - | - | S22 | - |
| 19 | Hutang & Piutang - Hutang Saya (`vwd3L`) | /debts | 5 | ADA & SESUAI | Jatuh tempo Pak Hendra sudah 30 Nov 2026 (P1-5 butir 2 diterapkan) | - | - | S22 | - |
| 20 | Hutang & Piutang - Kosong Pengguna Baru (`F0or1`) | /debts | 5 | ADA & SESUAI | Sudah diganti nama dan ringkasan Rp 0. Catatan: nama frame di file "Kosong Pengguna Baru" (tanpa tanda hubung), dokumen memakai "Kosong - Pengguna Baru"; tidak memblokir | - | - | S22 | - |
| 21 | Tambah Hutang/Piutang - Piutang (`u8Ot6`) | (sheet) | 5 | ADA TAPI PERLU KOREKSI | Belum ada field Dompet | P1-7 | D-11 → S19 | S22 | MEMBLOKIR S22 |
| 22 | Tambah Hutang/Piutang - Terisi (`E8dhpO`) | (sheet) | 5 | ADA TAPI PERLU KOREKSI | Belum ada field Dompet; tanggal pinjam masih "Hari ini, 9 Nov 2026" (harus 9 Okt 2026) | P1-5, P1-7 | D-11 → S19 | S22 | MEMBLOKIR S22 |
| 23 | Tambah Hutang/Piutang - Timbal Balik (`X1ziP`) | (sheet) | 5 | ADA TAPI PERLU KOREKSI | Teks masih terbalik ("Budi punya piutang..."); belum ada field Dompet | P1-5, P1-7 | D-11 → S19 | S22 | MEMBLOKIR S22 |
| 24 | Detail Piutang (`i5MAz`) | /debt-detail | 5 | ADA TAPI PERLU KOREKSI | Tombol "Kirim Pengingat" (ikon message-circle) masih ada; harus dihapus. Jatuh tempo Budi 12 Nov 2026 dan chip "3 hari lagi" sudah konsisten | P1-6 | D-11 → S19 | S23 | MEMBLOKIR S23 |
| 25 | Detail Hutang (`FYCyW`) | /debt-detail | 5 | ADA TAPI PERLU KOREKSI | Jatuh tempo Pak Hendra sudah 30 Nov 2026; tombol "Kirim Pengingat" masih ada | P1-6 | D-11 → S19 | S23 | MEMBLOKIR S23 |
| 26 | Detail - Lunas (`X2FAH`) | /debt-detail | 5 | ADA TAPI PERLU KOREKSI | Tombol "Kirim Pengingat" masih ada | P1-6 | D-11 → S19 | S23 | MEMBLOKIR S23 |
| 27 | Catat Pembayaran (`xH9UR`) | /debt-payment | 5 | ADA TAPI PERLU KOREKSI | Belum ada field Dompet; "Kirim Pengingat" pada latar masih ada | P1-6, P1-7 | D-11 → S19 | S23 | MEMBLOKIR S23 |
| 28 | Catat Pembayaran - Terisi (`IqkUp`) | /debt-payment | 5 | ADA TAPI PERLU KOREKSI | Sama seperti Catat Pembayaran | P1-6, P1-7 | D-11 → S19 | S23 | MEMBLOKIR S23 |
| 29 | Saldo Bersih - Dia Berhutang (`NziAs`) | /debt-net | 5 | ADA & SESUAI | Sesuai (memakai karakter minus U+2212) | - | - | S23 | - |
| 30 | Saldo Bersih - Kamu Berhutang (`uHCWl`) | /debt-net | 5 | ADA & SESUAI | Sesuai | - | - | S23 | - |
| 31 | Saldo Bersih - Impas (`KDwid`) | /debt-net | 5 | ADA & SESUAI | Sesuai | - | - | S23 | - |
| 32 | Konfirmasi Saling Hapus (`Ie7pG`) | /debt-offset | 5 | ADA TAPI PERLU KOREKSI | Belum ada peringatan "Saling hapus tidak dapat dibatalkan" (OI-46) | P1-12 | D-11 → S19 | S23 | MEMBLOKIR S23 |
| 33 | Konfirmasi Saling Hapus - Berhasil (`OQfXg`) | /debt-offset | 5 | ADA TAPI PERLU KOREKSI | Tombol "Lihat Riwayat" masih ada; harus dihapus (layar riwayat ditunda) | P1-6 | D-11 → S19 | S23 | tidak (placeholder boleh) |
| 34 | Investasi (`jtXDi`) | /investments | 6 | ADA & SESUAI | Sesuai (angka kanonik Rp 12.930.000, alokasi 39,6/37,7/22,7) | - | - | S26 | - |
| 35 | Investasi - Kosong (`V1mqTD`) | /investments | 6 | ADA & SESUAI | Sesuai | - | - | S26 | - |
| 36 | Scan Investasi (`ucrqd`) | /scan-investment | 6 | ADA & SESUAI | Sesuai (5 platform tersedia) | - | - | S28 | - |
| 37 | Scan Investasi - Terpilih (`wLzkK`) | /scan-investment | 6 | ADA & SESUAI | Sesuai | - | - | S28 | - |
| 38 | Scan Investasi - Memproses (`ybvAc`) | /scan-investment | 6 | ADA & SESUAI | Sesuai | - | - | S28 | - |
| 39 | Hasil Scan Investasi (`rvl4d`) | /scan-investment-result | 6 | ADA & SESUAI | Sesuai (Sumber dana sudah berupa pemilih bertanda panah) | - | - | S28 | - |
| 40 | Hasil Scan Investasi - Emas (`Ktrcz`) | /scan-investment-result | 6 | ADA & SESUAI | Sesuai | - | - | S28 | - |
| 41 | Tambah Investasi (`efIGG`) | /add-investment | 6 | ADA TAPI PERLU KOREKSI | Belum ada field Sumber dana (dompet) di bawah toggle transfer | P1-7 | D-14 → S25 | S26 | MEMBLOKIR S26 |
| 42 | Detail Aset (`sFWee`) | /investment-detail | 6 | ADA & SESUAI | Sesuai (form lanjutan ada di Bagian B) | - | - | S27 | - |
| 43 | Detail Aset - Rugi (`j5NDH`) | /investment-detail | 6 | ADA & SESUAI | Sesuai | - | - | S27 | - |

`D-04*` = P1-13 belum dipetakan ke item D mana pun di 13; diusulkan masuk D-04 (Sprint 4) karena F10 di Sprint 5 membangun layar Masuk dan Daftar.

### 2.2 Komponen, token, dan halaman dokumentasi desain

| # | Nama | Fase | Status | Alasan | Prompt di 11 | Item D → sprint desain | Sprint Flutter | Memblokir |
|---|---|---|---|---|---|---|---|---|
| 1 | Design Tokens (halaman) | 0 | ADA TAPI PERLU KOREKSI | Sudah memuat token baru, status anggaran, dan aturan layout (zona Tanya AI x 302-390, y 672-744). Sisa: kalimat "Frame referensi tidak wajib 390 x 844" bertentangan dengan OI-55 (frame 390 x 844 adalah viewport, konten digulir); belum memuat padding bawah 160, nav dan Tanya AI fixed, jarak 16/12, chip filter scrollable | P2-2b (baru) | D-01 → S1 | S2 | tidak (placeholder boleh) |
| 2 | Komponen (halaman) | 0 | ADA & SESUAI | Hero "+8,2% dari bulan lalu"; bagian GlassCard, PrimaryButton, FilterChip, TransactionItem, NavItem, BottomNavBar ada | - | - | S2 | - |
| 3 | Variabel: accent-action, warning-text, status-*, text-muted, fs-micro 11, token layout | 0 | ADA & SESUAI | 62 variabel; semua token baru (accent-action #047857, warning-text, status-ok/warn/danger + -fill, text-muted #557566, fs-micro 11, frame-width/height, content-top, safe-bottom, tanya-zone-x/y, fs-page-title, glass-blur, nav-blur) ada | - | - | S2 | - |
| 4 | PrimaryButton | 0 | ADA & SESUAI | Isi accent-action #047857, 350 x 56, radius 16, label 16/600 | - | - | S2 | - |
| 5 | PrimaryButton varian: Disabled, Pressed, Loading, Sekunder | 0 | ADA & SESUAI | Empat varian komponen ada | - | - | S2 | - |
| 6 | FilterChip/Aktif | 0 | ADA & SESUAI | Isi accent-action; pil radius 999; label 12/600 | - | - | S2 | - |
| 7 | NavItem/Aktif dan BottomNavBar (dan enam varian per tab) | 0 | ADA & SESUAI | Ikon dan label aktif accent-action; nonaktif text-muted; varian Beranda, Transaksi, Anggaran, Analitik, Profil aktif dan Tanpa tab aktif ada | - | - | S2 | - |
| 8 | GlassCard/Hero | 0 | ADA & SESUAI | Gradien #047857 ke #078761; nilai fs-display 36/800; "+8,2% dari bulan lalu" | - | - | S11 | - |
| 9 | TransactionItem | 0 | ADA & SESUAI | Varian Pengeluaran, Pemasukan, Transfer, Dengan label, Chevron ada (P2-1b diterapkan) | - | - | S2 | - |
| 10 | Beranda - Konten Penuh (/home) dan Catatan Konten Penuh | 2 | ADA & SESUAI | Contoh aturan scroll: frame 390 x 1100 dengan catatan padding bawah 160; layar lain yang melebihi 844 belum digambar serupa (aturan 08 bagian 8 berlaku) | - | - | S11 | - |
| 11 | GlassCard, FilterChip/Tidak aktif, NavItem/Nonaktif, Latar RekapFin | 0 | ADA & SESUAI | Sesuai spesifikasi 08 | - | - | S2 | - |

`D-01*` = diusulkan menambah TransactionItem varian ke D-01 (celah baru: P2-1b).

### 2.3 Layar, sheet, dialog, dan state yang BELUM ADA

| # | Nama | Route | Fase | Status | Alasan | Prompt di 11 | Item D → sprint desain | Sprint Flutter | Memblokir |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Onboarding Saldo Awal | /onboarding | 1 | BELUM ADA | Layar baru (OI-08) | P0-2 | D-02 → S2 | S5 | MEMBLOKIR S5 |
| 2 | Onboarding Saldo Awal - Terisi | /onboarding | 1 | BELUM ADA | Varian nominal Rp 18.500.000 | P0-2 | D-02 → S2 | S5 | MEMBLOKIR S5 |
| 3 | Lupa Kata Sandi | /forgot-password | 1 | BELUM ADA | Layar wajib MVP (OI-17) | P0-3 | D-02 → S2 | S5 | MEMBLOKIR S5 |
| 4 | Lupa Kata Sandi - Error | /forgot-password | 1 | BELUM ADA | Varian email tidak valid | P0-3 | D-02 → S2 | S5 | MEMBLOKIR S5 |
| 5 | Lupa Kata Sandi - Terkirim | /forgot-password | 1 | BELUM ADA | Varian tautan terkirim | P0-3 | D-02 → S2 | S5 | MEMBLOKIR S5 |
| 6 | Dompet | /wallets | 1 | BELUM ADA | Layar baru (OI-08) | P0-4 | D-03 → S2 | S7 | MEMBLOKIR S7 |
| 7 | Form Dompet - Tambah (sheet) | (sheet) | 1 | BELUM ADA | Sheet tambah dompet | P0-4 | D-03 → S2 | S7 | MEMBLOKIR S7 |
| 8 | Form Dompet - Ubah (sheet) | (sheet) | 1 | BELUM ADA | Sheet ubah dompet | P0-4 | D-03 → S2 | S7 | MEMBLOKIR S7 |
| 9 | Form Dompet - Arsip Ditolak (saldo tidak nol) dan Konfirmasi Arsip | (sheet) | 2 | BELUM ADA | State BR-43 | P0-4b | D-03 → S2 | S13 | tidak (placeholder boleh) |
| 10 | Pengaturan | /settings | 1 | BELUM ADA | Layar baru (OI-10, OI-25); memuat zona waktu | P0-8 | D-04 → S4 | S6 | MEMBLOKIR S6 |
| 11 | Pengaturan - Biometrik Aktif | /settings | 1 | BELUM ADA | Varian toggle hidup | P0-8 | D-04 → S4 | S6 | MEMBLOKIR S6 |
| 12 | Pilih Zona Waktu (sheet) | (sheet) | 1 | BELUM ADA | Tiga zona (OI-44) | P0-8 | D-04 → S4 | S6 | MEMBLOKIR S6 |
| 13 | Hapus Akun - Konfirmasi, Login Ulang, Gagal | (dialog) | 1 | BELUM ADA | Dialog Hapus Akun (OI-30, PRF-03) | P0-10 | D-15 → S5 | S8 | tidak (placeholder boleh) |
| 14 | Akun Sedang Dihapus | (state) | 1 | BELUM ADA | State setelah penghapusan terputus | P2-4 | D-13 → S6 | S8 | tidak (placeholder boleh) |
| 15 | Tambah Transaksi - Peringatan Saldo | (sheet) | 2 | BELUM ADA | State saldo negatif (OI-31) | P1-11 | D-05 → S4 | S12 | MEMBLOKIR S12 |
| 16 | Transfer - Peringatan Saldo | (sheet) | 2 | BELUM ADA | State saldo negatif (OI-31) | P1-11 | D-06 → S4 | S13 | MEMBLOKIR S13 |
| 17 | Transfer | /transfer | 2 | BELUM ADA | Layar baru (OI-07) | P0-5 | D-06 → S4 | S13 | MEMBLOKIR S13 |
| 18 | Transfer - Terisi | /transfer | 2 | BELUM ADA | Varian terisi | P0-5 | D-06 → S4 | S13 | MEMBLOKIR S13 |
| 19 | Transfer - Error | /transfer | 2 | BELUM ADA | Varian asal sama tujuan | P0-5 | D-06 → S4 | S13 | MEMBLOKIR S13 |
| 20 | Transfer - Ke Investasi | /transfer | 2 | BELUM ADA | Varian tujuan Investasi | P0-5 | D-06 → S4 | S13 | tidak (placeholder boleh) |
| 21 | Detail Transaksi | /transaction-detail | 2 | BELUM ADA | Layar baru wajib MVP (OI-17) | P0-6 | D-07 → S8 | S12 | MEMBLOKIR S12 |
| 22 | Detail Transaksi - Pemasukan | /transaction-detail | 2 | BELUM ADA | Varian | P0-6 | D-07 → S8 | S12 | MEMBLOKIR S12 |
| 23 | Detail Transaksi - Transfer | /transaction-detail | 2 | BELUM ADA | Varian | P0-6 | D-07 → S8 | S12 | MEMBLOKIR S12 |
| 24 | Edit Transaksi (sheet) | (sheet) | 2 | BELUM ADA | Sheet ubah transaksi | P0-6 | D-07 → S8 | S12 | MEMBLOKIR S12 |
| 25 | Dialog Hapus Transaksi | (dialog) | 2 | BELUM ADA | Konfirmasi hapus | P0-6 | D-07 → S8 | S12 | MEMBLOKIR S12 |
| 26 | Atur Anggaran | /budget-edit | 3 | BELUM ADA | Layar baru wajib MVP (OI-17) | P0-7 | D-09 → S10 | S15 | MEMBLOKIR S15 |
| 27 | Atur Anggaran - Error | /budget-edit | 3 | BELUM ADA | Varian jumlah melebihi total | P0-7 | D-09 → S10 | S15 | MEMBLOKIR S15 |
| 28 | Perbarui Aplikasi | /update-required | 0 | BELUM ADA | Pemblokir versi; tombol "Unduh versi terbaru" (OI-39, OI-53) | P2-3 | D-13 → S6 | S3 | tidak (placeholder boleh) |
| 29 | Versi Baru Tersedia (pengingat non-memblokir) | (dialog) | 0 | BELUM ADA | Pengingat `recommended_version` (OI-53) | P2-3b | D-13 → S6 | S3 | tidak (placeholder boleh) |
| 30 | State Tanpa Jaringan (komponen, layar penuh, banner) | (state) | 0 | BELUM ADA | Error seragam BR-39 | P2-3 | D-13 → S6 | S3 | tidak (placeholder boleh) |
| 31 | Tambah Transaksi - Terisi, tombol simpan nonaktif (offline) | (sheet) | 0 | BELUM ADA | Varian BR-39 | P2-3 | D-13 → S6 | S12 | tidak (placeholder boleh) |
| 32 | Batas Harian Tercapai - Scan | (dialog) | 4 | BELUM ADA | Kuota scan 20 habis (OI-48) | P2-4 | D-12 → S15 | S19 | MEMBLOKIR S19 |
| 33 | Batas Harian Tercapai - Pembacaan Ulang | (dialog) | 4 | BELUM ADA | Kuota fallback 10 habis (OI-48) | P2-4 | D-12 → S15 | S19 | MEMBLOKIR S19 |
| 34 | Dialog Persetujuan Pemrosesan AI | (dialog) | 4 | BELUM ADA | Persetujuan sebelum fitur AI (07 bagian 10.1) | P1-17 | D-16 → S13 | S20 | tidak (placeholder boleh) |
| 35 | Pemilih Kontak (sheet) | (sheet) | 5 | BELUM ADA | Layar baru (OI-13, OI-36) | P0-9 | D-10 → S17 | S22 | MEMBLOKIR S22 |
| 36 | Dialog Nama Ganda | (dialog) | 5 | BELUM ADA | Konfirmasi nama ganda (OI-13) | P0-9 | D-10 → S17 | S22 | MEMBLOKIR S22 |
| 37 | Detail Transaksi - Dari Catatan Hutang | /transaction-detail | 5 | BELUM ADA | Varian source debt/debt_payment (BR-38) | P0-6 | D-07 → S8 | S23 | tidak (placeholder boleh) |
| 38 | Edit Hutang/Piutang, Dialog Hapus Catatan, Dialog Batalkan Pembayaran | (sheet, dialog) | 5 | BELUM ADA | Edit/hapus hutang (OI-30) dan pembatalan pembayaran | P1-14 | D-17 → S17 | S23 | tidak (placeholder boleh) |
| 39 | Tambah Pembelian, Perbarui Nilai, Menu/Edit Aset, Pemilih Platform, Dialog Hapus Aset | (sheet, dialog) | 6 | BELUM ADA | Form investasi lanjutan (OI-30) | P1-15 | D-18 → S14 | S26 | tidak (placeholder boleh) |
| 40 | Batas Harian Tercapai - Chat | (dialog) | 7 | BELUM ADA | Kuota chat 50 habis (OI-48) | P2-4 | D-12 → S15 | S30 | tidak (placeholder boleh) |
| 41 | Syarat & Ketentuan, Kebijakan Privasi (halaman teks) | /terms, /privacy | 8 | BELUM ADA | Halaman hukum (OI-30, X-07) | P1-16 | D-19 → S29 | S31 | tidak (placeholder boleh) |

Semua item D pada tabel ini ada di 13 (D-15 sampai D-19 ditambahkan pada pembaruan ini). Semua prompt yang dirujuk ada di 11.

## 3. State dari aturan bisnis yang belum punya layar

| Aturan | State yang dibutuhkan | Status di file | Prompt di 11 | Item D → sprint | Catatan |
|---|---|---|---|---|---|
| Saldo negatif diizinkan dengan peringatan (OI-31, BR-30) | Kartu peringatan di Tambah Transaksi dan Transfer dengan tombol Lanjutkan/Ubah | BELUM ADA (baris 15 dan 16 di 2.3) | P1-11 | D-05 → S4, D-06 → S4 | Dibutuhkan F23 (S12) dan F24 (S13) |
| Dompet bersaldo bukan nol tidak bisa diarsipkan (BR-43) | Form Dompet - Ubah dengan Arsipkan nonaktif dan arahan ke Transfer; konfirmasi arsip untuk saldo nol | BELUM ADA | P0-4b | D-03 → S2 | Dibutuhkan F25 (S13) |
| Kuota scan 20, fallback 10, dan chat 50 habis (OI-48, BR-28) | Dialog Batas Harian Tercapai (tiga varian) dengan arahan ke input manual | BELUM ADA | P2-4 | D-12 → S15 (scan, fallback), chat di S30 | Scan dan fallback dibutuhkan F40 (S19) |
| Peringatan saling hapus tidak dapat dibatalkan (OI-46, BR-07) | Baris peringatan pada Konfirmasi Saling Hapus | ADA TAPI PERLU KOREKSI (Ie7pG belum memuat peringatan) | P1-12 | D-11 → S19 | Dibutuhkan F53 (S23) |
| Perbarui Aplikasi dan state offline (OI-39, BR-39) | Layar /update-required, komponen State Tanpa Jaringan, banner, tombol simpan nonaktif | BELUM ADA | P2-3 | D-13 → S6 | Placeholder fungsional sudah cukup untuk F04 (S3); desain final tidak memblokir |
| Layar update untuk distribusi Drive (OI-53, BR-46) | Tombol "Unduh versi terbaru" yang membuka `update_url` (sudah di P2-3) dan pengingat non-memblokir untuk `recommended_version` | BELUM ADA | P2-3 dan P2-3b | D-13 → S6 | Panduan pasang untuk penguji adalah dokumen (X-13), bukan layar |
| Hapus akun dari dalam aplikasi (PRF-03, BR-44) | Dialog konfirmasi, login ulang, dan state gagal | BELUM ADA | P0-10 | D-15 → S5 | Dibutuhkan F15 (S8); placeholder dialog kaca boleh |
| Persetujuan pemrosesan AI sebelum fitur AI aktif (07 bagian 10.1) | Dialog Persetujuan Pemrosesan AI | BELUM ADA | P1-17 | D-16 → S13 | Dibutuhkan sebelum F41 (S20); kolom persetujuan di 06 (OI-54, BR-47) |
| Edit/hapus hutang dan pembatalan pembayaran (OI-30, BR-09) | Edit Hutang/Piutang, Dialog Hapus Catatan, Dialog Batalkan Pembayaran | BELUM ADA | P1-14 | D-17 → S17 | Dibutuhkan F52 (S23) |

## 4. Urutan menurut sprint Flutter yang memerlukan

Gabungan bagian 2.1 sampai 2.3, hanya yang BELUM ADA atau PERLU KOREKSI. **MEMBLOKIR** = modul Flutter pada sprint itu bergantung keras pada desain tersebut menurut 13.

| Sprint Flutter | Layar / item | Status | Prompt di 11 | Item D → sprint desain | Memblokir |
|---|---|---|---|---|---|
| S2 | Design Tokens (halaman) | ADA TAPI PERLU KOREKSI | P2-2b (baru) | D-01 → S1 | tidak |
| S3 | Perbarui Aplikasi | BELUM ADA | P2-3 | D-13 → S6 | tidak |
| S3 | State Tanpa Jaringan (komponen, layar penuh, banner) | BELUM ADA | P2-3 | D-13 → S6 | tidak |
| S3 | Versi Baru Tersedia (pengingat non-memblokir) | BELUM ADA | P2-3b | D-13 → S6 | tidak |
| S5 | Daftar | ADA TAPI PERLU KOREKSI | P1-13 | D-04* → S4 | **MEMBLOKIR** |
| S5 | Lupa Kata Sandi | BELUM ADA | P0-3 | D-02 → S2 | **MEMBLOKIR** |
| S5 | Lupa Kata Sandi - Error | BELUM ADA | P0-3 | D-02 → S2 | **MEMBLOKIR** |
| S5 | Lupa Kata Sandi - Terkirim | BELUM ADA | P0-3 | D-02 → S2 | **MEMBLOKIR** |
| S5 | Masuk | ADA TAPI PERLU KOREKSI | P1-13 | D-04* → S4 | **MEMBLOKIR** |
| S5 | Masuk - Error | ADA TAPI PERLU KOREKSI | P1-13 | D-04* → S4 | **MEMBLOKIR** |
| S5 | Masuk - Loading | ADA TAPI PERLU KOREKSI | P1-13 | D-04* → S4 | **MEMBLOKIR** |
| S5 | Onboarding Saldo Awal | BELUM ADA | P0-2 | D-02 → S2 | **MEMBLOKIR** |
| S5 | Onboarding Saldo Awal - Terisi | BELUM ADA | P0-2 | D-02 → S2 | **MEMBLOKIR** |
| S6 | Pengaturan | BELUM ADA | P0-8 | D-04 → S4 | **MEMBLOKIR** |
| S6 | Pengaturan - Biometrik Aktif | BELUM ADA | P0-8 | D-04 → S4 | **MEMBLOKIR** |
| S6 | Pilih Zona Waktu (sheet) | BELUM ADA | P0-8 | D-04 → S4 | **MEMBLOKIR** |
| S7 | Dompet | BELUM ADA | P0-4 | D-03 → S2 | **MEMBLOKIR** |
| S7 | Form Dompet - Tambah (sheet) | BELUM ADA | P0-4 | D-03 → S2 | **MEMBLOKIR** |
| S7 | Form Dompet - Ubah (sheet) | BELUM ADA | P0-4 | D-03 → S2 | **MEMBLOKIR** |
| S7 | Profil | ADA TAPI PERLU KOREKSI | P1-8 | D-04 → S4 | tidak |
| S8 | Akun Sedang Dihapus | BELUM ADA | P2-4 | D-13 → S6 | tidak |
| S8 | Hapus Akun - Konfirmasi, Login Ulang, Gagal | BELUM ADA | P0-10 | D-15 → S5 | tidak |
| S11 | Beranda | ADA TAPI PERLU KOREKSI | P1-2 | D-08 → S5 | **MEMBLOKIR** |
| S12 | Detail Transaksi | BELUM ADA | P0-6 | D-07 → S8 | **MEMBLOKIR** |
| S12 | Detail Transaksi - Pemasukan | BELUM ADA | P0-6 | D-07 → S8 | **MEMBLOKIR** |
| S12 | Detail Transaksi - Transfer | BELUM ADA | P0-6 | D-07 → S8 | **MEMBLOKIR** |
| S12 | Dialog Hapus Transaksi | BELUM ADA | P0-6 | D-07 → S8 | **MEMBLOKIR** |
| S12 | Edit Transaksi (sheet) | BELUM ADA | P0-6 | D-07 → S8 | **MEMBLOKIR** |
| S12 | Tambah Transaksi - Pemasukan | ADA TAPI PERLU KOREKSI | P0-1 | D-05 → S4 | **MEMBLOKIR** |
| S12 | Tambah Transaksi - Pengeluaran | ADA TAPI PERLU KOREKSI | P0-1 | D-05 → S4 | **MEMBLOKIR** |
| S12 | Tambah Transaksi - Peringatan Saldo | BELUM ADA | P1-11 | D-05 → S4 | **MEMBLOKIR** |
| S12 | Tambah Transaksi - Terisi | ADA TAPI PERLU KOREKSI | P0-1 | D-05 → S4 | **MEMBLOKIR** |
| S12 | Tambah Transaksi - Terisi, tombol simpan nonaktif (offline) | BELUM ADA | P2-3 | D-13 → S6 | tidak |
| S12 | Transaksi | ADA TAPI PERLU KOREKSI | P1-2, P3-1 | D-08 → S5 | tidak |
| S13 | Transfer | BELUM ADA | P0-5 | D-06 → S4 | **MEMBLOKIR** |
| S13 | Transfer - Error | BELUM ADA | P0-5 | D-06 → S4 | **MEMBLOKIR** |
| S13 | Transfer - Peringatan Saldo | BELUM ADA | P1-11 | D-06 → S4 | **MEMBLOKIR** |
| S13 | Transfer - Terisi | BELUM ADA | P0-5 | D-06 → S4 | **MEMBLOKIR** |
| S13 | Form Dompet - Arsip Ditolak (saldo tidak nol) dan Konfirmasi Arsip | BELUM ADA | P0-4b | D-03 → S2 | tidak |
| S13 | Transfer - Ke Investasi | BELUM ADA | P0-5 | D-06 → S4 | tidak |
| S15 | Anggaran | ADA TAPI PERLU KOREKSI | P1-1 | D-09 → S10 | **MEMBLOKIR** |
| S15 | Atur Anggaran | BELUM ADA | P0-7 | D-09 → S10 | **MEMBLOKIR** |
| S15 | Atur Anggaran - Error | BELUM ADA | P0-7 | D-09 → S10 | **MEMBLOKIR** |
| S16 | Analitik | ADA TAPI PERLU KOREKSI | P1-2 | D-08 → S5 | tidak |
| S19 | Batas Harian Tercapai - Pembacaan Ulang | BELUM ADA | P2-4 | D-12 → S15 | **MEMBLOKIR** |
| S19 | Batas Harian Tercapai - Scan | BELUM ADA | P2-4 | D-12 → S15 | **MEMBLOKIR** |
| S19 | Scan Nota | ADA TAPI PERLU KOREKSI | P1-9 | D-12 → S15 | **MEMBLOKIR** |
| S19 | Scan Nota - Memproses | ADA TAPI PERLU KOREKSI | P1-9 | D-12 → S15 | **MEMBLOKIR** |
| S20 | Dialog Persetujuan Pemrosesan AI | BELUM ADA | P1-17 | D-16 → S13 | tidak |
| S20 | Hasil Scan | ADA TAPI PERLU KOREKSI | P1-9 | D-12 → S15 | tidak |
| S22 | Dialog Nama Ganda | BELUM ADA | P0-9 | D-10 → S17 | **MEMBLOKIR** |
| S22 | Pemilih Kontak (sheet) | BELUM ADA | P0-9 | D-10 → S17 | **MEMBLOKIR** |
| S22 | Tambah Hutang/Piutang - Piutang | ADA TAPI PERLU KOREKSI | P1-7 | D-11 → S19 | **MEMBLOKIR** |
| S22 | Tambah Hutang/Piutang - Terisi | ADA TAPI PERLU KOREKSI | P1-5, P1-7 | D-11 → S19 | **MEMBLOKIR** |
| S22 | Tambah Hutang/Piutang - Timbal Balik | ADA TAPI PERLU KOREKSI | P1-5, P1-7 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Catat Pembayaran | ADA TAPI PERLU KOREKSI | P1-6, P1-7 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Catat Pembayaran - Terisi | ADA TAPI PERLU KOREKSI | P1-6, P1-7 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Detail - Lunas | ADA TAPI PERLU KOREKSI | P1-6 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Detail Hutang | ADA TAPI PERLU KOREKSI | P1-6 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Detail Piutang | ADA TAPI PERLU KOREKSI | P1-6 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Konfirmasi Saling Hapus | ADA TAPI PERLU KOREKSI | P1-12 | D-11 → S19 | **MEMBLOKIR** |
| S23 | Detail Transaksi - Dari Catatan Hutang | BELUM ADA | P0-6 | D-07 → S8 | tidak |
| S23 | Edit Hutang/Piutang, Dialog Hapus Catatan, Dialog Batalkan Pembayaran | BELUM ADA | P1-14 | D-17 → S17 | tidak |
| S23 | Konfirmasi Saling Hapus - Berhasil | ADA TAPI PERLU KOREKSI | P1-6 | D-11 → S19 | tidak |
| S26 | Tambah Investasi | ADA TAPI PERLU KOREKSI | P1-7 | D-14 → S25 | **MEMBLOKIR** |
| S26 | Tambah Pembelian, Perbarui Nilai, Menu/Edit Aset, Pemilih Platform, Dialog Hapus Aset | BELUM ADA | P1-15 | D-18 → S14 | tidak |
| S30 | Asisten RekapFin | ADA TAPI PERLU KOREKSI | P1-4 | D-08 → S5 | tidak |
| S30 | Batas Harian Tercapai - Chat | BELUM ADA | P2-4 | D-12 → S15 | tidak |
| S31 | Syarat & Ketentuan, Kebijakan Privasi (halaman teks) | BELUM ADA | P1-16 | D-19 → S29 | tidak |

## 5. Yang memblokir Sprint 0 sampai 3

Sprint 0 sampai 3 mengerjakan F00 sampai F04 dan SQL S00/S01. Satu-satunya modul Flutter yang bergantung keras pada desain adalah F02 (Sprint 2), yang membutuhkan D-01. Layar produk (login, dompet, transaksi) baru dipakai mulai Sprint 5.

| # | Item di file | Mengapa memblokir F02 (Sprint 2) | Prompt di 11 |
|---|---|---|---|
| - | Tidak ada | Token (62 variabel), PrimaryButton (default, Disabled, Pressed, Loading, Sekunder), FilterChip, NavItem/BottomNavBar (per tab), TransactionItem (lima varian), dan GlassCard/Hero sudah ada di file dan sesuai dengan 08 | - |

Satu sisa yang tidak memblokir: halaman Design Tokens masih memuat kalimat "Frame referensi tidak wajib 390 x 844" dan belum memuat aturan scroll (P2-2b di 11); F01/F02 mengikuti 08 bagian 8, bukan halaman itu.

Tidak memblokir tetapi sebaiknya ada sebelum Sprint 3: layar Perbarui Aplikasi dan State Tanpa Jaringan (F04 memakai placeholder fungsional; desain final P2).

Pemblokir terdekat sesudah Sprint 3 (agar tidak menahan Sprint 5): D-02 dan perbaikan Masuk/Daftar (Onboarding, Lupa Kata Sandi, Masuk, Daftar), lalu D-04 (Pengaturan, Profil) sebelum Sprint 6, D-03 (Dompet) sebelum Sprint 7.

## 6. Selisih yang ditemukan

| # | Selisih | Usulan (belum diterapkan kecuali disebut) |
|---|---|---|
| 1 | P1-13 (sembunyikan Apple, label Biometrik) dipetakan ke D-04 (Sprint 4) di 13; Masuk dan Daftar di file masih memuat tombol Apple dan teks "Masuk dengan Face ID". | Diterapkan di 13 (SRC D-04); koreksi .pen menunggu D-04. |
| 2 | Prompt P0-4b, P0-10, P1-14, P1-15, P1-16, P1-17, P2-3b, dan P2-1b ada di 11; D-15 sampai D-19 ditambahkan ke 13 pada pembaruan ini, D-01 dan D-13 diperluas (P2-1b, P2-3b). | Selesai. Dampak jadwal: +5 poin D-15 sampai D-19 dan +1 poin generator S05; tanggal rencana tidak bergeser (13 bagian 1). |
| 3 | Kolom persetujuan pemrosesan AI sebelumnya tidak ada di 06. | Selesai: `profiles.ai_consent_at` dan `ai_consent_version`, `record_ai_consent_v1`, BR-47, T-CNS-01..07 (OI-54). |
| 4 | P3-1 (satu karakter minus) dan P3-2 (hubungan navigasi) tidak dipetakan ke item D di 13. | Opsional; kerjakan bersama D-08 atau setelah MVP. |
| 5 | Halaman Design Tokens memuat kalimat yang bertentangan dengan keputusan layout (OI-55): "Frame referensi tidak wajib 390 x 844". | Prompt P2-2b di 11; sampai diterapkan, ikuti 08 bagian 8. |
| 6 | Nama frame di file berbeda tipis dari dokumen: "Kosong Pengguna Baru" (dokumen: "Kosong - Pengguna Baru"), "FilterChip/Tidak aktif" (sebelumnya "Nonaktif"). | Tidak memblokir; Flutter memakai nama sesuai 08 dan 03. Samakan nama saat D-11 atau D-01 bila perlu. |
| 7 | Hanya Beranda yang digambar sebagai Konten Penuh (390 x 1100); layar lain yang lebih panjang dari 844 belum. | Tidak memblokir; aturan scroll di 08 bagian 8 berlaku untuk semua layar. |

