# 01. Product Requirements Document (PRD) RekapFin

> Ringkasan: RekapFin adalah aplikasi mobile (Flutter + Supabase) untuk mencatat keuangan pribadi dalam rupiah: transaksi, anggaran, analitik, lalu hutang-piutang dengan saling hapus, investasi, scan nota/screenshot, dan asisten AI. MVP mencakup fase 0 sampai 3 (fondasi, auth, transaksi, anggaran, analitik). Fitur lanjutan masuk fase 4 sampai 7, fase 8 untuk pengerasan dan rilis. Cakupan mengikuti desain RekapFin.pen; ide tambahan ada di [OPEN_ISSUES.md](OPEN_ISSUES.md) bagian Usulan.

Status: Diperbarui setelah keputusan OI-01 sampai OI-57 (Diputuskan). Tertunda: target metrik keberhasilan (OI-60). Label sumber: [DESAIN], [ASUMSI], [TERTUNDA].

Keputusan yang mengubah PRD: banyak dompet sederhana (OI-08), transfer antar dompet dan ke investasi (OI-07), satu paket gratis dengan batas harian (OI-21), AI memakai Google AI (Gemini API) lewat Edge Function dengan 20 scan dan 50 chat per hari (OI-09), notifikasi lokal H-3 dan hari-H (OI-22), Face ID opsional (OI-25). Ditunda: Notifikasi (layar), Riwayat Saling Hapus (layar), mikrofon, pengingat WhatsApp.

## 1. Masalah dan tujuan
- Masalah [ASUMSI]: pencatatan keuangan manual melelahkan, nota dan screenshot investasi tersebar, dan pinjam-meminjam antar teman/keluarga sulit dilacak (siapa berhutang berapa, termasuk yang saling berhutang).
- Tujuan produk:
  1. Pencatatan transaksi cepat (kurang dari 20 detik per transaksi manual, kurang dari 10 detik lewat scan) [ASUMSI].
  2. Gambaran jelas pengeluaran terhadap anggaran bulanan.
  3. Catatan hutang-piutang per orang yang akurat, dengan saling hapus yang transparan.
  4. Portofolio investasi (reksa dana, emas) terpisah dari pengeluaran.
  5. Asisten AI yang menjawab pertanyaan keuangan dan membantu mencatat, tanpa pernah menulis data tanpa konfirmasi.
- Prinsip: akurat sebelum cerdas (nominal bilangan bulat rupiah, validasi OCR), privasi (gambar dihapus, tanpa kunci API di aplikasi).

## 2. Target pengguna dan persona
Target [ASUMSI]: individu Indonesia berusia sekitar 20 sampai 40 tahun, berpenghasilan tetap, memakai smartphone, sering meminjamkan atau meminjam uang ke orang dekat, dan berinvestasi lewat aplikasi seperti Bibit dan Tokopedia Emas.

Persona singkat (diturunkan dari pengguna contoh di desain, [DESAIN] nama dan data, [ASUMSI] perilaku):
| Atribut | Isi |
|---|---|
| Nama | Rizky Pratama (31 tahun, lahir 14 Maret 1995 menurut Edit Profil) |
| Kondisi | Gaji bulanan Rp 8.500.000, anggaran bulanan Rp 6.000.000 |
| Kebiasaan | Makan di warung, naik ojek online, bayar listrik dan langganan; meminjamkan uang ke teman; punya reksa dana dan emas digital |
| Kebutuhan | Tahu sisa anggaran, tidak lupa siapa yang belum bayar, tidak mengetik ulang nota |
| Kekhawatiran | Salah hitung hutang timbal balik, data keuangan bocor |

## 3. Ruang lingkup per fase
Detail definisi selesai ada di [09-roadmap.md](09-roadmap.md).

| Fase | Isi | Layar utama [DESAIN] | Kelompok |
|---|---|---|---|
| 0 | Fondasi: proyek Flutter, design system, tema, Supabase, CI | Komponen | MVP |
| 1 | Autentikasi, profil, onboarding saldo awal, dompet dasar | Masuk, Masuk Error/Loading, Daftar, Lupa Kata Sandi, Onboarding, Profil, Edit Profil, Pengaturan, Dompet | MVP |
| 2 | Transaksi dan transfer | Beranda, Transaksi, Tambah Transaksi (3 varian), Detail/Edit Transaksi, Transfer | MVP |
| 3 | Anggaran dan analitik | Anggaran, Atur Anggaran, Analitik | MVP |
| 4 | Scan nota | Scan Nota (+Memproses), Hasil Scan | Lanjutan |
| 5 | Hutang-piutang dan saling hapus | 16 layar HUTANG & PIUTANG | Lanjutan |
| 6 | Investasi dan scan investasi | 10 layar INVESTASI | Lanjutan |
| 7 | Asisten AI (chatbot) | Asisten RekapFin | Lanjutan |
| 8 | Pengerasan dan rilis: notifikasi, ekspor, aksesibilitas, performa, build rilis bertanda tangan dan distribusi APK lewat Google Drive | Pengaturan Profil | Rilis |

Urutan fase 4 sampai 7 adalah [ASUMSI]: scan nota dulu karena pipeline OCR dipakai ulang oleh scan investasi; chatbot terakhir karena memerlukan semua data dan RPC.

### 3.1 MVP (fase 0 sampai 3)
- Daftar, masuk (email+kata sandi, Google, biometrik opsional untuk sesi tersimpan (Face ID di iOS)), lupa kata sandi, profil dasar, Pengaturan.
- Onboarding saldo awal (boleh dilewati); dompet Tunai, Bank, E-wallet dengan default "Saldo Utama"; Total Saldo = jumlah dompet.
- Catat pemasukan/pengeluaran dengan dompet, kategori, tanggal, catatan; lihat, ubah, hapus transaksi; transfer antar dompet; daftar dengan pencarian dan filter; ringkasan Beranda.
- Anggaran bulanan: total terpisah dari kategori, warna status hijau/amber/merah (70/90), atur anggaran, sisa hari.
- Analitik: donut pengeluaran per kategori, arus kas 6 bulan, insight; hanya transaksi yang dihitung (hutang, pembayaran hutang, transfer dikecualikan).
- RLS aktif sejak tabel pertama.

### 3.2 Fase lanjutan
- Scan nota (OCR on-device + Edge Function), hasil dapat diedit, validasi, ambang amber 85%, batas 20 scan per hari.
- Hutang-piutang per orang (kontak lewat tabel contacts), cicilan, pembayaran, saling hapus FIFO, notifikasi lokal H-3 dan hari-H. Riwayat saling hapus dicatat tetapi layarnya ditunda.
- Investasi: reksa dana, emas (saham/lainnya manual), alokasi, detail aset, scan screenshot dari Bibit, Tokopedia Emas, Pegadaian, Pluang, Lainnya.
- Chatbot (Google AI): tanya jawab data, catat lewat kartu konfirmasi, batas 50 pesan per hari.

## 4. Metrik keberhasilan
Target adalah usulan [ASUMSI]; persetujuannya [TERTUNDA] di OI-60.
| Metrik | Definisi | Target awal |
|---|---|---|
| Aktivasi | Pengguna baru yang mencatat 3 transaksi dalam 7 hari | 50% |
| Retensi minggu 4 | Pengguna aktif di minggu ke-4 | 30% |
| Waktu catat | Median waktu dari buka form sampai simpan | kurang dari 20 detik manual, kurang dari 10 detik scan |
| Akurasi OCR | Nota tanpa koreksi field total | 85% |
| Tingkat koreksi OCR | Field berkeyakinan rendah yang dikoreksi pengguna | dipantau |
| Kesalahan saling hapus | Selisih saldo bersih sebelum/sesudah saling hapus | 0 (invarian) |
| Crash-free sessions | Sesi tanpa crash | 99,5% |
| Biaya AI per pengguna aktif | Biaya LLM per bulan | batas harian di OI-09; anggaran biaya [TERTUNDA] di OI-61 |

## 5. Di luar cakupan
- Koneksi langsung (API) ke Bibit, aplikasi emas, bank, atau e-wallet. Data investasi hanya dari input manual atau scan screenshot.
- Multi-mata uang. Baris "Mata Uang IDR (Rp)" di Profil hanya tampilan.
- Berbagi (keluarga, patungan, laporan bersama).
- Tema gelap, widget, input suara (mikrofon ditunda, OI-20).
- Penjualan aset dan harga pasar otomatis [ASUMSI, tidak ada di desain].
- Pembayaran sungguhan atau transfer uang antar pengguna; "Kirim Pengingat" via WhatsApp ditunda (OI-22), pengingat hanya notifikasi lokal.
- Layar Notifikasi dan Riwayat Saling Hapus (ditunda, OI-17); impor kontak perangkat (OI-36); paket berbayar (OI-21).
- Rilis iOS (Sign in with Apple, TestFlight dan App Store, pencabutan token Apple): ditunda sampai setelah rilis Android; rilis pertama hanya Android (OI-51).
- Distribusi lewat Google Play atau App Store: rilis pertama berupa APK bertanda tangan yang dibagikan lewat Google Drive dan dipasang manual oleh penguji dan pengguna (OI-53); Play Store menjadi opsi kelak.

## 6. Risiko
| Risiko | Dampak | Mitigasi |
|---|---|---|
| Akurasi OCR nota rendah | Data salah masuk | Validasi jumlah, tag "Periksa kembali", fallback vision, edit manual |
| Biaya LLM tidak terkendali | Biaya operasional | Batas harian di server, cache, model ringan dulu (OI-09) |
| Kebocoran data keuangan | Kepercayaan dan hukum (UU PDP) | RLS wajib, tidak menyimpan gambar, kunci di Edge Function, log tanpa isi sensitif |
| Chatbot menulis data salah | Data korup | Hanya lewat kartu konfirmasi dan RPC divalidasi |
| Salah semantik hutang/transaksi | Analitik menyesatkan | Sudah diputuskan (OI-07): filter `source`; uji wajib di fase 2 dan 5 |
| Skema dompet berubah setelah data ada | Rework | Sudah diputuskan (OI-08); aturan hapus/arsip dompet diputuskan (OI-31, BR-43) |
| Notifikasi lokal hilang saat aplikasi dihapus atau izin ditolak | Pengingat tidak sampai | Jadwalkan ulang saat aplikasi dibuka; tampilkan status jatuh tempo di dalam aplikasi |
| Kontras tombol: isi tombol dan chip aktif memakai #047857 (putih/#047857 = 5,48:1), bukan #059669 (3,77:1) | Aksesibilitas, wajib sebelum rilis | OI-27 (Diputuskan) |
| Desain tidak terhubung dan data contoh tidak konsisten | Salah implementasi | OPEN_ISSUES dan inventaris layar sebagai sumber |
| Kontras rendah | Aksesibilitas | OI-18 |
| Ketergantungan platform OCR (ML Kit) di perangkat lama | Gagal baca | Fallback vision, input manual |
| Cakupan membengkak | Jadwal molor | Usulan hanya lewat OPEN_ISSUES |
