# OPEN_ISSUES: Masalah Desain dan Keputusan

> Ringkasan: daftar masalah desain, inkonsistensi data contoh, layar yang belum ada, dan keputusan produk. Butir OI-01 sampai OI-57 berstatus "Diputuskan": jawaban pemilik produk atas OI-01 sampai OI-25, 13 keputusan audit arsitektur (bagian F), OI-31 dan OI-38 sampai OI-49 (bagian D2), OI-50 sampai OI-53 (bagian D3), OI-54 sampai OI-57 (bagian D4), dan persetujuan atas semua usulan OI-26 sampai OI-37 (bagian D). Empat butir berstatus "Tertunda" (OI-58 sampai OI-61, bagian H): belum diputuskan, punya pemilik dan tenggat, dan tidak memblokir Sprint 0 sampai 3. Hal yang sengaja ditunda dan tindak lanjut terjadwal ada di bagian G. File .pen tidak diubah oleh dokumen ini; selisih desain ada di [11-perubahan-pen.md](11-perubahan-pen.md) dan [14-status-desain.md](14-status-desain.md).

Legenda status: **Diputuskan** (jawaban pemilik produk; persetujuan "setuju semua" atas usulan OI-26 sampai OI-37, OI-02, OI-16, dan OI-19 diberikan pemilik produk pada 9 November 2026), **Ditunda** (sengaja tidak dikerjakan sekarang; tindak lanjut terjadwal di bagian G), **Tertunda** (belum diputuskan; pemilik dan tenggat di bagian H). Label sumber: [DESAIN], [ASUMSI], [PERLU KEPUTUSAN] pada teks lama menunjukkan kondisi saat butir ditulis. Istilah "analis" berarti penyusun dokumen ini; "pemilik produk" adalah pengambil keputusan (lihat glosarium di [INDEX.md](INDEX.md)).
Prioritas: P0 memblokir pembangunan, P1 harus selesai sebelum fase terkait, P2 sebaiknya, P3 kosmetik.

## Ringkasan status
| ID | Masalah | Status | Keputusan singkat |
|---|---|---|---|
| OI-01 | Varian Hutang & Piutang kosong | Diputuskan | Ganti nama menjadi "Kosong - Pengguna Baru" |
| OI-02 | Navigasi belum terhubung | Diputuskan | Tiga tautan diterima sebagai spesifikasi |
| OI-03 | Label 11 px | Diputuskan | Label Aksi Cepat masuk pengecualian 11 px |
| OI-04 | Layout Profil | Diputuskan | Dipertahankan, dirapikan rata tengah (tafsiran di OI-33) |
| OI-05 | Jatuh tempo Pak Hendra | Diputuskan | Resmi 30 Nov 2026 |
| OI-06 | Kategori Investasi | Diputuskan | Dihapus dari tab Pengeluaran; akses via Transfer dan Investasi |
| OI-07 | Semantik transaksi | Diputuskan | income/expense/transfer + source; debt dan debt_payment di luar Analitik |
| OI-08 | Dompet dan Total Saldo | Diputuskan | Banyak dompet sederhana, saldo awal di onboarding |
| OI-09 | LLM dan batas AI | Diputuskan (penyedia diganti OI-52) | Google AI (Gemini API) lewat Edge Function; 20 scan, 50 chat, dan 10 fallback vision per hari |
| OI-10 | Simpan gambar | Diputuskan | Default tidak disimpan; toggle Pengaturan "Simpan foto nota" |
| OI-11 | Anggaran | Diputuskan | Total terpisah; hijau/amber/merah 70/90; set angka demo disetujui (OI-26) |
| OI-12 | Alokasi saling hapus | Diputuskan | FIFO jatuh tempo terdekat |
| OI-13 | Identitas kontak | Diputuskan | Tabel contacts, nama ganda memicu konfirmasi |
| OI-14 | Data demo tidak konsisten | Diputuskan | Mengikuti tabel Hutang & Piutang terbaru; set demo disetujui (OI-26) |
| OI-15 | Teks Timbal Balik | Diputuskan | Koreksi arah piutang/hutang |
| OI-16 | Dua karakter minus | Diputuskan | Satu karakter (U+2212) di semua tampilan |
| OI-17 | Layar yang hilang | Diputuskan | Layar wajib MVP ditambahkan; Notifikasi dan Riwayat Saling Hapus Ditunda; jadwal layar lain di OI-30 |
| OI-18 | Kontras warna | Diputuskan | text-muted wajib 4,5:1; isi tombol/chip dan teks aksen #047857 (OI-27) |
| OI-19 | Halaman Design Tokens usang | Diputuskan | Perbarui mengikuti variabel |
| OI-20 | Mikrofon chat | Diputuskan | Ditunda |
| OI-21 | Paket dan batas | Diputuskan | Satu paket gratis dengan batas harian |
| OI-22 | Pengingat | Diputuskan | Notifikasi lokal H-3 dan hari-H; WhatsApp ditunda |
| OI-23 | Platform investasi | Diputuskan | Bibit, Tokopedia Emas, Pegadaian, Pluang, Lainnya |
| OI-24 | Ambang OCR | Diputuskan | Field di bawah 85% atau total tidak cocok = amber |
| OI-25 | Face ID | Diputuskan | Opsional dari Pengaturan |
| OI-31 | Aturan dompet | Diputuskan | Saldo negatif diizinkan dengan peringatan; arsip dompet bersaldo bukan nol dilarang |
| OI-38 | Kelas tabel dan gate versi | Diputuskan | budgets/monthly_budgets dan scans kelas A; contacts kelas B; gate versi setelah login |
| OI-39 | Layar Perbarui Aplikasi dan state offline | Diputuskan | Didesain belakangan (P2); ada di 03 dan 11 |
| OI-40 | Model chat | Diputuskan | Dipilih di fase 7 |
| OI-41 | Service role storage-janitor | Diputuskan | Boleh; hanya terjadwal, tidak dapat dipanggil pengguna, hanya menghapus file yatim |
| OI-42 | Verifikasi hapus akun (Storage; Apple ditunda) | Diputuskan | Storage diuji di proyek dev pada fase 1; pencabutan token Apple saat rilis iOS (OI-51) |
| OI-43 | Batas nilai | Diputuskan | Nominal maksimum Rp 100 miliar per transaksi; batas lain disetujui |
| OI-44 | Zona waktu | Diputuskan | Asia/Jakarta, Asia/Makassar, Asia/Jayapura |
| OI-45 | Retensi pembersihan | Diputuskan | request_log 30 hari, scans 7 hari |
| OI-46 | Saling hapus tidak dapat dibatalkan | Diputuskan | Tidak ada pembatalan di MVP; layar konfirmasi wajib |
| OI-47 | Cache saldo | Diputuskan | Hanya jika p95 lebih dari 300 ms pada 10.000 transaksi |
| OI-48 | Kuota fallback habis | Diputuskan | Pesan dan arahan ke input manual |
| OI-49 | Cadangan, PITR, rahasia | Diputuskan | PITR dicek pemilik; cadangan manual berkala sebagai cadangan |
| OI-50 | Cakupan rilis pertama | Diputuskan | Semua fase 0 sampai 8: termasuk investasi dan asisten AI |
| OI-51 | Platform rilis pertama | Diputuskan | Android dulu; iOS (Sign in with Apple, TestFlight, App Store, token Apple) setelah rilis Android |
| OI-52 | Penyedia AI | Diputuskan | Google AI (Gemini API) menggantikan Claude; produksi wajib akun berbayar, tanpa data nyata di kuota gratis |
| OI-53 | Distribusi rilis pertama | Diputuskan | APK bertanda tangan lewat Google Drive, dipasang manual; tanpa Play Store |
| OI-26 | Set data demo | Diputuskan | Disetujui (bagian C): dompet, anggaran, transaksi, label |
| OI-27 | Warna isi tombol | Diputuskan | #047857 (5,48:1) untuk isi tombol/chip aktif, ikon/label nav aktif, teks aksen; #059669 tetap untuk income dan gradien hero |
| OI-28 | Cakupan filter | Diputuskan | Anggaran dan kartu Beranda memakai aturan Analitik |
| OI-29 | Retensi riwayat chat | Diputuskan | Teks percakapan 90 hari; layar riwayat pasca-rilis |
| OI-30 | Jadwal layar lain | Diputuskan | Syarat, Kebijakan Privasi, Hapus Akun, edit hutang, pembelian/nilai aset, picker platform di fase terkait; Kategori Saya, Ekspor, Bantuan pasca-rilis |
| OI-32 | Kategori pemasukan Investasi | Diputuskan | Dipertahankan (hasil investasi) |
| OI-33 | Rata tengah Profil | Diputuskan | Teks versi dirata-tengahkan terhadap tombol Keluar 208 px |
| OI-34 | Baris Mata Uang | Diputuskan | Tampil tanpa aksi (terkunci IDR) |
| OI-35 | Varian Kosong - Pengguna Baru | Diputuskan | Ringkasan menjadi nol |
| OI-36 | Pilih dari kontak | Diputuskan | Hanya tabel contacts; impor kontak perangkat masuk Usulan |
| OI-37 | Aturan jatuh tempo | Diputuskan | Relatif 0 sampai 3 hari; filter Jatuh Tempo 0 sampai 7 hari |
| OI-54 | Persetujuan pemrosesan AI | Diputuskan | `profiles.ai_consent_at` dan `ai_consent_version` lewat `record_ai_consent_v1`; RPC kuota AI menolak tanpa persetujuan (BR-47) |
| OI-55 | Sumber kebenaran nilai visual dan aturan layout | Diputuskan | RekapFin.pen terkini; viewport 390 x 844, gulir dengan padding bawah 160, nav dan Tanya AI fixed, jarak 16/12, chip scrollable |
| OI-56 | Aturan commit dan push | Diputuskan | Commit per modul setelah tes hijau; push atas perintah pemilik produk |
| OI-57 | Jatuh tempo Budi | Diputuskan | Tetap 12 Nov 2026 di semua dokumen dan data uji; hanya Pak Hendra 30 Nov 2026 |
| OI-58 | Privasi task switcher | Tertunda | Sebelum Sprint 31 (fase 8) |
| OI-59 | State fokus input dan skeleton | Tertunda | Sebelum Sprint 12 (F23) |
| OI-60 | Target metrik keberhasilan | Tertunda | Sebelum beta (Sprint 25) |
| OI-61 | Kapasitas, desain di dalam atau di luar kapasitas, anggaran AI | Tertunda | Sprint 2 (kalibrasi X-01) |

## A. Keputusan per butir

### OI-01 Varian "Hutang & Piutang - Kosong" [P2, Diputuskan]
- Bukti [DESAIN]: frame `Hutang & Piutang - Kosong` menulis "Belum ada catatan piutang" tetapi ringkasan di atasnya masih Rp 2.750.000, Rp 6.100.000, dan +Rp 3.350.000.
- Keputusan: ganti nama varian menjadi "Kosong - Pengguna Baru"; dijelaskan sebagai kondisi pengguna baru.
- Konsekuensi yang diturunkan analis [ASUMSI]: pada varian itu ringkasan menjadi Rp 0 / 0 orang / saldo bersih Rp 0 mengikuti pola `Investasi - Kosong`. Disetujui (OI-35). Varian "filter tanpa hasil" tidak dibuat.

### OI-02 Navigasi belum terhubung [P1, Diputuskan]
- Bukti [DESAIN]: file tidak memuat properti interaksi sama sekali, sehingga semua tujuan navigasi di dokumen adalah [ASUMSI].
- Tiga titik: segmen Investasi di Scan Nota ke /scan-investment; "Lihat & Saling Hapus" ke /debt-net; kategori Investasi di Tambah Transaksi sudah tidak ada (OI-06), diganti akses dari layar Transfer ke /add-investment.
- Status: pemilik produk belum menjawab butir ini secara eksplisit; usulan tetap berlaku. Peta navigasi ada di [04-alur-pengguna.md](04-alur-pengguna.md).

### OI-03 Label 11 px [P3, Diputuskan]
- Keputusan: pengecualian 11 px berlaku untuk label BottomNavBar, "Tanya AI", dan label Aksi Cepat (Tambah Pemasukan, Tambah Pengeluaran, Transfer, Scan Nota). Semua teks lain minimal 12 px.
- Tindak lanjut [ASUMSI]: `fs-micro` diubah dari 10 menjadi 11 agar sesuai pemakaian nyata (OI-19).

### OI-04 Layout Profil [P2, Diputuskan]
- Bukti [DESAIN]: `Keluar` di x=20, y=675, lebar 208; `Versi` x=20, y=721, lebar 208; zona Tanya AI x 240..370, y 684..736. Lebar 208 sama dengan 240 - 20 - 12.
- Keputusan: pertahankan, rapikan rata tengah. Tafsiran analis: tombol Keluar tetap lebar 208 di kiri, teks versi dirata-tengahkan terhadap tombol (OI-33).

### OI-05 Jatuh tempo Pak Hendra [P2, Diputuskan]
- Keputusan: jatuh tempo Pak Hendra resmi 30 Nov 2026. Hutang Pak Hendra yang tertulis "12 Nov 2026" diganti 30 Nov 2026 (di daftar Hutang Saya dan Detail Hutang). Piutang Pak Hendra sudah 30 Nov 2026.
- Aturan tampilan relatif/absolut (0 sampai 3 hari relatif, selain itu tanggal) tetap [ASUMSI] (OI-37). Dengan 30 Nov, Detail Hutang memakai bentuk absolut.

### OI-06 Kategori "Investasi" [P0, Diputuskan]
- Keputusan: hapus "Investasi" dari tab Pengeluaran. Investasi diakses lewat layar Transfer (tujuan "Investasi") dan layar Investasi. Daftar kategori disamakan di semua varian.
- Daftar pengeluaran (8): Makanan, Transport, Belanja, Tagihan, Hiburan, Kesehatan, Pendidikan, Lainnya.
- Daftar pemasukan (8, tidak diubah): Gaji, Bonus, Freelance, Investasi, Hadiah, Penjualan, Refund, Lainnya. Kategori pemasukan "Investasi" (hasil investasi) dipertahankan [ASUMSI] (OI-32).

### OI-07 Semantik transaksi [P0, Diputuskan]
- Keputusan:
  1. Tipe transaksi `income | expense | transfer`.
  2. Membayar hutang = `expense` dan menerima pembayaran piutang = `income`, dengan `source = 'debt_payment'`.
  3. Hutang atau piutang baru mengubah saldo dengan `source = 'debt'` (hutang baru = saldo naik/income; piutang baru = saldo turun/expense), bila toggle "Catat ke saldo & transaksi" aktif.
  4. Kedua source (`debt`, `debt_payment`) TIDAK masuk Analitik (filter `source`).
  5. `transfer` dipakai antar dompet dan ke investasi. Layar Transfer ditambahkan ke inventaris (/transfer).
- Cakupan filter [ASUMSI, OI-28]: aturan Analitik yang sama dipakai untuk Anggaran dan kartu Pemasukan/Pengeluaran bulan ini di Beranda; daftar Transaksi menampilkan semua.
- Dampak: BR-03, BR-04, BR-09, model data, uji.

### OI-08 Dompet dan Total Saldo [P0, Diputuskan]
- Keputusan: banyak dompet sederhana dengan jenis Tunai, Bank, E-wallet; dompet default "Saldo Utama". Total Saldo = jumlah semua dompet; nilai investasi tidak ikut. Saldo awal diisi di onboarding (boleh dilewati) dan dapat diubah di layar Dompet.
- Layar baru: Onboarding saldo awal, Dompet (/wallets) dengan tambah/ubah dompet. Field "Dompet" ditambahkan ke Tambah Transaksi, Catat Pembayaran, dan Tambah Hutang/Piutang (bawaan Saldo Utama).
- Aturan dompet: OI-31 (Diputuskan): saldo negatif diizinkan dengan peringatan; dompet bersaldo bukan nol tidak boleh diarsipkan.

### OI-09 LLM dan batas pemakaian [P0, Diputuskan]
- Keputusan: Claude lewat Edge Function (DIGANTI oleh OI-52: Google AI/Gemini API); model kecil untuk perapian teks, model dengan kemampuan vision hanya sebagai fallback. 20 scan dan 50 pesan chat per hari per pengguna, dapat dikonfigurasi di server. Gambar dihapus setelah dibaca; teks mentah OCR tidak disimpan.
- Catatan: nama model tidak dikunci di dokumen; dipilih lewat konfigurasi Edge Function agar mudah diganti [ASUMSI]. Fallback vision tidak memotong kuota scan, tetapi dibatasi 10 per hari dan satu kali per scan (keputusan 5); biayanya dipantau. Model chat dipilih di fase 7 (OI-40, Diputuskan). Batas nominal Rp 100 miliar per transaksi (OI-43).
- Retensi riwayat percakapan chat diputuskan di OI-29 (90 hari).

### OI-10 dan OI-24 Simpan gambar dan ambang OCR [P1, Diputuskan]
- Keputusan OI-10: gambar tidak disimpan secara bawaan. Ada toggle di Pengaturan "Simpan foto nota" (bawaan mati). Tidak ada toggle per scan di Hasil Scan.
- Keputusan OI-24: field berkeyakinan di bawah 85% diberi tanda amber "Periksa kembali"; total yang tidak cocok dengan rincian juga amber.
- Tafsiran [ASUMSI]: bila validasi gagal, sistem mencoba fallback vision satu kali; bila masih tidak cocok, field total ditandai amber. Fallback tidak dipicu oleh keyakinan rendah saja.
- Catatan: contoh Hasil Scan (total diberi amber padahal 94.000 + 9.400 = 103.400) tetap sah bila keyakinan field total di bawah 85%.

### OI-11 Anggaran [P1, Diputuskan]
- Keputusan: Total Anggaran terpisah dari jumlah batas kategori; jumlah batas kategori tidak boleh melebihi total. Warna status: kurang dari 70% hijau, 70% sampai 90% amber, lebih dari 90% merah.
- Tafsiran batas [ASUMSI]: tepat 70% dan tepat 90% amber; di atas 90% merah termasuk di atas 100%. Teks bantu: 90% sampai 100% "Hampir melebihi batas!", di atas 100% "Melebihi batas".
- Angka demo baru diusulkan di bagian C.

### OI-12 dan OI-13 Saling hapus FIFO dan kontak [P1, Diputuskan]
- Keputusan OI-12: alokasi saling hapus FIFO berdasarkan jatuh tempo terdekat di kedua sisi.
- Tafsiran [ASUMSI]: catatan tanpa jatuh tempo diurutkan terakhir; seri diselesaikan dengan tanggal pinjam lebih lama, lalu waktu dibuat.
- Keputusan OI-13: kontak lewat tabel `contacts` dan `contact_id`; nama ganda memicu dialog konfirmasi ("Pakai kontak yang ada" atau "Buat kontak baru"). Dialog dan pemilih kontak perlu didesain.
- Tafsiran [ASUMSI]: "Pilih dari kontak" memilih dari tabel `contacts` RekapFin; impor kontak perangkat tidak termasuk (OI-36).

### OI-14 Data demo [P2, Diputuskan]
- Keputusan: data demo mengikuti tabel Hutang & Piutang terbaru (tabel di [10-test-plan.md](10-test-plan.md) bagian 2.1 dan [03-inventaris-layar.md](03-inventaris-layar.md)).
- Analis menyusun set usulan untuk butir non-hutang di bagian C. Disetujui (OI-26).

### OI-15 Teks Timbal Balik [P1, Diputuskan]
- Keputusan: koreksi arah. Teks baru untuk varian Timbal Balik (hutang baru ke Budi): "Kamu punya piutang Rp 2.000.000 ke Budi. Akan dihitung saling hapus." Varian piutang baru bila lawan punya hutang: "Kamu punya hutang Rp {n} ke {nama}. Akan dihitung saling hapus."

### OI-16 Dua karakter minus [P3, Diputuskan]
- Bukti [DESAIN]: "-Rp 35.000" (tanda hubung) di transaksi, "−Rp 750.000" (U+2212) di Saldo Bersih. Usulan: satu fungsi format, satu karakter (U+2212) untuk tampilan. Belum dijawab.

### OI-17 Layar yang hilang [P1, Diputuskan]
Keputusan: wajib MVP ditambahkan: Lupa Kata Sandi, Atur Anggaran, Transfer, Detail/Edit Transaksi, Dompet. Ditunda: Notifikasi, Riwayat Saling Hapus.
| Layar | Status | Fase |
|---|---|---|
| Lupa Kata Sandi (/forgot-password) | Wajib MVP, Diputuskan | 1 |
| Dompet (/wallets) dan form dompet | Wajib MVP, Diputuskan | 1/2 |
| Transfer (/transfer) | Wajib MVP, Diputuskan | 2 |
| Detail/Edit Transaksi | Wajib MVP, Diputuskan | 2 |
| Atur Anggaran | Wajib MVP, Diputuskan | 3 |
| Onboarding saldo awal | Turunan OI-08, wajib | 1 |
| Pengaturan (/settings): Face ID, Simpan foto nota | Turunan OI-10 dan OI-25, wajib | 1 (Face ID), 4 (foto nota) |
| Dialog nama ganda kontak dan pemilih kontak | Turunan OI-13, wajib | 5 |
| Notifikasi (layar dan pengaturan) | Ditunda, Diputuskan | di luar MVP |
| Riwayat Saling Hapus (layar) | Ditunda, Diputuskan; data tetap dicatat | di luar MVP |
| Syarat & Ketentuan, Kebijakan Privasi, Kategori Saya, Ekspor Data, Bantuan, dialog Hapus Akun, edit/hapus hutang, Tambah Pembelian/Perbarui Nilai/edit aset, picker platform | Jadwal diputuskan di OI-30 | 1 sampai 8 |

### OI-18 Kontras warna [P2, Diputuskan]
- Keputusan awal: accent untuk tombol menjadi #059669 (DIGANTI oleh OI-27: #047857); text-muted harus memenuhi rasio kontras 4,5:1 (diterapkan: #557566); wajib diperbaiki sebelum rilis.
- Perhitungan analis (tanpa transparansi kaca):
  | Pasangan | Rasio |
  |---|---|
  | putih / #059669 (label tombol 16 px bold) | 3,77 (belum 4,5) |
  | putih / #047857 | 5,48 |
  | text-muted lama #86A394 / bg-base | 2,61 |
  | #5A7A6A / bg-base dan putih | 4,53 dan 4,74 |
  | #557566 / bg-base dan putih | 4,87 dan 5,09 |
  | warning #D97706 / putih | 3,19 |
  | #B45309 / putih | 5,02 |
- Usulan nilai [ASUMSI]: `text-muted` = #557566 (margin untuk latar kaca di atas blob); token baru `accent-action` = #059669 untuk isi tombol dan chip aktif; `accent` #10B981 hanya untuk elemen non-teks (ring, bar, blob); teks amber memakai `warning-text` #B45309.
- Masalah yang ditemukan analis: #059669 dengan teks putih 3,77:1 tidak mencapai 4,5:1 untuk label 16 px bold (ambang teks besar WCAG adalah 24 px, atau 18,66 px bold). Diputuskan di OI-27: isi tombol dan chip aktif memakai #047857 (5,48:1); #059669 tidak dipakai untuk teks putih.

### OI-19 Halaman Design Tokens usang [P3, Diputuskan]
- Halaman Design Tokens: perbarui halaman mengikuti variabel (nav 11 px, gradien hero, warna bayangan, token ukuran/radius/spasi yang dipakai nyata) dan token baru dari OI-18 dan OI-03. Detail di [11-perubahan-pen.md](11-perubahan-pen.md).

### OI-20 Mikrofon di Asisten [P2, Diputuskan]
- Keputusan: ikon mikrofon ditunda (disembunyikan dari MVP). Kamera di chat menuju /scan [ASUMSI].

### OI-21 Paket, Mata Uang, Hapus Akun [P2, Diputuskan]
- Keputusan: satu paket gratis dengan batas harian (label "Akun Gratis" dipertahankan, tanpa paket berbayar). Batas AI di OI-09.
- Belum dijawab: perilaku baris "Mata Uang" dan alur "Hapus Akun" (OI-34, OI-30).

### OI-22 Pengingat [P2, Diputuskan]
- Keputusan: notifikasi lokal pada H-3 dan hari-H jatuh tempo. Pengiriman via WhatsApp ditunda: tombol "Kirim Pengingat" (ikon WhatsApp) tidak ada di MVP.
- Catatan [ASUMSI]: pengaturan "Ingatkan sebelum jatuh tempo" pada form tetap ada (bawaan H-3); hari-H selalu ikut. Layar Notifikasi ditunda (OI-17), izin notifikasi diminta saat pertama kali dibutuhkan.

### OI-23 Platform investasi [P2, Diputuskan]
- Keputusan: platform yang didukung Bibit, Tokopedia Emas, Pegadaian, Pluang, dan Lainnya. Jenis aset tetap Reksa Dana, Emas, Saham, Lainnya. Penjualan aset dan harga otomatis tetap di luar cakupan.

### OI-25 Face ID [P2, Diputuskan]
- Keputusan: Face ID opsional, diaktifkan dari Pengaturan (bawaan mati). Tombol "Masuk dengan Face ID" di Masuk hanya relevan bila diaktifkan dan sesi tersimpan [ASUMSI].

## B. Inkonsistensi lama yang tidak berubah status

### OI-14 (rincian 13 butir) dan penyelesaiannya
Semua butir diselesaikan lewat set data demo di bagian C bila disetujui. Rujukan butir: 1 sampai 3 tanggal transaksi, 4 label tanggal, 5 persen Analitik vs anggaran, 6 toggle periode, 7 placeholder nota, 8 tag amber Hasil Scan, 9 tanggal pinjam Budi, 10 pembulatan Rp 24,7 jt, 11 contoh saldo di halaman token dan Hero, 12 nilai emas, 13 salinan Beranda di bawah sheet.

## C. Set data demo (disetujui, OI-26)
Tujuan: satu set angka yang konsisten untuk Beranda, Transaksi, Anggaran, Analitik, Chat, dan seed uji. Data hutang-piutang dan investasi tidak diubah (sudah konsisten dengan BR-18), kecuali jatuh tempo Pak Hendra (OI-05).

### C.1 Dompet (OI-08)
| Dompet | Jenis | Saldo |
|---|---|---|
| Saldo Utama | Bank | Rp 18.500.000 |
| Tunai | Tunai | Rp 1.250.000 |
| E-wallet | E-wallet | Rp 5.000.000 |
| Total Saldo | | Rp 24.750.000 |
Jenis "Saldo Utama" = Bank adalah [ASUMSI].

### C.2 Anggaran November 2026 (OI-11)
Total Anggaran Rp 6.000.000. Jumlah batas kategori Rp 5.850.000 (tidak melebihi total). Belanja sengaja tanpa anggaran (muncul di Analitik, tidak di daftar Anggaran).
| Kategori | Batas | Terpakai | Persen | Sisa | Warna |
|---|---|---|---|---|---|
| Makanan | 2.400.000 | 1.990.000 | 83% | 410.000 | amber |
| Transport | 1.400.000 | 730.000 | 52% | 670.000 | hijau |
| Hiburan | 550.000 | 520.000 | 95% | 30.000 | merah, "Hampir melebihi batas!" |
| Tagihan | 1.500.000 | 1.255.000 | 84% | 245.000 | amber |
| Belanja | tanpa | 735.000 | - | - | tidak tampil di Anggaran |
Ringkasan: Terpakai Rp 5.230.000 (semua expense manual/scan/chat bulan ini, termasuk Belanja), Sisa Rp 770.000, ring 87% (amber), "21 hari tersisa".

### C.3 Analitik dan Beranda
- Pengeluaran bulan ini Rp 5.230.000; pemasukan Rp 8.500.000.
- Donat: Makanan 38% (1.990.000), Tagihan 24% (1.255.000), Transport 14% (730.000), Belanja 14% (735.000), Hiburan 10% (520.000); jumlah 100%.
- Toggle periode mengatur donat; arus kas selalu 6 bulan; toggle bawaan "Bulan Ini" aktif.
- Chat: "Pengeluaran Makanan November 2026 sebesar Rp 1.990.000, atau 83% dari anggaran Rp 2.400.000."
- Transaksi (acuan): Hari Ini Warung Padang -35.000, Gojek -22.000, Kopi Kenangan -28.000 (total -85.000); Kemarin Listrik PLN -450.000, Netflix -54.000, Bioskop XXI -60.000 (total -564.000); 7 November 2026 Gaji November +8.500.000, Belanja Bulanan -245.000, Kimia Farma -86.500 (total +8.168.500).
- Transaksi Terbaru di Beranda mengambil lima teratas dari daftar itu (Warung Padang, Gojek, Kopi Kenangan, Listrik PLN, Netflix) dengan label relatif ("Hari ini", "Kemarin").
- Profil: "Total Saldo Rp 24,8 jt" (pembulatan setengah ke atas dari 24.750.000). Komponen Hero dan halaman token memakai Rp 24.750.000 dan "+8,2% dari bulan lalu".
- Scan Nota: nota placeholder diganti "TOKO SUMBER REJEKI, total Rp 103.400" agar cocok dengan Hasil Scan.
- Form "Tambah Hutang/Piutang - Terisi" (Budi, Rp 3.000.000): tanggal pinjam "9 Okt 2026" sesuai Detail Piutang.
- Emas: nilai tersimpan Rp 4.870.000 dari valuasi terakhir; harga per gram ditampilkan "sekitar Rp 1.522.000" (nilai aset adalah nilai valuasi tersimpan, bukan hasil kali, agar total Rp 12.930.000 tetap). Rumus di BR-23.
- Backdrop di bawah sheet memakai satu salinan Beranda yang sama.

## D. Keputusan penutup OI-26 sampai OI-37 (disetujui pemilik produk)
Seluruh usulan di bawah disetujui ("setuju semua", 9 November 2026). Hal yang sengaja ditunda ada di bagian G.
| ID | Keputusan | Prioritas | Diterapkan di |
|---|---|---|---|
| OI-26 | Set data demo bagian C (dompet, anggaran, transaksi, label) menjadi seed dan data uji | P1 | 03, 05 C.3, 10 bagian 2, 12 S11 |
| OI-27 | Isi tombol/chip aktif, ikon dan label nav aktif, dan teks aksen pada latar terang memakai #047857 (putih/#047857 = 5,48:1). Warna #059669 tetap untuk `income`, `status-good`, dan awal gradien hero. Mengubah pilihan awal #059669 karena tidak memenuhi 4,5:1 | P1 | 08, 11 P2-1, CLAUDE.md, 12 F01 |
| OI-28 | Anggaran dan kartu Pemasukan/Pengeluaran Beranda ikut mengecualikan source `debt` dan `debt_payment` seperti Analitik | P1 | 05 BR-04, 06 bagian 8 |
| OI-29 | Teks percakapan chat disimpan 90 hari lalu dibersihkan pg_cron; layar riwayat percakapan ke backlog pasca-rilis | P2 | 06, 07 bagian 6 |
| OI-30 | Dikerjakan di fase terkait dan wajib sebelum rilis: Syarat & Ketentuan, Kebijakan Privasi, dialog Hapus Akun, edit/hapus hutang, Tambah Pembelian/Perbarui Nilai/edit aset, pemilih platform. Backlog pasca-rilis: Kategori Saya, Ekspor Data, Bantuan, Notifikasi, Riwayat Saling Hapus | P1 | 03, 09 fase 8, 13 |
| OI-32 | Kategori pemasukan "Investasi" dipertahankan (hasil investasi) | P2 | 05 BR-25 |
| OI-33 | Teks versi dirata-tengahkan terhadap tombol Keluar 208 px | P3 | 11 P1-8 |
| OI-34 | Baris "Mata Uang IDR (Rp)" tampil tanpa aksi (terkunci IDR) | P3 | 03 |
| OI-35 | Varian "Kosong - Pengguna Baru": ringkasan Rp 0 / 0 orang / saldo bersih Rp 0 | P2 | 03, 11 P1-5 |
| OI-36 | "Pilih dari kontak" hanya dari tabel contacts RekapFin; impor kontak perangkat masuk Usulan | P2 | 06, 03 |
| OI-37 | Jatuh tempo relatif 0 sampai 3 hari, filter Jatuh Tempo 0 sampai 7 hari | P2 | 05 BR-19 |
OI-02, OI-16, dan OI-19 (sebelumnya "usulan berlaku") juga disetujui.

### D2. Penutupan OI-31 dan OI-38 sampai OI-49 (semua Diputuskan)
| ID | Keputusan | Diterapkan di |
|---|---|---|
| OI-31 | Saldo negatif diizinkan dengan peringatan (tidak diblokir). Arsip dompet bersaldo bukan nol dilarang; transfer asal sama dengan tujuan ditolak; hapus pembayaran menghapus transaksi tertaut | 05 BR-30 dan BR-31, 06 bagian 6, 10 T-WAL-13, 11 P1-11 |
| OI-38 | `budgets` dan `monthly_budgets` serta `scans` kelas A (hanya RPC); `contacts` kelas B (tulis langsung di bawah RLS dengan FK komposit); `pending_actions`, `ai_usage`, `request_log` tetap kelas A (keputusan 11 audit); gate versi hanya setelah login | 06 bagian 1, 05 BR-08 dan BR-40, CLAUDE.md |
| OI-39 | Layar "Perbarui Aplikasi" dan state offline didesain belakangan (P2); sebelum itu placeholder fungsional | 03 bagian 8, 11 P2-3 |
| OI-40 | Model chat dipilih di fase 7 | 07, 09 fase 7 |
| OI-41 | `storage-janitor` boleh memakai service role; hanya terjadwal, tidak dapat dipanggil pengguna, hanya menghapus file yatim | 07 bagian 7 |
| OI-42 | Perilaku hapus akun (Storage) diuji di proyek dev pada fase 1; pencabutan token Apple ditunda ke rilis iOS (OI-51) | 07 bagian 11, 09 fase 1, 10 T-DEL |
| OI-43 | Nominal maksimum Rp 100 miliar per transaksi; batas tanggal, panjang string, dan ukuran file disetujui | 06 bagian 3, 07 bagian 8, 10 T-MON-06 |
| OI-44 | Zona yang didukung: Asia/Jakarta, Asia/Makassar, Asia/Jayapura; ganti zona memindahkan batas bulan/hari secara retroaktif | 06 bagian 3.2, 07 bagian 13 |
| OI-45 | `request_log` 30 hari; `scans` 7 hari (tafsiran: scan tanpa transaksi/pembelian tertaut dihapus 7 hari setelah dibuat); `pending_actions` kedaluwarsa 10 menit; scan `processing` lebih dari 1 jam menjadi `failed` | 06, 07 bagian 7.3, 10 T-JAN |
| OI-46 | Saling hapus tidak dapat dibatalkan di MVP; layar konfirmasi wajib memuat peringatan; `delete_debt_v1` hanya untuk catatan tanpa pembayaran dan tanpa alokasi saling hapus | 05 BR-07, 03, 11 P1-12 |
| OI-47 | Cache saldo hanya jika p95 lebih dari 300 ms pada 10.000 transaksi | 10 T-PERF-06 |
| OI-48 | Kuota fallback habis: tampil pesan dan arahan ke input manual (tanpa hasil amber) | 05 BR-14, 07 bagian 5, 03, 11 P2-4 |
| OI-49 | PITR dicek pemilik di dashboard; cadangan manual berkala sebagai cadangan; rotasi rahasia 90 hari; larangan service role di `ocr-parse` dan `chat` ditegakkan lewat kode dan CI | 07 bagian 14 |

### D3. Keputusan sesi sprint plan (OI-50 sampai OI-53)
| ID | Keputusan | Diterapkan di |
|---|---|---|
| OI-50 | Rilis pertama mencakup seluruh cakupan PRD: fase 0 sampai 8 termasuk investasi (fase 6) dan asisten AI (fase 7). Tidak ada rilis parsial setelah fase 5 | 13 bagian 1 dan 12 |
| OI-51 | Android lebih dulu. Ditunda sampai setelah rilis Android: Sign in with Apple, TestFlight dan App Store, pencabutan token Apple (T-DEL-07), uji Face ID. Konsekuensi: tombol Apple disembunyikan di desain, label "Face ID" menjadi "Biometrik" (11 P1-13) | 02 AUT-03, 03, 07, 09, 10, 12, 13, CLAUDE.md |
| OI-52 | Penyedia AI adalah Google AI (Gemini API), bukan Claude. Produksi wajib akun dengan penagihan aktif karena kuota gratis dapat dipakai Google untuk meningkatkan produk dan ditinjau manusia (terverifikasi; periksa ketentuan terkini); dev dan staging hanya data sintetis. Nama model dikonfigurasi dan daftar model diverifikasi sebelum fase 4. Kuota harian RekapFin (20/50/10) tetap | 05 BR-11, 07 bagian 10.1, 09, CLAUDE.md, 13 |
| OI-53 | Distribusi rilis pertama: APK Android bertanda tangan yang dibagikan lewat Google Drive ke akun tertentu dan dipasang manual, bukan Play Store. Konsekuensi: syarat toko tidak berlaku (closed test 12 penguji x 14 hari, Data safety, kebijakan hapus akun Google Play, review); keystore, SHA-1 OAuth, `versionCode`, panduan pasang/perbarui, dan `update_url` menjadi pekerjaan sendiri. Play Store menjadi opsi kelak | 05 BR-46, 06 app_config, 07 bagian 16.1, 09, 10 T-DST, 13 |

### D4. Keputusan pembaruan sebelum Sprint 0 (OI-54 sampai OI-57)
| ID | Keputusan | Diterapkan di |
|---|---|---|
| OI-54 | Persetujuan pemrosesan AI dicatat di `profiles.ai_consent_at` (timestamptz null) dan `ai_consent_version` (text null) hanya lewat `record_ai_consent_v1`. `start_scan_v1`, `claim_scan_fallback_v1`, dan `consume_chat_quota_v1` menolak dengan `ai_consent_required` bila kosong, tanpa memotong kuota. Pencabutan persetujuan tidak ada di rilis pertama [ASUMSI]. Catatan: RPC bernama `consume_ai_quota_v1` tidak ada di 06; kuota dipotong oleh tiga RPC di atas | 05 BR-47, 06 profiles dan 9.1, 02 SCN-09, 10 T-CNS-01..07, 11 P1-17, 13 D-16 |
| OI-55 | Nilai visual (warna, radius, ukuran tombol dan chip, fs-display, glass-shadow, gradien hero, nama token status, token layout) bersumber dari RekapFin.pen terkini. Tombol Tanya AI di (240, 684) ukuran 130 x 52; zona bebas teks/nominal x 302..390, y 672..744. Layout: frame 390 x 844 adalah viewport; konten lebih tinggi digulir dengan padding bawah 160 px; BottomNavBar dan Tanya AI fixed; jarak minimum antar section 16 dan antar kartu 12; chip filter adalah baris yang bisa digeser (chip terakhir boleh terpotong) | 08 bagian 1 sampai 8, CLAUDE.md, 11 P2-1 dan P2-2b, 14 |
| OI-56 | Commit per modul diizinkan setelah tes yang relevan hijau; push hanya atas perintah pemilik produk; menghapus berkas tetap harus diminta | CLAUDE.md, 13 bagian 2.3 |
| OI-57 | Jatuh tempo Budi tetap 12 Nov 2026 di semua dokumen dan data uji (10 bagian 2.1); hanya Pak Hendra (hutang) menjadi 30 Nov 2026 (OI-05) | 03, 10, 11 P1-5, 14 |

## F. Keputusan audit arsitektur (diterapkan di dokumen)
Tiga belas keputusan ini dirujuk di dokumen lain sebagai "keputusan 1" sampai "keputusan 13" (mis. "keputusan 6" = FK satu arah dan matriks CHECK). Nomor di kolom pertama adalah nomor keputusan.

| # | Keputusan | Diterapkan di |
|---|---|---|
| 1 | Tabel berinvarian tidak dapat ditulis langsung; RPC `SECURITY DEFINER` dengan `search_path` tetap, cek `auth.uid()`, EXECUTE dicabut dari anon dan PUBLIC | 06 bagian 1, 05 BR-40, 07 bagian 9 |
| 2 | MVP online-only; OCR ML Kit, Face ID, notifikasi lokal tetap jalan offline | 07 bagian 12, 05 BR-39 |
| 3 | Migrasi maju-saja, expand-contract, RPC berversi, versi minimum aplikasi, `seed.sql` terpisah, kunci per lingkungan, rotasi, cadangan/PITR, `--dart-define` bukan rahasia | 07 bagian 14, 05 BR-41 |
| 4 | `profiles.timezone`; hari/bulan dihitung di RPC | 06 bagian 3.2, 07 bagian 13, 05 BR-42, 10 T-TZ |
| 5 | `client_request_id` di semua RPC tulis; fallback membawa `scan_id`, batas 10/hari | 06 bagian 1.3, 07 bagian 10, 05 BR-28 dan BR-40 |
| 6 | FK satu arah; matriks CHECK `type` x `source` x `counter_wallet_id` | 06 bagian 2 dan 5 |
| 7 | FK komposit `(user_id, id)` untuk semua tabel anak | 06 bagian 3.1 |
| 8 | Arsip dompet bersaldo bukan nol dilarang; rumus saldo eksplisit; indeks `counter_wallet_id` | 06 bagian 6 dan 10, 05 BR-30 dan BR-43 |
| 9 | Hapus akun: CASCADE, urutan Storage, token Apple, DB, auth; dapat diulang; verifikasi web | 07 bagian 11, 06 bagian 12, 05 BR-44 |
| 10 | Daftar indeks, paginasi keyset, pg_trgm; saldo tetap dihitung | 06 bagian 10, 10 T-PERF |
| 11 | Service role hanya di delete-account (dengan pembatasan); kuota/scans/pending_actions lewat RPC definer dengan JWT pengguna; cara membuat klien dan verifikasi JWT | 07 bagian 7 |
| 12 | Validasi keluaran LLM dan data tak tepercaya | 07 bagian 8, 05 BR-45, 10 T-LLM |
| 13 | Konsistensi: nilai aset = valuasi terbaru, `payment_channel`, model chat ditunda ke fase 7 (OI-40), RPC tambahan atomik, hapus file Storage setelah commit dan pembersih terjadwal, daftar atomik diperluas | 06 bagian 4 dan 9, 07 bagian 3 dan 7.3 |

Verifikasi web yang dilakukan pada 9 November 2026: syarat penghapusan akun Apple dan pencabutan token Sign in with Apple (terverifikasi); perilaku Supabase saat pengguna memiliki objek Storage (terverifikasi di dokumentasi, belum diuji di proyek); anjuran `search_path` tetap dan pencabutan EXECUTE pada fungsi definer (terverifikasi di dokumentasi). Yang tidak terverifikasi tercantum di 07 bagian 11 (tabel Status verifikasi).

## G. Tindak lanjut terjadwal dari keputusan (ditunda sengaja, bukan butir terbuka)
| Tindak lanjut | Pemicu | Pemilik | Rujukan |
|---|---|---|---|
| Desain layar "Perbarui Aplikasi" dan state offline (P2) | setelah MVP fase 0 sampai 3 berfungsi dengan placeholder | desainer | 03 bagian 8, 11 P2-3 |
| Desain state "Batas Harian Tercapai" (P2) | sebelum fase 4 | desainer | 03, 11 P2-4 |
| Memilih model chat | gerbang fase 7 | pemilik produk dan pengembang | 09 fase 7 |
| Menguji hapus akun di proyek dev (Storage) | fase 1 | pengembang | 09 fase 1, 10 T-DEL-02 |
| Memeriksa PITR di dashboard Supabase dan mencatat hasilnya | sebelum fase 0 selesai | pemilik produk | 07 bagian 14 |
| Menjadwalkan cadangan manual berkala | fase 0 | pengembang | 12 (S00 dan DoD), 07 bagian 14 |
| Membuat keystore, mencadangkannya di dua tempat terpisah, dan mendaftarkan SHA-1 pada klien OAuth Google | X-04 (Sprint 1) | pengembang | 07 bagian 16.1 |
| Menyusun panduan pasang dan perbarui APK untuk penguji | X-13 | pengembang | 07 bagian 16.1, 10 T-DST-08 |
| Rilis iOS: Sign in with Apple, TestFlight dan App Store, pencabutan token Apple (T-DEL-07), uji Face ID, label Face ID | setelah rilis Android | pengembang | OI-51, 13 bagian 10 |
| Bila kelak memakai Play Store: syarat closed test 12 penguji x 14 hari (akun personal), Data safety, dan kebijakan hapus akun Google Play | pasca-rilis | pemilik produk | 07 bagian 11, 13 bagian 10 |
| Memeriksa ketentuan Gemini API terkini dan mengaktifkan penagihan untuk produksi | sebelum fase 4 | pemilik produk | 07 bagian 10.1 |
| Menambah tes untuk BR-19 (label dan filter jatuh tempo), BR-21 (persen terbayar), BR-27 (jadwal notifikasi), dan BR-36 (biometrik bawaan mati) di 10 | BR-36 sebelum Sprint 6 (F11); BR-19, BR-21, BR-27 sebelum Sprint 21 (S13) | pengembang | 05, 10 |
| Memperluas 12-build-plan untuk modul fase 4 sampai 8 (36 story dan TRX-09 dipetakan ke modul S/E/F, menggantikan [PROVISIONAL] di 13) | sebelum Sprint 17 (S12) | pengembang dan pemilik produk | 12 bagian 7, 13 |
| Mengganti nama frame dan menerapkan koreksi di .pen sesuai 11 (P2-2b, P1-13, dan seterusnya) dan menjalankan D-01 sebelum Sprint 1 | sebelum Sprint 2 (F02) | desainer | 11, 14 |
| Membuat layar Notifikasi, Riwayat Saling Hapus, Riwayat Percakapan chat, Kategori Saya, Ekspor Data, dan Bantuan | backlog pasca-rilis (setelah rilis pertama) | - | 03, 13 bagian 10 |

## H. Keputusan tertunda (Tertunda, belum diputuskan)
Butir di bawah belum diputuskan dan tidak memblokir Sprint 0 sampai 3. Setiap butir punya pemilik dan tenggat; agen coding tidak memutuskan sendiri.
| ID | Masalah | Pilihan awal [ASUMSI] | Pemilik | Tenggat | Rujukan |
|---|---|---|---|---|---|
| OI-58 | Menyembunyikan konten aplikasi di pratinjau task switcher (privasi tangkapan layar) | Android `FLAG_SECURE` atau lapisan blur saat aplikasi di latar; pengorbanan: tangkapan layar pengguna ikut diblokir | pemilik produk | sebelum Sprint 31 (fase 8) | 07 bagian 15 |
| OI-59 | State desain yang belum ada: fokus input dan skeleton (state disabled dan pressed tombol sudah didesain) | Cincin fokus accent-action 2 px; skeleton blok kaca tanpa animasi di MVP | desainer | sebelum Sprint 12 (F23) | 08 bagian 7 |
| OI-60 | Target metrik keberhasilan (aktivasi 50%, retensi minggu 4 30%, akurasi OCR 85%, crash-free 99,5%) | Angka di 01 bagian 4 dipakai sebagai target awal | pemilik produk | sebelum beta (Sprint 25) | 01 bagian 4 |
| OI-61 | Kapasitas nyata per sprint, apakah waktu desain pen.dev dihitung di dalam kapasitas 8 poin atau terpisah, ketersediaan (libur), dan anggaran biaya AI | 8 poin per sprint dengan desain di dalam kapasitas; dikalibrasi di Sprint 2 (X-01) | pemilik produk | Sprint 2 | 13 bagian 12 (keputusan 4 dan 5) |

## E. Usulan (ide tambahan, di luar desain, tidak dikerjakan)
1. Tema gelap.
2. Ekstrak komponen berulang: segmented control, header sheet, search bar, kartu KPI, ring/bar progres, badge status, avatar inisial, toggle, keypad, kartu proses, baris form.
3. Penjualan aset dan harga emas otomatis.
4. Transaksi berulang (langganan, tagihan).
5. Ekspor lebih kaya.
6. Input suara di Asisten (setelah OI-20 ditunda).
7. Impor kontak perangkat (OI-36).
8. Pengiriman pengingat lewat WhatsApp (OI-22 ditunda).
9. Layar Notifikasi dan Riwayat Saling Hapus (ditunda).
