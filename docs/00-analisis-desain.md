# 00. Analisis Desain RekapFin.pen

> Ringkasan: RekapFin.pen berisi 66 node tingkat atas: 43 layar 390 x 844 dalam 8 section, 2 halaman dokumentasi (Design Tokens, Komponen), 10 komponen reusable, dan 14 label. Gaya iOS glassmorphism terang dengan satu warna emerald, font Plus Jakarta Sans, ikon Lucide. Desain tidak memuat interaksi atau prototipe. Beberapa data contoh tidak konsisten antar layar (lihat [OPEN_ISSUES.md](OPEN_ISSUES.md)).

Status: Draft analisis (kondisi file saat dibaca, 9 November 2026). Dokumen ini TIDAK diubah oleh keputusan produk (OI-01 sampai OI-53) karena mencatat apa yang ada di file pada pembacaan pertama (66 node tingkat atas; kini 96 node, status terkini di [14-status-desain.md](14-status-desain.md)); selisih antara file dan keputusan ada di [OPEN_ISSUES.md](OPEN_ISSUES.md) dan [11-perubahan-pen.md](11-perubahan-pen.md). Rujukan "OI-xx" di bawah memakai status terbaru di OPEN_ISSUES (hampir semuanya sudah Diputuskan). Label sumber: [DESAIN] terbaca dari file, [ASUMSI] simpulan analis, [PERLU KEPUTUSAN] belum jelas saat itu.

## 1. Cara file dibaca
- [DESAIN] File yang diminta (`RekapFin.pen`) tidak ada di folder proyek (`/home/antariksa/project/pribadi/RekapFin` kosong sebelum analisis). File itu terbuka di aplikasi pen.dev dengan salinan di `~/.pencil/documents/<uuid>/RekapFin.pen` (bukan bagian repo; lihat catatan lokasi di [INDEX.md](INDEX.md)). File .pen terenkripsi, jadi tidak dibaca langsung; pembacaan dilakukan lewat MCP Pencil (hanya baca dan ekspor ke folder sementara).
- Teks UI, warna, ukuran, dan struktur diambil dari ekspor HTML/CSS seluruh layar dan dari pembacaan node. Tidak ada perubahan pada desain.
- Batas: tidak ada gambar layar yang diperiksa visual satu per satu. Posisi, ukuran, dan teks terbaca dari data, bukan dari kesan visual.

## 2. Angka ringkas
| Item | Jumlah | Sumber |
|---|---|---|
| Node tingkat atas | 66 | [DESAIN] |
| Layar 390 x 844 (frame + varian) | 43 | [DESAIN] |
| Frame dengan route di namanya | 24 (21 route unik; varian berbagi route induk) | [DESAIN] |
| Frame tanpa route di namanya (varian/state/sheet) | 19 | [DESAIN] |
| Section layar | 6 (+ KOMPONEN dan halaman token) | [DESAIN] |
| Komponen reusable | 10 (7 di tingkat atas, 3 di dalam Komponen) | [DESAIN] |
| Variabel/token | 44 (28 warna, 15 angka, 1 string) | [DESAIN] |
| Tema | hanya terang | [DESAIN] |
| Ukuran teks dipakai | 11, 12, 14, 16, 20, 28, 32, 36, 40 | [DESAIN] |

## 3. Section dan layar
| Section | Jumlah | Frame |
|---|---|---|
| AUTENTIKASI | 4 | Masuk (/login), Masuk - Error, Masuk - Loading, Daftar (/signup) |
| UTAMA | 4 | Beranda (/home), Transaksi (/transactions), Anggaran (/budget), Analitik (/analytics) |
| TRANSAKSI & SCAN NOTA | 6 | Tambah Transaksi - Pengeluaran / Pemasukan / Terisi, Scan Nota (/scan), Scan Nota - Memproses, Hasil Scan (/scan-result) |
| ASISTEN AI | 1 | Asisten RekapFin (/chat) |
| AKUN | 2 | Profil (/profile), Edit Profil (/edit-profile) |
| HUTANG & PIUTANG | 16 | lihat [03-inventaris-layar.md](03-inventaris-layar.md) |
| INVESTASI | 10 | lihat [03-inventaris-layar.md](03-inventaris-layar.md) |
| KOMPONEN | 6 definisi + label | GlassCard, FilterChip/Aktif, FilterChip/Nonaktif, PrimaryButton, TransactionItem, BottomNavBar |

Total layar: 4 + 4 + 6 + 1 + 2 + 16 + 10 = 43.

Route yang tertulis di nama frame [DESAIN]: /login, /signup, /home, /transactions, /budget, /analytics, /scan, /scan-result, /chat, /profile, /edit-profile, /debts, /debt-detail, /debt-payment, /debt-net, /debt-offset, /investments, /scan-investment, /scan-investment-result, /add-investment, /investment-detail. Varian dan sheet tidak punya route di nama frame.

## 4. Komponen reusable [DESAIN]
| Komponen | Ukuran | Varian/state |
|---|---|---|
| Latar RekapFin | 390 x 844 | satu (latar + 3 blob) |
| GlassCard | 350 lebar | satu, slot Konten |
| GlassCard/Hero | 350 lebar | gradien emerald |
| FilterChip/Aktif, FilterChip/Nonaktif | tinggi 36 | aktif, nonaktif |
| PrimaryButton | 350 x 52 | satu (ikon plus + label) |
| TransactionItem | 318 lebar | satu (ikon belanja, nominal merah) |
| NavItem/Aktif, NavItem/Nonaktif | 80 x 56 | aktif, nonaktif |
| BottomNavBar | 350 x 68 | 5 tab (instans NavItem) |

Rincian properti ada di [08-design-system.md](08-design-system.md).

## 5. Token ringkas [DESAIN]
Font: Plus Jakarta Sans (bobot 500 sampai 800). Warna utama: bg-base #F0FDF4, accent #10B981, income #059669, expense #DC2626, warning #D97706, text-primary #0B2E22, text-secondary #4F6B5E, text-muted #86A394. Radius: kartu 24, tombol 26, chip 18, nav 34. Spasi: 8, 16, 24, 32; padding layar 20. Daftar lengkap di [08-design-system.md](08-design-system.md).

## 6. Temuan penting
1. Tidak ada interaksi/prototipe di file; semua navigasi di dokumen ini [ASUMSI] (OI-02).
2. Banyak layar yang dirujuk desain belum ada: Transfer, Notifikasi, Atur Anggaran Baru, Lupa kata sandi, detail transaksi, dan lainnya (OI-17).
3. Kategori "Investasi" muncul di Tambah Transaksi padahal investasi bukan pengeluaran (OI-06).
4. Semantik transaksi hutang/piutang belum jelas (OI-07).
5. Konsep dompet ("Saldo Utama") ada tanpa layar dompet (OI-08).
6. Data anggaran tidak cocok dengan total pengeluaran (OI-11).
7. Teks terbalik di varian Timbal Balik (OI-15).
8. Varian "Hutang & Piutang - Kosong" kontradiktif (OI-01).
9. Kontras putih di atas accent hanya 2,54:1 (OI-18).
10. Halaman Design Tokens ketinggalan dari variabel (OI-19).
11. Layout Profil menyimpang demi menghindari tombol Tanya AI (OI-04).
12. Backdrop di bawah sheet berupa salinan Beranda yang berbeda-beda (OI-14 butir 13).

## 7. Aspek yang konsisten (kekuatan desain)
- Data contoh hutang/piutang cocok dengan angka kesepakatan: Piutang 2.000.000 + 1.200.000 + 2.000.000 + 400.000 + 500.000 = Rp 6.100.000 (5 orang); Hutang 1.500.000 + 500.000 + 750.000 = Rp 2.750.000 (3 orang); saldo bersih Rp 3.350.000. [DESAIN]
- Investasi: 5.120.000 + 4.870.000 + 2.940.000 = Rp 12.930.000; modal Rp 12.640.000; untung Rp 290.000 (+2,3%); alokasi 39,6 / 37,7 / 22,7 persen. [DESAIN]
- Ringkasan grup harian di Transaksi cocok (Hari Ini -85.000, Kemarin -564.000, 7 Nov +8.168.500). [DESAIN]
- Contoh saling hapus Budi (2.000.000 vs 750.000 menjadi 1.250.000) konsisten di Detail Piutang, Saldo Bersih, Konfirmasi, dan Berhasil. [DESAIN]
- Pola state: login punya default/error/loading, scan punya default/memproses/hasil, investasi punya kosong, hutang punya timbal balik/impas/lunas. [DESAIN]

## 8. Tautan
Dokumen turunan: [01-PRD.md](01-PRD.md), [03-inventaris-layar.md](03-inventaris-layar.md), [08-design-system.md](08-design-system.md), [OPEN_ISSUES.md](OPEN_ISSUES.md).
