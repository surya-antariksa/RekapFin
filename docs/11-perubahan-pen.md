# 11. Daftar Perubahan untuk pen.dev (prompt siap tempel)

> Ringkasan: daftar perubahan yang harus dilakukan di RekapFin.pen setelah keputusan OI-01 sampai OI-57, diurutkan per prioritas (P0 layar baru yang memblokir pembangunan, P1 koreksi isi dan data, P2 token dan kontras, P3 kosmetik). Setiap butir berupa prompt yang dapat ditempel ke pen.dev. Dokumen ini tidak mengubah file .pen; perubahan dilakukan pemilik produk, desainer, atau pen.dev. Beberapa butir sudah diterapkan di file (P2-1, P2-1b, sebagian P2-2, sebagian P1-5, sebagian P2-3 berupa komponen tombol); statusnya ada di [14-status-desain.md](14-status-desain.md). Set data demo (OI-26) dan warna tombol (OI-27) sudah disetujui.

Status: Disinkronkan dengan RekapFin.pen terkini (9 November 2026): token dan varian komponen sudah ada di file; layar produk (43) dan layar baru (53 frame) belum dikoreksi. Butir Tertunda OI-58 sampai OI-61 tidak menambah prompt. Jatuh tempo Budi tetap 12 Nov 2026; hanya Pak Hendra (hutang) 30 Nov 2026 (OI-57).

## Cara memakai
1. Tempel "Prompt konteks" di bawah pada awal sesi pen.dev, sekali saja.
2. Tempel satu prompt per langkah, urut dari P0. Setiap prompt berdiri sendiri.
3. Setelah tiap langkah periksa: tidak ada teks terpotong, kontras cukup, tidak ada teks di bawah 12 px (kecuali label nav, "Tanya AI", dan label Aksi Cepat 11 px), tidak ada teks atau nominal di zona Tanya AI (x 302..390, y 672..744) pada layar bernav; tombol Tanya AI sendiri di (240, 684) ukuran 130 x 52.
4. Layar baru dibuat sebagai frame tingkat atas 390 x 844 di section yang ditunjuk, dengan `placeholder: true` selama dikerjakan, dan nama persis seperti yang tertulis.

## Prompt konteks (tempel dulu)
```
Kamu mengedit desain mobile "RekapFin" (iOS glassmorphism terang, satu warna emerald, font Plus Jakarta Sans, ikon Lucide 1.75 px, bahasa Indonesia).
Aturan: gunakan variabel yang sudah ada ($bg-base, $accent, $accent-action, $income, $expense, $warning, $warning-text, $status-ok, $status-warn, $status-danger, $text-primary, $text-secondary, $text-muted, $glass-fill, $glass-border, $radius-card 24, $radius-button 16, $radius-chip 999, $radius-nav 34, $screen-padding 20). Frame layar 390 x 844 adalah viewport; padding konten 20 (atas 54, bawah 24); konten yang lebih tinggi dari 844 digulir dengan padding bawah 160; BottomNavBar dan Tanya AI fixed; jarak minimum antar section 16 dan antar kartu 12; baris chip filter bisa digeser horizontal dan chip terakhir boleh terpotong. Latar dari komponen "Latar RekapFin". Salin komponen yang ada (GlassCard, GlassCard/Hero, FilterChip/Aktif, FilterChip/Tidak aktif, PrimaryButton 350 x 56 dan variannya, TransactionItem dan variannya, BottomNavBar) sebagai instance; jangan membuat gaya baru. Format uang "Rp 1.250.000" dan negatif "-Rp 35.000". Teks minimal 12 px. Layar bernav memakai BottomNavBar 350 x 68 di x=20,y=752 dan tombol "Tanya AI" di x=240,y=684 (jangan taruh teks atau nominal di x 302..390, y 672..744). Jangan ubah layar lain selain yang disebut. Beri nama setiap node. Jangan gambar logo atau ilustrasi.
```

## P0: Layar baru yang diwajibkan (memblokir pembangunan)

### P0-1 Tambah Transaksi: kategori seragam dan field Dompet (OI-06, OI-08)
Target: frame `Tambah Transaksi - Pengeluaran` (XQW61), `Tambah Transaksi - Pemasukan` (paxrS), `Tambah Transaksi - Terisi` (l9Zn5t).
```
Pada tiga frame sheet "Tambah Transaksi" lakukan:
1. Tab Pengeluaran: ganti daftar kategori menjadi persis 8 item, urutan: Makanan, Transport, Belanja, Tagihan, Hiburan, Kesehatan, Pendidikan, Lainnya. HAPUS kategori "Investasi". Frame "Terisi" harus memakai daftar yang sama (Makanan terpilih).
2. Tab Pemasukan: pertahankan 8 kategori: Gaji, Bonus, Freelance, Investasi, Hadiah, Penjualan, Refund, Lainnya.
3. Tambahkan satu baris field "Dompet" tepat di atas baris Tanggal, gaya sama dengan field Tanggal: ikon dompet (lucide "wallet"), label "Saldo Utama", chevron di kanan. Tinggi sheet boleh bertambah; pastikan tombol "Simpan Transaksi" tetap terlihat penuh.
Jangan ubah elemen lain.
```

### P0-2 Layar Onboarding Saldo Awal (/onboarding) (OI-08)
Section: AUTENTIKASI, di sebelah kanan frame `Daftar (/signup)`.
```
Buat frame baru "Onboarding Saldo Awal (/onboarding)" 390 x 844 dengan Latar RekapFin. Tanpa bottom nav dan tanpa Tanya AI.
Isi (vertikal, padding 20, atas 54):
- Ikon dompet lucide "wallet" 28 px dalam lingkaran 56 px berisi $income-soft.
- Judul "Berapa saldo awalmu?" 28 px bold $text-primary.
- Teks "Isi saldo Saldo Utama sebagai titik awal. Kamu bisa mengubahnya nanti di layar Dompet." 14 px $text-secondary.
- GlassCard berisi label "Saldo awal" 12 px, nominal besar "Rp 0" 40 px ExtraBold ($text-primary), lalu keypad angka 3 x 4 (1-9, 000, 0, hapus) gaya sama dengan keypad di "Tambah Transaksi - Terisi".
- PrimaryButton "Lanjut" lebar 350 di bawah.
- Tautan teks "Lewati" (14 px semibold $text-secondary) di bawah tombol, rata tengah.
Buat juga satu varian "Onboarding Saldo Awal - Terisi" dengan nominal "Rp 18.500.000".
```

### P0-3 Layar Lupa Kata Sandi (/forgot-password) (OI-17)
Section: AUTENTIKASI.
```
Buat frame "Lupa Kata Sandi (/forgot-password)" 390 x 844, tanpa nav. Salin gaya layar "Daftar (/signup)".
Isi: tombol kembali (ikon lucide arrow-left), judul "Lupa kata sandi?" 28 px bold, teks "Masukkan email akunmu. Kami akan mengirim tautan untuk mengatur ulang kata sandi." 14 px, field "Email" (salin field dari layar Masuk) berisi "rizky@email.com", PrimaryButton "Kirim Tautan Reset", tautan "Kembali ke Masuk".
Buat dua varian: "Lupa Kata Sandi - Error" (field email merah dengan ikon error dan pesan "Format email tidak valid", salin pola dari "Masuk - Error") dan "Lupa Kata Sandi - Terkirim" (kartu kaca dengan ikon centang hijau, judul "Tautan terkirim", teks "Periksa kotak masuk rizky@email.com", tombol "Kembali ke Masuk").
```

### P0-4 Layar Dompet (/wallets) dan Form Dompet (OI-08)
Section: AKUN, di sebelah kanan `Edit Profil (/edit-profile)`.
```
Buat frame "Dompet (/wallets)" 390 x 844 dengan BottomNavBar (tanpa tab aktif) dan Tanya AI.
Isi: tombol kembali, judul "Dompet" 28 px.
- Instance GlassCard/Hero berisi label "Total Saldo", nilai "Rp 24.750.000", keterangan "Jumlah semua dompet. Nilai investasi tidak ikut."
- Daftar 3 baris dompet dalam satu GlassCard, tiap baris: bubble ikon 44 px ($income-soft; ikon lucide "landmark" untuk Bank, "banknote" untuk Tunai, "smartphone" untuk E-wallet), nama + jenis (12 px $text-secondary), saldo kanan 14 px bold: "Saldo Utama" jenis Bank "Rp 18.500.000" dengan badge kecil "Utama"; "Tunai" "Rp 1.250.000"; "E-wallet" "Rp 5.000.000".
- PrimaryButton "Tambah Dompet" (ikon plus) di bawah daftar, pastikan tidak menimpa zona Tanya AI (naikkan daftar bila perlu).
Buat frame "Form Dompet - Tambah" sebagai sheet gaya sama dengan "Tambah Hutang/Piutang - Piutang" di atas salinan layar Dompet: header "Tambah Dompet" + tutup; segmented 3 pilihan "Tunai | Bank | E-wallet" (gaya segmented Pengeluaran/Pemasukan); field "Nama dompet" (placeholder "Contoh: BCA"); field "Saldo awal" nominal 36 px "Rp 0"; PrimaryButton "Simpan".
Buat "Form Dompet - Ubah" untuk Tunai: judul "Ubah Dompet", nilai terisi (Tunai, "Rp 1.250.000"), tambahan tombol teks merah "Arsipkan Dompet".
```

### P0-4b Dompet bersaldo tidak bisa diarsipkan (BR-43)
Target: salinan `Form Dompet - Ubah` dari P0-4. Dikerjakan bersama D-03.
```
Dari "Form Dompet - Ubah" buat tiga varian:
1. "Form Dompet - Arsip Ditolak": dompet Tunai bersaldo "Rp 1.250.000"; tombol teks "Arsipkan Dompet" tampil nonaktif (opasitas 0.5); di bawahnya kartu peringatan bergaya $warning-soft dengan ikon lucide "info" dan teks "Dompet masih bersaldo Rp 1.250.000. Pindahkan saldo ke dompet lain lewat Transfer sebelum diarsipkan." (teks amber memakai $warning-text) serta tautan teks "Buka Transfer".
2. "Form Dompet - Arsip Dompet Utama": dompet "Saldo Utama" dengan tombol "Arsipkan Dompet" nonaktif dan teks bantu "Dompet utama tidak dapat diarsipkan."
3. "Arsipkan Dompet - Konfirmasi": dialog kaca di tengah di atas overlay transparan untuk dompet E-wallet bersaldo "Rp 0": judul "Arsipkan dompet?", teks "Dompet E-wallet tidak lagi tampil di pemilih dompet. Riwayat transaksinya tetap ada.", tombol "Arsipkan" (PrimaryButton) dan "Batal".
```

### P0-5 Layar Transfer (/transfer) (OI-07)
Section: TRANSAKSI & SCAN NOTA.
```
Buat frame "Transfer (/transfer)" 390 x 844 sebagai sheet di atas salinan Beranda (gunakan salinan Beranda yang sama dengan "Tambah Transaksi - Pengeluaran"), gaya identik sheet "Tambah Transaksi".
Header "Transfer" + tombol tutup. Konten:
- Kartu "Dari": ikon dompet, label "Dari", nilai "Saldo Utama", saldo kecil "Rp 18.500.000", chevron.
- Ikon panah-bawah lucide "arrow-down" dalam lingkaran kecil di antara dua kartu.
- Kartu "Ke": label "Ke", nilai "Tunai", chevron. Di bawah kartu, baris chip "Dompet | Investasi" (FilterChip, "Dompet" aktif).
- Nominal "Rp 0" 40 px ExtraBold, field Tanggal "Hari ini, 9 Nov 2026", field Catatan (opsional).
- PrimaryButton "Simpan Transfer".
Buat tiga varian: "Transfer - Terisi" (Dari Saldo Utama, Ke Tunai, nominal "Rp 500.000", keypad tampil seperti "Tambah Transaksi - Terisi"), "Transfer - Error" (Dari dan Ke sama "Saldo Utama", pesan merah "Dompet asal dan tujuan harus berbeda"), dan "Transfer - Ke Investasi" (chip "Investasi" aktif, kartu Ke berisi "Investasi" dengan teks bantu "Lanjut ke Tambah Investasi. Tidak dihitung sebagai pengeluaran." dan tombol berlabel "Lanjut").
```

### P0-6 Detail Transaksi dan Edit Transaksi (OI-17)
Section: TRANSAKSI & SCAN NOTA.
```
Buat frame "Detail Transaksi (/transaction-detail)" 390 x 844, tanpa nav, gaya mirip "Detail Piutang (/debt-detail)".
Isi: tombol kembali, judul "Detail Transaksi"; kartu kaca berisi bubble ikon 56 px (ikon shopping-bag, $expense-soft), nama "Warung Padang", nominal "-Rp 35.000" 32 px ExtraBold warna $expense; GlassCard info dengan baris label-nilai (14 px): Kategori "Makanan", Dompet "Saldo Utama", Tanggal "9 Nov 2026, 12.30", Sumber "Manual", Catatan "Makan siang". Dua tombol bawah: PrimaryButton "Ubah" dan tombol sekunder merah "Hapus" (gaya kaca seperti tombol Hapus di Detail Piutang).
Varian: "Detail Transaksi - Pemasukan" (Gaji November, "+Rp 8.500.000" warna $income, ikon wallet), "Detail Transaksi - Transfer" (judul "Transfer", "Saldo Utama ke Tunai", "Rp 500.000" warna $text-primary, tanpa kategori), dan "Detail Transaksi - Dari Catatan Hutang" (sumber "Pembayaran hutang", teks "Ubah lewat catatan hutang", tombol "Buka Catatan" menggantikan Ubah/Hapus).
Buat "Edit Transaksi" sebagai sheet bergaya "Tambah Transaksi - Terisi" dengan judul "Ubah Transaksi", nominal "Rp 35.000", kategori Makanan terpilih, field Dompet, tombol "Simpan Perubahan".
Buat "Dialog Hapus Transaksi": dialog kaca di tengah di atas overlay gelap transparan, judul "Hapus transaksi?", teks "Transaksi ini akan dihapus dan saldo dihitung ulang.", tombol "Hapus" ($expense) dan "Batal".
```

### P0-7 Atur Anggaran (/budget-edit) (OI-11)
Section: UTAMA, di sebelah kanan `Anggaran (/budget)`.
```
Buat frame "Atur Anggaran (/budget-edit)" 390 x 844, tanpa nav, gaya halaman dengan tombol kembali.
Isi: judul "Atur Anggaran", pemilih bulan "November 2026" (komponen dari layar Anggaran).
- Kartu "Total Anggaran": label, nominal "Rp 6.000.000" 32 px ExtraBold.
- Teks "Batas per kategori" 16 px bold. Daftar baris kategori (nama, input nominal): Makanan "Rp 2.400.000", Transport "Rp 1.400.000", Hiburan "Rp 550.000", Tagihan "Rp 1.500.000", Belanja "Tidak diatur", Kesehatan "Tidak diatur", Pendidikan "Tidak diatur", Lainnya "Tidak diatur".
- Baris ringkasan: "Dialokasikan Rp 5.850.000 dari Rp 6.000.000" dan "Belum dialokasikan Rp 150.000" ($text-secondary).
- PrimaryButton "Simpan".
Varian "Atur Anggaran - Error": jumlah kategori melebihi total (Makanan "Rp 3.000.000" sehingga dialokasikan Rp 6.450.000), ringkasan merah "Jumlah kategori melebihi Total Anggaran sebesar Rp 450.000", PrimaryButton tampak nonaktif (opasitas 0.5).
```

### P0-8 Pengaturan (/settings) (OI-10, OI-25)
Section: AKUN.
```
Buat frame "Pengaturan (/settings)" 390 x 844, tanpa nav, tombol kembali, judul "Pengaturan" 28 px.
GlassCard "Keamanan": baris dengan ikon scan-face, judul "Masuk dengan Face ID", teks bantu "Buka sesi tersimpan dengan Face ID.", toggle (mati).
GlassCard "Privasi": baris dengan ikon image, judul "Simpan foto nota", teks bantu "Bila mati (disarankan), foto nota dan screenshot dihapus setelah dibaca.", toggle (mati).
Tambahkan GlassCard "Wilayah": baris dengan ikon globe, judul "Zona waktu", nilai "Asia/Jakarta (WIB)", chevron. Buat sheet "Pilih Zona Waktu" dengan tiga pilihan: "Asia/Jakarta (WIB)", "Asia/Makassar (WITA)", "Asia/Jayapura (WIT)", pilihan aktif bertanda centang. Pakai pola toggle yang ada di layar "Tambah Hutang/Piutang". Buat varian "Pengaturan - Face ID Aktif" dengan toggle Face ID hidup (warna $accent).
```

### P0-9 Pemilih Kontak dan Dialog Nama Ganda (OI-13)
Section: HUTANG & PIUTANG.
```
Buat sheet "Pemilih Kontak" di atas salinan layar "Tambah Hutang/Piutang - Piutang": header "Pilih Kontak" + tutup, search bar "Cari nama...", daftar kontak (avatar inisial 40 px, nama, nomor): Budi Santoso (0812 3456 7890), Siti Rahma, Andi Wijaya, Pak Hendra (0813 5555 0101), Kak Rina, Dewi Lestari (0856 1234 5678), dan tombol "Kontak baru" (ikon plus).
Buat "Dialog Nama Ganda": dialog kaca di tengah di atas overlay transparan, judul "Nama sudah ada", teks "Sudah ada kontak 'Budi Santoso' (0812 3456 7890). Pakai kontak ini atau buat kontak baru?", tombol "Pakai kontak ini" (PrimaryButton) dan tombol kaca "Buat kontak baru".
```

### P0-10 Dialog Hapus Akun dan login ulang (OI-30, PRF-03)
Target: salinan `Edit Profil (/edit-profile)` (uRAc5), tombol "Hapus Akun".
```
Di atas salinan "Edit Profil" buat tiga frame:
1. "Hapus Akun - Konfirmasi": dialog kaca di tengah di atas overlay transparan; ikon lucide "triangle-alert" ($expense); judul "Hapus akun?"; teks "Semua data keuanganmu dan foto yang tersimpan akan dihapus permanen. Tindakan ini tidak dapat dibatalkan."; field "Ketik HAPUS untuk melanjutkan"; tombol "Hapus Akun" ($expense) nonaktif sampai kolom terisi, dan "Batal".
2. "Hapus Akun - Login Ulang": sheet bergaya "Tambah Hutang/Piutang - Piutang" berjudul "Verifikasi dulu" dengan teks "Masuk ulang untuk memastikan ini kamu.", field "Kata sandi" (ikon tampilkan), PrimaryButton "Lanjutkan", dan tombol kaca "Lanjutkan dengan Google". Tidak ada tombol Apple.
3. "Hapus Akun - Gagal": dialog kaca dengan ikon "circle-alert" ($expense), judul "Penghapusan belum selesai", teks "Coba lagi untuk melanjutkan. Datamu belum terhapus seluruhnya.", tombol "Coba lagi" dan "Tutup".
```

## P1: Koreksi isi, teks, dan data

### P1-1 Anggaran: angka dan warna status (OI-11, OI-26 disetujui)
Target: `Anggaran (/budget)` (mqN4J).
```
Perbarui layar Anggaran. Ringkasan: Total Anggaran "Rp 6.000.000", Terpakai "Rp 5.230.000", Sisa "Rp 770.000", ring "87%" dengan warna $warning (amber), chip "21 hari tersisa".
Empat kategori, baris Judul / Status:
- Makanan: "Rp 1.990.000 / Rp 2.400.000", "83% terpakai", "Sisa Rp 410.000", bar dan teks status warna $warning.
- Transport: "Rp 730.000 / Rp 1.400.000", "52% terpakai", "Sisa Rp 670.000", warna $income (hijau).
- Hiburan: "Rp 520.000 / Rp 550.000", "95% terpakai", "Hampir melebihi batas!", warna $expense (merah).
- Tagihan: "Rp 1.255.000 / Rp 1.500.000", "84% terpakai", "Sisa Rp 245.000", warna $warning.
Aturan warna: kurang dari 70% hijau, 70 sampai 90 amber, lebih dari 90 merah. Tambahkan catatan kecil 12 px di bawah ringkasan: "Termasuk pengeluaran kategori tanpa anggaran." Hubungkan tombol "Atur Anggaran Baru" ke frame "Atur Anggaran (/budget-edit)" bila pen.dev mendukung interaksi.
```

### P1-2 Beranda, Transaksi, Analitik: data konsisten (OI-14, OI-26 disetujui)
Target: `Beranda (/home)` (ir3EN), `Transaksi (/transactions)` (vj0kJ), `Analitik (/analytics)` (QBrxb).
```
Beranda: Total Saldo "Rp 24.750.000" (tetap), Pemasukan "Rp 8.500.000", Pengeluaran "Rp 5.230.000". "Transaksi Terbaru" menjadi 5 baris: Warung Padang "Makanan · Hari ini" -Rp 35.000; Gojek "Transport · Hari ini" -Rp 22.000; Kopi Kenangan "Makanan · Hari ini" -Rp 28.000; Listrik PLN "Tagihan · Kemarin" -Rp 450.000; Netflix "Hiburan · Kemarin" -Rp 54.000. Hapus baris Gaji November dari daftar ini.
Transaksi: pertahankan tiga grup (Hari Ini -Rp 85.000; Kemarin -Rp 564.000; 7 November 2026 +Rp 8.168.500). Tambahkan satu baris contoh transfer di grup 7 November: "Transfer ke Tunai" dengan pill "Transfer", nominal "Rp 500.000" warna $text-primary (tanpa tanda), dan total grup tidak berubah.
Analitik: toggle periode default "Bulan Ini" aktif (bobot 700), donat tetap berlabel "November 2026" dan Total "Rp 5.230.000", legenda 38% Makanan, 24% Tagihan, 14% Transport, 14% Belanja, 10% Hiburan. Arus Kas tetap Jun sampai Nov.
Profil: ubah "Rp 24,7 jt" menjadi "Rp 24,8 jt". Komponen Hero di frame Komponen: ganti "Naik 12% dari bulan lalu" menjadi "+8,2% dari bulan lalu".
```

### P1-3 Salinan Beranda di bawah sheet (OI-14 butir 13)
```
Ganti isi latar Beranda di balik semua sheet (Tambah Transaksi x3, Tambah Hutang/Piutang x3, Tambah Investasi, Transfer) dengan salinan tunggal yang identik dengan "Beranda (/home)" setelah P1-2 (lengkap dengan kartu Hutang & Piutang dan Investasi). Jangan ubah sheet-nya.
```

### P1-4 Chat: angka dan mikrofon (OI-09, OI-11, OI-20)
Target: `Asisten RekapFin (/chat)` (iuNsn).
```
Ubah jawaban asisten menjadi: "Pengeluaran Makanan November 2026 sebesar Rp 1.990.000, atau 83% dari anggaran Rp 2.400.000." Sembunyikan ikon mikrofon di baris input (hapus atau enabled:false) dan biarkan kamera, kolom teks, dan tombol kirim. Biarkan ikon menu di header tanpa perubahan.
```

### P1-5 Hutang & Piutang: nama varian, tanggal, teks (OI-01, OI-05, OI-15, OI-35)
Status di file: butir 1 (isi Rp 0; nama frame kini "Kosong Pengguna Baru" tanpa tanda hubung), butir 2 (30 Nov 2026), dan sebagian butir 3 (chip dan baris Informasi 30 Nov 2026) sudah diterapkan; butir 3 tombol "Kirim Pengingat" (P1-6), butir 4, dan butir 5 belum. Jangan mengubah jatuh tempo Budi: tetap 12 Nov 2026 di Detail Piutang, Tambah Hutang/Piutang - Terisi, dan Timbal Balik (OI-57).
Target: `Hutang & Piutang - Kosong` (F0or1), `Hutang & Piutang - Hutang Saya` (vwd3L), `Detail Hutang` (FYCyW), `Tambah Hutang/Piutang - Timbal Balik` (X1ziP), `Tambah Hutang/Piutang - Terisi` (E8dhpO).
```
1. Ganti nama frame F0or1 menjadi "Kosong - Pengguna Baru". Isi: Total Hutang Saya "Rp 0" "0 orang", Total Piutang "Rp 0" "0 orang", banner "Saldo bersih kamu: Rp 0". Teks kosong tetap "Belum ada catatan piutang" dan penjelasan yang ada.
2. Di frame vwd3L (Hutang Saya): baris Pak Hendra "Jatuh tempo 12 Nov 2026" menjadi "Jatuh tempo 30 Nov 2026".
3. Di frame FYCyW (Detail Hutang) ubah semua "12 Nov 2026" milik Pak Hendra menjadi "30 Nov 2026" (chip jatuh tempo dan baris Informasi). Hapus tombol "Kirim Pengingat" (ikon WhatsApp); tombol "Bayar Cicilan" tetap.
4. Di frame X1ziP ganti pesan menjadi "Kamu punya piutang Rp 2.000.000 ke Budi. Akan dihitung saling hapus."
5. Di frame E8dhpO ganti Tanggal pinjam menjadi "9 Okt 2026".
```

### P1-6 Hapus tombol yang ditunda (OI-17, OI-22)
Target: `Detail Piutang (/debt-detail)` (i5MAz), `Detail - Lunas` (X2FAH), `Catat Pembayaran (/debt-payment)` (xH9UR) dan `Catat Pembayaran - Terisi` (IqkUp), `Konfirmasi Saling Hapus - Berhasil` (OQfXg).
```
Hapus tombol "Kirim Pengingat" (ikon WhatsApp) dari semua detail dan sheet pembayaran di atas; susun ulang baris aksi: Edit dan Hapus berdampingan. Di OQfXg hapus tombol "Lihat Riwayat" sehingga hanya "Selesai". Biarkan lonceng di Beranda tanpa perubahan visual.
```

### P1-7 Field Dompet di form hutang, pembayaran, dan scan investasi (OI-08)
Target: `Tambah Hutang/Piutang` x3 (u8Ot6, E8dhpO, X1ziP), `Catat Pembayaran` x2 (xH9UR, IqkUp), `Hasil Scan Investasi` (rvl4d, Ktrcz), `Tambah Investasi` (efIGG).
```
Tambah field "Dompet" (ikon wallet, nilai "Saldo Utama", chevron) tepat di bawah toggle "Catat ke saldo & transaksi" pada tiga sheet Tambah Hutang/Piutang, dan di bawah toggle "Catat ke transaksi" pada dua sheet Catat Pembayaran. Pada Hasil Scan Investasi ganti baris "Sumber dana: Saldo Utama" menjadi pemilih dompet dengan chevron (nilai tetap "Saldo Utama"). Di Tambah Investasi tambahkan field "Sumber dana" bernilai "Saldo Utama" di bawah toggle "Catat sebagai transfer dari saldo".
```

### P1-8 Profil: menu dan layout (OI-04, OI-33, OI-17)
Target: `Profil (/profile)` (QlEkO).
```
1. Di Kartu Menu tambahkan baris "Dompet" (ikon wallet, teks kanan "3 dompet", chevron) tepat setelah "Edit Profil". Ubah baris "Keamanan & Face ID" menjadi "Pengaturan" (ikon settings, chevron). Biarkan "Notifikasi" tetap ada tanpa perubahan.
2. Pertahankan tombol "Keluar" selebar 208 di x=20, y=675 (jangan lebar penuh). Rata-tengahkan teks "RekapFin v1.0.0" terhadap tombol Keluar (textAlign center, lebar 208, x=20). Karena kartu menu bertambah satu baris, geser/ciutkan agar tombol Keluar tidak menyentuh zona Tanya AI (x 240..370, y 684..736).
3. Ubah teks statistik "Rp 24,7 jt" menjadi "Rp 24,8 jt" (bila belum dari P1-2).
```

### P1-9 Scan Nota dan Hasil Scan (OI-14, OI-24)
Target: `Scan Nota (/scan)` (i3J3oQ), `Scan Nota - Memproses` (x3TMj), `Hasil Scan (/scan-result)` (N9WYl).
```
Ganti isi placeholder nota di Scan Nota dan Memproses: "WARUNG PADANG" menjadi "TOKO SUMBER REJEKI"; item menjadi Nasi Goreng Spesial 50.000, Es Teh Manis 12.000, Ayam Bakar 32.000; TOTAL "Rp 103.400". Di Hasil Scan pertahankan tag amber "Periksa kembali" pada Total dan tambahkan tag amber yang sama pada baris Pajak 10% (varian keyakinan di bawah 85%). Tidak ada toggle simpan gambar di layar ini.
```

### P1-10 Aksi Cepat 11 px (OI-03)
Tidak ada perubahan visual. Catat saja bahwa label Aksi Cepat (Tambah Pemasukan, Tambah Pengeluaran, Transfer, Scan Nota) tetap 11 px sebagai pengecualian.

### P1-11 Peringatan saldo negatif (OI-31)
Target: `Tambah Transaksi - Terisi` (l9Zn5t), sheet `Transfer`.
```
Buat dua varian: "Tambah Transaksi - Peringatan Saldo" (salin l9Zn5t, nominal "Rp 20.000.000" untuk dompet Saldo Utama yang bersaldo Rp 18.500.000) dan "Transfer - Peringatan Saldo". Pada keduanya tambahkan kartu peringatan bergaya $warning-soft di atas tombol simpan: ikon lucide "triangle-alert", teks "Saldo Saldo Utama akan menjadi -Rp 1.500.000. Transaksi tetap dapat disimpan.", dan dua tombol kecil: "Lanjutkan" (PrimaryButton) dan "Ubah" (kaca). Teks amber memakai $warning-text.
```

### P1-12 Konfirmasi Saling Hapus: peringatan tidak dapat dibatalkan (OI-46)
Target: `Konfirmasi Saling Hapus (/debt-offset)` (Ie7pG).
```
Di sheet konfirmasi, tepat di atas tombol "Konfirmasi Saling Hapus", tambahkan baris peringatan bergaya $warning-soft dengan ikon lucide "triangle-alert" dan teks "Saling hapus tidak dapat dibatalkan." (teks memakai $warning-text, 12 px semibold). Pertahankan info "Tidak ada uang yang berpindah. Kejadian ini masuk ke riwayat." di atasnya. Jangan ubah elemen lain.
```

### P1-13 Android lebih dulu: sembunyikan Apple, ubah label biometrik (OI-51)
Target: `Masuk (/login)` (VKph5), `Masuk - Error` (RuMoh), `Masuk - Loading` (HpYhk), `Daftar (/signup)` (RbM3v), `Pengaturan (/settings)`.
```
Pada empat frame Masuk dan Daftar: sembunyikan (enabled:false) tombol "Apple" sehingga tombol "Google" mengisi lebar penuh 350 px dengan tinggi sama. Ubah teks "Masuk dengan Face ID" menjadi "Masuk dengan Biometrik" dan ikon scan-face menjadi lucide "fingerprint". Pada "Pengaturan (/settings)" ubah judul toggle "Masuk dengan Face ID" menjadi "Masuk dengan Biometrik" dan teks bantu menjadi "Buka sesi tersimpan dengan sidik jari atau wajah.". Jangan hapus elemen Apple dari file; cukup nonaktifkan agar mudah diaktifkan saat rilis iOS.
```

### P1-14 Edit/hapus catatan hutang dan batalkan pembayaran (OI-30, BR-09)
Target: salinan `Tambah Hutang/Piutang - Terisi` (E8dhpO) dan `Detail Piutang (/debt-detail)` (i5MAz). Fase 5.
```
1. "Edit Hutang/Piutang" (sheet): salin "Tambah Hutang/Piutang - Terisi", judul "Ubah Catatan", nominal "Rp 3.000.000" dengan teks bantu "Minimal Rp 1.000.000 karena sudah terbayar", tombol "Simpan Perubahan".
2. "Dialog Hapus Catatan": dialog kaca, judul "Hapus catatan?", teks "Catatan Budi Santoso Rp 3.000.000 akan dihapus.", tombol "Hapus" ($expense) dan "Batal". Varian "Hapus Catatan - Tidak Bisa": teks "Catatan yang sudah ada pembayaran atau saling hapus tidak dapat dihapus.", satu tombol "Mengerti".
3. Pada baris "Riwayat Pembayaran" di Detail Piutang tambahkan aksi ikon titik tiga "Batalkan" per baris, lalu buat "Dialog Batalkan Pembayaran": judul "Batalkan pembayaran?", teks "Pembayaran Rp 500.000 (25 Okt 2026) dibatalkan, sisa kembali menjadi Rp 2.500.000, dan transaksi yang tercatat ikut dihapus.", tombol "Batalkan Pembayaran" ($expense) dan "Kembali".
```

### P1-15 Form investasi lanjutan (OI-30, OI-23)
Target: `Detail Aset (/investment-detail)` (sFWee) dan `Tambah Investasi (/add-investment)` (efIGG). Fase 6.
```
1. "Tambah Pembelian" (sheet dari tombol di Detail Aset): header "Tambah Pembelian", nama aset "Emas Digital", field "Jumlah (gram)" 0, "Harga per gram" Rp 0, "Total" Rp 0 (otomatis), "Tanggal beli", Dompet "Saldo Utama", toggle "Catat sebagai transfer dari saldo", PrimaryButton "Simpan".
2. "Perbarui Nilai" (sheet): field "Nilai sekarang" nominal 36 px, "Tanggal", teks bantu "Harga hari ini sekitar Rp 1.522.000 per gram", tombol "Simpan Nilai".
3. "Menu Aset" (action sheet dari ikon menu di Detail Aset): "Ubah Aset", "Hapus Aset", "Batal". "Ubah Aset" (sheet): nama, platform (pemilih), jenis, tombol "Simpan Perubahan".
4. "Pemilih Platform" (sheet): daftar Bibit, Tokopedia Emas, Pegadaian, Pluang, Lainnya dengan centang pada pilihan aktif.
5. "Dialog Hapus Aset": judul "Hapus aset?", teks "Aset Emas Digital beserta riwayat pembelian dihapus dan saldo dompet dipulihkan Rp 4.640.000.", tombol "Hapus" ($expense) dan "Batal".
```

### P1-16 Halaman Syarat & Ketentuan dan Kebijakan Privasi (OI-30, X-07)
Target: tautan "Syarat & Ketentuan" dan "Kebijakan Privasi" di `Daftar (/signup)`. Fase 8 (teks final X-07).
```
Buat dua frame 390 x 844 tanpa nav dan tanpa Tanya AI: "Syarat & Ketentuan" dan "Kebijakan Privasi". Isi: tombol kembali, judul 28 px bold, GlassCard berisi judul bagian 16 px bold dan paragraf 14 px. Kebijakan Privasi memuat bagian: "Data yang kami kumpulkan", "Pemrosesan oleh Google AI", "Penyimpanan dan penghapusan", "Hak kamu". Syarat & Ketentuan memuat: "Penggunaan aplikasi", "Akun dan keamanan", "Batasan tanggung jawab". Isi paragraf berupa teks contoh "Teks final menyusul"; teks final dibuat di X-07.
```

### P1-17 Dialog Persetujuan Pemrosesan AI (07 bagian 10.1, OI-52)
Target: salinan `Scan Nota (/scan)` (i3J3oQ). Fase 4. Menurut 07, persetujuan eksplisit diperlukan sebelum fitur AI aktif; 06 belum punya kolom untuk mencatatnya (lihat 14 bagian 6).
```
Buat "Persetujuan Pemrosesan AI" sebagai dialog kaca di atas salinan Scan Nota: ikon lucide "sparkles" dalam lingkaran $income-soft, judul "Izinkan pemrosesan AI?", teks "Untuk membaca nota dan menjawab pertanyaan, teks nota dan ringkasan datamu dikirim ke Google AI. Foto dihapus setelah dibaca kecuali kamu mengaktifkan Simpan foto nota.", tautan teks "Baca Kebijakan Privasi", tombol "Setuju" (PrimaryButton) dan "Nanti". Buat varian di atas salinan "Asisten RekapFin (/chat)".
```

## P2: Token, kontras, dan halaman dokumentasi

### P2-1 Token baru dan kontras (OI-18, OI-27 Diputuskan)
Status: SUDAH DITERAPKAN di file (14 bagian 2.2). Variabel yang ada sekarang: accent-action #047857, warning-text #B45309, status-ok #047857 / status-warn #B45309 / status-danger #B91C1C beserta -fill (#10B981, #D97706, #DC2626), text-muted #557566, fs-micro 11, serta token layout. Nama `status-good/warn/bad` pada rencana awal diganti menjadi `status-ok/warn/danger` (OI-55). PrimaryButton (bfHZv) dan FilterChip/Aktif (mTBxe) memakai $accent-action; ikon dan label NavItem/Aktif juga. Tidak ada prompt yang perlu ditempel.

### P2-1b Varian TransactionItem (dibutuhkan F02)
Status: SUDAH DITERAPKAN di file: TransactionItem/Pengeluaran, /Pemasukan, /Transfer, /Dengan label, dan /Chevron. Tidak ada prompt yang perlu ditempel.

### P2-2 Halaman Design Tokens dan Komponen (OI-19)
Status: SEBAGIAN DITERAPKAN. Halaman Design Tokens sudah memuat token baru, status anggaran, radius 24/16/999/34, gradien hero 047857 ke 078761, dan aturan layout dengan zona Tanya AI x 302-390, y 672-744; halaman Komponen sudah memuat varian tombol, nav, dan TransactionItem. Sisa ada di P2-2b.

### P2-2b Selaraskan aturan layout di halaman Design Tokens (OI-55)
Target: `Design Tokens` (A5xqS), bagian "Aturan layout" (a3XQE).
```
Di bagian "Aturan layout" ganti kalimat "Frame referensi tidak wajib 390 × 844." menjadi "Frame 390 × 844 adalah viewport; konten yang lebih tinggi digulir dengan padding bawah 160." Tambahkan baris: "BottomNavBar dan tombol Tanya AI fixed, tidak ikut gulir." "Jarak minimum antar section 16, antar kartu 12." "Chip filter berupa baris yang bisa digeser; chip terakhir boleh terpotong." Jangan ubah bagian lain.
```

### P2-3 Perbarui Aplikasi dan state tanpa jaringan (OI-39, didesain belakangan)
```
Buat frame "Perbarui Aplikasi (/update-required)" 390 x 844 dengan Latar RekapFin, tanpa nav dan tanpa Tanya AI: ikon lucide "download" dalam lingkaran 64 px ($income-soft), judul "Perbarui aplikasi" 28 px bold, teks "Versi aplikasimu sudah tidak didukung. Unduh versi terbaru lalu pasang untuk melanjutkan." 14 px, PrimaryButton "Unduh versi terbaru".
Buat komponen "State Tanpa Jaringan": kartu kaca dengan ikon "wifi-off" ($warning), judul "Tidak ada koneksi", teks "Periksa jaringan lalu coba lagi." dan tombol kaca "Coba lagi". Buat dua contoh pemakaian: variabel layar penuh di tengah halaman kosong, dan banner di atas konten pada salinan "Transaksi (/transactions)". Pada salinan "Tambah Transaksi - Terisi" buat varian tombol "Simpan Transaksi" nonaktif (opasitas 0.5) dengan banner yang sama.
```

### P2-3b Pengingat versi baru tersedia (OI-53)
Dikerjakan bersama P2-3 (D-13).
```
Buat "Versi Baru Tersedia" sebagai kartu kaca non-memblokir di atas salinan "Beranda (/home)": ikon lucide "download", judul "Versi baru tersedia", teks "Unduh versi terbaru untuk mendapat perbaikan.", tombol "Unduh" (PrimaryButton kecil) dan "Nanti" (tombol teks). Berbeda dari "Perbarui Aplikasi" yang memblokir; tidak menutupi nav dan Tanya AI.
```

### P2-4 Batas Harian Tercapai dan Akun Sedang Dihapus (OI-48, keputusan audit 9)
```
Buat dialog "Batas Harian Tercapai - Scan" di atas salinan "Scan Nota (/scan)": dialog kaca di tengah di atas overlay transparan, ikon "gauge", judul "Batas harian tercapai", teks "Kamu sudah memakai 20 scan hari ini. Isi nota secara manual atau coba lagi besok.", tombol "Ketik Manual" (PrimaryButton) dan "Tutup". Buat varian "Batas Harian Tercapai - Pembacaan Ulang" dengan teks "Pembacaan ulang hari ini sudah habis (10 per hari). Isi nota secara manual." dan varian "Batas Harian Tercapai - Chat" di atas salinan "Asisten RekapFin (/chat)" dengan teks "Kamu sudah memakai 50 pesan hari ini. Coba lagi besok." dan hanya tombol "Tutup".
Buat frame "Akun Sedang Dihapus" 390 x 844 tanpa nav: ikon "loader" dalam lingkaran, judul "Akun sedang dihapus" 28 px bold, teks "Penghapusan belum selesai. Coba lagi untuk melanjutkan.", PrimaryButton "Coba lagi".
```

## P3: Kosmetik dan opsional

### P3-1 Satu karakter minus (OI-16)
```
Ganti semua "−Rp" (tanda minus U+2212) di layar Saldo Bersih (NziAs, uHCWl, KDwid, Ie7pG, OQfXg) dan "-Rp" di layar lain menjadi satu karakter yang sama: pakai tanda minus "−" (U+2212) di semua tampilan uang negatif.
```

### P3-2 Hubungan navigasi (OI-02), bila pen.dev mendukung interaksi
```
Hubungkan: segmen "Investasi" di Scan Nota ke "Scan Investasi (/scan-investment)"; tombol "Lihat & Saling Hapus" di Detail Piutang dan Detail Hutang ke "Saldo Bersih" (/debt-net); Transfer dengan chip Investasi ke "Tambah Investasi (/add-investment)"; Aksi Cepat Transfer ke "Transfer (/transfer)"; kartu Total Saldo ke "Dompet (/wallets)"; baris menu Profil ke Dompet dan Pengaturan; "Lupa kata sandi?" ke "Lupa Kata Sandi (/forgot-password)"; tombol "Atur Anggaran Baru" ke "Atur Anggaran (/budget-edit)".
Catatan: file ini tidak memuat properti interaksi saat ini; bila tidak didukung, abaikan langkah ini. Peta navigasi ada di docs/04-alur-pengguna.md.
```

## Ringkasan jumlah perubahan
| Prioritas | Butir | Layar baru | Layar berubah |
|---|---|---|---|
| P0 | 11 | Onboarding (2), Lupa Kata Sandi (3), Dompet + Form (3) + Arsip Ditolak/Konfirmasi (3), Transfer (4), Detail Transaksi + Edit + Dialog (6), Atur Anggaran (2), Pengaturan (2), Pemilih Kontak, Dialog Nama Ganda, Hapus Akun (3) | 3 (Tambah Transaksi) |
| P1 | 17 | Varian Peringatan Saldo (2), Edit Hutang + 2 dialog + Dialog Batalkan Pembayaran, form investasi lanjutan (5), Syarat dan Kebijakan (2), Persetujuan AI (2) | Anggaran, Beranda, Transaksi, Analitik, Profil, Chat, 5 layar hutang, 5 detail/sheet pembayaran, 4 form, 3 scan, 4 Masuk/Daftar |
| P2 | 7 | Perbarui Aplikasi, Versi Baru Tersedia, komponen State Tanpa Jaringan (+3 contoh), Batas Harian Tercapai (3), Akun Sedang Dihapus | Variabel, komponen (termasuk 3 varian TransactionItem), 2 halaman dokumentasi |
| P3 | 2 | - | Saldo Bersih (5), opsional navigasi |
Status pemeriksaan terhadap file ada di [14-status-desain.md](14-status-desain.md). P2-1 dan P2-1b sudah diterapkan di file, P2-2 sebagian (sisa: P2-2b). P2-3, P2-3b, dan P2-4 didesain belakangan (OI-39); sebelum itu aplikasi memakai placeholder fungsional. Item D yang memuat tiap prompt ada di 13 bagian 5.1.
