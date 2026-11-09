# 08. Design System

> Ringkasan: spesifikasi visual RekapFin yang dibaca dari variabel dan komponen di RekapFin.pen: iOS glassmorphism terang, satu warna emerald, Plus Jakarta Sans, ikon Lucide 1,75 px. Berisi token warna, tipografi, radius, spasi, efek kaca, komponen reusable beserta state, dan aturan layout. Sumber kebenaran nilai visual adalah RekapFin.pen terkini (variabel dan komponen), bukan teks halaman Design Tokens di file itu yang bisa tertinggal (OI-19, OI-55).

Status: Diselaraskan dengan RekapFin.pen terkini (OI-55). Label [DESAIN] nilai terbaca di file, [DIPUTUSKAN] keputusan pemilik produk, [ASUMSI] usulan nilai, [TERTUNDA] belum didesain dan tercatat di OPEN_ISSUES bagian H. Agen coding tidak boleh mengubah nilai tanpa izin. Berkas .pen tidak ada di repo: lihat catatan lokasi di [INDEX.md](INDEX.md).

Ringkasan: semua keputusan token sebelumnya sudah diterapkan di .pen: `accent-action` #047857 untuk isi tombol dan chip aktif (OI-18, OI-27); `text-muted` #557566 (4,5:1); `fs-micro` 11 dengan pengecualian 11 px termasuk label Aksi Cepat (OI-03); `warning-text`; tiga status anggaran `status-ok/warn/danger` beserta `-fill` (OI-11). Token layout baru: `frame-width/height`, `content-top`, `safe-bottom`, `tanya-zone-x/y`, `fs-page-title`, `glass-blur`, `nav-blur`. Tabel di bawah adalah nilai variabel .pen saat ini (62 variabel).

## 1. Token warna [DESAIN]
| Token | Nilai | Pemakaian |
|---|---|---|
| bg-base | #F0FDF4 | latar layar |
| surface | #FFFFFF | permukaan putih |
| text-primary | #0B2E22 | teks utama |
| text-secondary | #4F6B5E | teks sekunder |
| text-muted | #557566 | teks redup, label bagian (4,87:1 di bg-base, 5,09:1 di putih) |
| text-on-accent | #FFFFFF | teks di atas aksen |
| text-on-accent-muted | #FFFFFFCC | teks sekunder di atas aksen |
| accent | #10B981 | aksen non-teks (ring, bar, blob, ikon dekoratif); bukan isi tombol |
| accent-action | #047857 | isi PrimaryButton dan FilterChip aktif, ikon dan label NavItem aktif, teks aksen (putih/#047857 = 5,48:1) |
| income | #059669 | pemasukan, untung |
| expense | #DC2626 | pengeluaran, rugi, error |
| warning | #D97706 | amber: isi ikon, bar, latar; bukan teks kecil |
| warning-text | #B45309 | teks amber, "Periksa kembali" (5,02:1 di putih) |
| income-soft | #0596691A | latar ikon pemasukan |
| expense-soft | #DC26261A | latar ikon pengeluaran |
| warning-soft | #D977061A | latar peringatan |
| glass-fill | #FFFFFF8C | isi kartu kaca (sekitar 55%) |
| glass-border | #FFFFFFCC | garis tepi kaca |
| glass-highlight | #FFFFFF | sorotan dalam atas |
| glass-shadow | #0F172A14 | bayangan kaca |
| glass-nav-fill | #FFFFFFA6 | isi bottom nav (sekitar 65%) |
| nav-active-fill | #FFFFFF | item nav aktif |
| hero-start | #047857 | awal gradien hero (solid) |
| hero-end | #078761 | akhir gradien hero (solid; putih di atasnya 4,52:1) |
| hero-border | #FFFFFF80 | tepi hero |
| hero-shadow | #10B98140 | bayangan hero/tombol/chip aktif |
| button-highlight | #FFFFFF59 | sorotan dalam tombol |
| blob-emerald-light | #6EE7B7 | blob latar |
| blob-emerald-deep | #34D399 | blob latar |
| blob-mint | #A7F3D0 | blob latar |
| status-ok / status-warn / status-danger | #047857 / #B45309 / #B91C1C | teks dan ikon status anggaran (OI-11) |
| status-ok-fill / status-warn-fill / status-danger-fill | #10B981 / #D97706 / #DC2626 | isi ring dan bar status anggaran |
| avatar-end | #10B981 | akhir gradien avatar inisial |
Tema: hanya terang; tidak ada nilai tema gelap [DESAIN].
Warna lain yang muncul di layar tetapi bukan token: #C9D8D0 (11 pemakaian), #F0FDF480 dan alfa lain pada garis/bar [DESAIN]; agen coding menanyakan sebelum memakai.

### Riwayat keputusan token (sudah diterapkan di .pen)
| Token | Sebelum | Sekarang di .pen | Keputusan |
|---|---|---|---|
| accent-action | belum ada | #047857 | OI-18, OI-27 |
| text-muted | #86A394 (2,61:1) | #557566 | OI-18 |
| warning-text | belum ada | #B45309 | OI-18 |
| fs-micro | 10 | 11 | OI-03 |
| status-ok / status-warn / status-danger (+ `-fill`) | belum ada (rencana nama `status-good/warn/bad`) | ada, dengan nama `status-ok/warn/danger` | OI-11 |
| glass-shadow | #064E3B14 | #0F172A14 | OI-55 |
| hero-start / hero-end | #059669D9 / #34D399B3 | #047857 / #078761 | OI-55 |
| radius-button / radius-chip | 26 / 18 | 16 / 999 (pil) | OI-55 |
| fs-display | 32 | 36 | OI-55 |

### Kontras terukur (tanpa transparansi kaca)
| Pasangan | Rasio | Catatan |
|---|---|---|
| putih / #10B981 (desain lama) | 2,54 | gagal |
| putih / #059669 (pilihan awal) | 3,77 | tidak dipakai untuk isi tombol; tetap warna `income` |
| putih / #078761 (akhir gradien hero) | 4,52 | lolos |
| putih / #047857 (isi tombol dan chip aktif) | 5,48 | dipilih, OI-27 Diputuskan |
| text-muted lama / bg-base | 2,61 | gagal (sudah diganti) |
| text-muted #557566 / bg-base dan putih | 4,87 dan 5,09 | lolos, nilai sekarang |
| #D97706 / putih | 3,19 | gagal untuk teks kecil |
| warning-text #B45309 / putih | 5,02 | lolos, untuk teks amber |
| status-danger #B91C1C / putih | 6,47 | lolos |
| expense #DC2626 / putih | 4,83 | lolos |
| text-secondary #4F6B5E / bg-base | 5,58 | lolos |
| text-primary #0B2E22 / bg-base | 14,05 | lolos |
Rasio untuk teks di atas kaca bergantung pada blob di belakangnya; verifikasi visual di perangkat wajib (fase 0 dan 8).

## 2. Tipografi [DESAIN]
Keluarga: Plus Jakarta Sans (token `font-sans`). Bobot terpakai 500, 600, 700, 800 (teks tombol primer dan chip 600).
| Token | Ukuran | Pemakaian khas |
|---|---|---|
| fs-display | 36 | angka saldo hero (ExtraBold 800) |
| fs-page-title | 28 | judul halaman |
| fs-title | 20 | judul bagian, kartu |
| fs-subtitle | 16 | subjudul, tombol primer (Bold 700) |
| fs-body | 14 | isi, label chip, nama baris (SemiBold 600 / Medium 500) |
| fs-caption | 12 | keterangan, meta (Medium 500, SemiBold 600) |
| fs-micro | 11 | label nav, Tanya AI, Aksi Cepat (pengecualian OI-03) |
Ukuran yang dipakai tetapi tidak punya token [DESAIN]: 32 dan 40 (nominal input di sheet; belum diverifikasi ulang terhadap .pen terkini). Standar minimum 12 px. Pengecualian 11 px yang diputuskan (OI-03): label BottomNavBar, "Tanya AI", dan label Aksi Cepat (Tambah Pemasukan, Tambah Pengeluaran, Transfer, Scan Nota). Teks lain tidak boleh di bawah 12 px.
Distribusi pemakaian pada layar (diukur pada versi .pen lama, belum diukur ulang): 12 px (527 teks), 14 px (486), 16 px (142), 11 px (134), 20 px (33), 28 px (25), 36 px (16), 32 px (9), 40 px (2).
Letter-spacing: label bagian 12 px bobot 700 dengan spasi 1 px pada halaman dokumentasi.

## 3. Radius [DESAIN]
| Token | Nilai | Pemakaian |
|---|---|---|
| radius-card | 24 | kartu kaca, hero |
| radius-button | 16 | PrimaryButton (semua varian) |
| radius-chip | 999 | FilterChip (bentuk pil) |
| radius-nav | 34 | BottomNavBar |
Nilai lain yang dipakai tanpa token: 28 (NavItem), 22 (tombol Keluar, bubble ikon), 20, 16, 12, 10, 4, 2, 1, dan 50% (lingkaran).

## 4. Spasi [DESAIN]
| Token | Nilai |
|---|---|
| space-1 | 8 |
| space-2 | 16 |
| space-3 | 24 |
| space-4 | 32 |
| screen-padding | 20 |
| frame-width / frame-height | 390 / 844 |
| content-top | 54 |
| safe-bottom | 24 |
| tanya-zone-x / tanya-zone-y | 302 / 672 (awal zona bebas teks/nominal Tanya AI) |
Grid 8pt. Nilai lain yang sering muncul: gap 4, 6, 12, 10, 14; padding 12, 10, 14, 6, 3. Padding konten layar: atas 54 (`content-top`), kanan/kiri 20, bawah 24 (`safe-bottom`); padding bawah konten yang bisa digulir 160 (bagian 8).

## 5. Efek kaca [DESAIN]
Token blur: `glass-blur` 30 (kartu), `nav-blur` 40 (bottom nav); chip 20. Token `button-highlight` (#FFFFFF59) masih ada tetapi tidak dipakai di PrimaryButton saat ini.
| Elemen | Isi | Tepi | Blur latar | Bayangan |
|---|---|---|---|---|
| GlassCard | glass-fill | 1 px glass-border (dalam) | 30 | luar 0/8, blur 32, glass-shadow; dalam 0/1 glass-highlight |
| GlassCard/Hero | gradien linear rotasi 225 hero-start (#047857) ke hero-end (#078761) | 1 px hero-border (dalam) | 30 | luar 0/8, blur 32, hero-shadow; dalam 0/1 glass-highlight |
| FilterChip nonaktif | glass-fill | 1 px glass-border | 20 | dalam 0/1 glass-highlight |
| FilterChip aktif | accent-action (solid) | tanpa | tanpa | luar 0/4, blur 12, hero-shadow |
| PrimaryButton | accent-action (solid) | tanpa | tanpa | luar 0/8, blur 20, #10B98133 |
| PrimaryButton/Sekunder | #FFFFFF8C | 1 px #FFFFFFCC (dalam) | 20 | tanpa |
| BottomNavBar | glass-nav-fill | 1 px glass-border | 40 | luar 0/8, blur 32, glass-shadow; dalam 0/1 glass-highlight |
| NavItem aktif | nav-active-fill | tanpa | tanpa | luar 0/2, blur 8, glass-shadow |
Catatan Flutter [ASUMSI]: blur latar dengan `BackdropFilter` (ImageFilter.blur) dan `ClipRRect`; nilai blur pen.dev tidak persis sama dengan sigma Flutter dan perlu dibandingkan visual (ekspor HTML menunjukkan blur(10/15/20 px) untuk nilai 20/30/40). Batasi jumlah BackdropFilter per layar demi performa.
Latar layar (komponen "Latar RekapFin" 390 x 844): warna bg-base dengan tiga blob elips terburam: "Blob Emerald Terang" (#6EE7B7, 340 px, opasitas 0,5, posisi -130,-110), "Blob Emerald Pekat" (#34D399, 300 px, 0,35, posisi 190,644), "Blob Mint" (#A7F3D0, 220 px, 0,4, posisi -90,312) [DESAIN, dari ekspor].

## 6. Ikon [DESAIN]
Pustaka Lucide, garis 1,75 px. Ukuran: 22 (nav), 20 (tombol, bubble), 18, 16, 24 (Tanya AI). Ikon nav: house (Beranda), arrow-left-right (Transaksi), piggy-bank (Anggaran), chart-pie (Analitik), user (Profil). Tombol: plus. Hero: trending-up. Bubble transaksi contoh: shopping-bag.

## 7. Komponen reusable dan state [DESAIN]
| Komponen | Spesifikasi | State |
|---|---|---|
| GlassCard | lebar 350, padding 16, radius 24, vertikal; slot Konten (gap 8); judul 16/700 text-primary, isi 14/500 text-secondary, tinggi baris 1,4 | satu; untuk varian lain isi slot |
| GlassCard/Hero | lebar 350, padding 24, radius 24; label 14/600 text-on-accent-muted, nilai 32/800 putih, keterangan 12/500 dengan ikon trending-up 16 | satu |
| FilterChip/Aktif | tinggi 36, padding horizontal 16, radius 999 (pil), isi accent-action, label 12/600 putih (`fs-caption`) | aktif |
| FilterChip/Tidak aktif | tinggi 36, padding horizontal 16, radius 999, kaca (#FFFFFF8C, blur 20), label text-secondary | nonaktif; baris chip bisa digulir (bagian 8) |
| PrimaryButton | 350 x 56, radius 16, isi accent-action, ikon 20 + label 16/600 putih (`fs-subtitle`), gap 8, padding horizontal 24 | default; varian komponen: Disabled (isi #04785766, ikon dan label #FFFFFFCC), Pressed (isi #065F46), Loading (ring putih 20 tanpa label), Sekunder (kaca, tepi #FFFFFFCC, ikon dan label accent-action) |
| TransactionItem | lebar 318, padding vertikal 8, gap 12; bubble 44 lingkaran (expense-soft, ikon 20 expense); judul 14/600; keterangan 12/500 text-secondary; nominal 14/700 expense | contoh pengeluaran; pemasukan memakai income/income-soft (di layar, "+Rp 8.500.000") [ASUMSI warna income] |
| NavItem | 80 x 56, radius 28, ikon 22 + label 11/600 | aktif (nav-active-fill, ikon dan label accent-action) atau nonaktif (ikon dan label text-muted) |
| BottomNavBar | 350 x 68, radius 34, padding 6, lima NavItem | komponen terpisah per tab (Beranda, Transaksi, Anggaran, Analitik, Profil aktif) dan "Tanpa tab aktif" untuk /debts dan /investments |
| TransactionItem | varian Pengeluaran, Pemasukan, Transfer, Dengan label, Chevron | lihat atas untuk dimensi |

Pola yang berulang di layar tetapi belum menjadi komponen (usulan komponen, OI Usulan 2): segmented control (Pengeluaran/Pemasukan, Hutang Saya/Piutang, Nota/Investasi, 1B/3B/6B), header sheet dengan tombol tutup, search bar, kartu KPI (Pemasukan/Pengeluaran), ring progres, bar progres, badge status (Lunas, Terlambat, Jatuh tempo, "Ada hutang timbal balik", "Disarankan AI", "Periksa kembali"), avatar inisial, toggle, keypad angka (1-9, 0, 000, hapus), kartu proses (checklist), baris form, baris menu dengan chevron, tombol sekunder (Edit, Hapus, Scan Nota Lain; "Kirim Pengingat" ditunda), tombol Tanya AI.

State warna semantik [DESAIN]: pemasukan/untung = income (#059669); pengeluaran/rugi/error = expense (#DC2626); peringatan/"Periksa kembali" = warning (#D97706); aksi = accent (keputusan: accent-action).
Status anggaran [DIPUTUSKAN, OI-11]: persen terpakai kurang dari 70% = hijau (income), 70% sampai 90% = amber (warning), lebih dari 90% = merah (expense), berlaku untuk ring total dan bar kategori. Teks bantu: 90% sampai 100% "Hampir melebihi batas!", di atas 100% "Melebihi batas" [ASUMSI].
Status anggaran memakai `status-ok/warn/danger` untuk teks dan ikon, `-fill` untuk ring dan bar.
Amber "Periksa kembali" pada hasil scan: field berkeyakinan di bawah 85% atau total tidak cocok rincian (OI-24).
Status loading: PrimaryButton/Loading (ring tanpa label). Status disabled dan pressed tombol: sudah ada sebagai varian. Status error: ikon dan teks merah di bawah field (Masuk - Error). Status kosong: judul + penjelasan + tombol (Investasi - Kosong, Hutang & Piutang - Kosong Pengguna Baru). Fokus input dan skeleton belum didesain [TERTUNDA, OI-59].

## 8. Aturan layout [DIPUTUSKAN, OI-55]
- Frame layar 390 x 844 (`frame-width`, `frame-height`) adalah viewport. Padding konten kiri/kanan 20, atas 54, bawah 24; lebar konten 350.
- Konten yang lebih tinggi dari viewport dapat digulir (scrollable) dengan padding bawah 160 px supaya item terakhir tidak tertutup BottomNavBar dan Tanya AI. Di .pen, layar seperti ini digambar lebih tinggi dari 844 (contoh Beranda 390 x 1100); di aplikasi tinggi lebih dari 844 berarti gulir, bukan layar lebih panjang.
- BottomNavBar (350 x 68, x=20, y=752, jarak 24 dari bawah) dan tombol Tanya AI bersifat fixed: tidak ikut menggulir.
- Tombol Tanya AI: wadah 130 x 52 di (x=240, y=684), yaitu x 240..370 dan y 684..736 (label pil 70 x 24 di kiri, tombol bulat 52 x 52 di x=78 dalam wadah). Zona bebas teks/nominal: x 302..390, y 672..744 (`tanya-zone-x`=302, `tanya-zone-y`=672); teks dan nominal tidak boleh ditaruh di zona itu (alasan lebar 208 di Profil; keputusan OI-04: dipertahankan, teks versi dirata-tengahkan terhadap tombol Keluar, OI-33).
- Jarak minimum antar section 16 dan antar kartu 12.
- Chip filter (Semua, Pengeluaran, dan sejenisnya) berupa baris yang bisa digeser horizontal (scrollable row); chip terakhir boleh terpotong di tepi kanan sebagai petunjuk bahwa masih ada isi.
- Layar baru mengikuti aturan yang sama: frame 390 x 844, padding 20, Latar RekapFin, GlassCard, PrimaryButton 350 x 56; layar bernav menghormati zona bebas Tanya AI.
- Header halaman: judul 28/700 (`fs-page-title`) atau 20 untuk sheet; tombol kembali di kiri untuk layar turunan.
- Sheet: judul 20/700, tombol tutup, isi vertikal, tombol primer 350 x 56 di bawah.
- Layar tanpa nav: Masuk, Daftar, Scan, Hasil Scan, Chat, Edit Profil, Detail, Saldo Bersih, Scan Investasi, Detail Aset.
- Kartu bersarang: GlassCard dengan padding 16; hindari kartu di dalam kartu kecuali di desain.
- Teks uang selalu rata kanan di baris daftar; nominal tebal 700.

## 9. Pemetaan ke Flutter [ASUMSI]
- Token menjadi `ThemeExtension` (`AppColors`, `AppSpacing`, `AppRadius`, `AppTextStyles`); tidak ada literal warna di widget fitur.
- Widget inti di `core/design_system/` bernama sama dengan komponen (GlassCard, GlassHeroCard, AppFilterChip, PrimaryButton, TransactionItem, AppBottomNavBar, TanyaAiFab).
- Perubahan desain lewat izin pemilik; perbedaan hasil render dengan desain dilaporkan sebagai isu, bukan "diperbaiki" diam-diam.
