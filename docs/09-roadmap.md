# 09. Roadmap

> Ringkasan: sembilan fase (0 sampai 8). MVP adalah fase 0 sampai 3; fase 4 sampai 7 adalah fitur lanjutan; fase 8 adalah pengerasan dan rilis. Tiap fase punya isi, dependensi, definisi selesai (DoD), dan estimasi kompleksitas relatif S/M/L (bukan jam). Setelah keputusan OI-07 sampai OI-25, dompet, onboarding, transfer, detail/edit transaksi, atur anggaran, lupa kata sandi, dan pengaturan masuk MVP. Urutan fase 4 sampai 7 tetap [ASUMSI].

Status: Diperbarui setelah keputusan OI-01 sampai OI-57 dan audit arsitektur. Urutan modul SQL dan Flutter untuk fase 0 sampai 3 beserta definisi selesai tiap modul ada di [12-build-plan.md](12-build-plan.md). Gerbang keputusan merujuk [OPEN_ISSUES.md](OPEN_ISSUES.md); kolom di bawah hanya memuat butir yang belum dijawab (OPEN_ISSUES bagian H) atau tindak lanjut terjadwal (bagian G).

## Ringkasan
| Fase | Nama | Kompleksitas | Bergantung pada | Gerbang keputusan yang tersisa |
|---|---|---|---|---|
| 0 | Fondasi dan platform data | L | - | tidak ada. Tindak lanjut: pemilik memeriksa PITR di dashboard; cadangan manual berkala dijadwalkan |
| 1 | Autentikasi, profil, onboarding, dompet dasar | L | 0 | tidak ada. Tindak lanjut: uji hapus akun di proyek dev (OI-42) |
| 2 | Transaksi dan transfer | L | 1 | tidak ada |
| 3 | Anggaran dan analitik | M | 2 | tidak ada |
| 4 | Scan nota | L | 2 | tidak ada yang memblokir; kalibrasi ambang 85% dengan sampel nyata |
| 5 | Hutang-piutang dan saling hapus | L | 2 | tidak ada |
| 6 | Investasi dan scan investasi | L | 2, 4 (pipeline OCR) | tidak ada |
| 7 | Asisten AI | L | 2, 3, 5, 6 (alat baca), 4 (Edge Function) | Gerbang: pilih model chat (OI-40) |
| 8 | Pengerasan dan rilis (Android) | M | 1 sampai 7 | Tindak lanjut: rilis iOS dan Play Store (bila diinginkan) pasca-rilis Android |

Fase 5 dapat berjalan paralel dengan fase 4 bila ada dua pengembang karena tidak berbagi pipeline OCR. Layar yang ditunda (Notifikasi, Riwayat Saling Hapus) tidak ada di fase mana pun dan dijadwalkan setelah rilis pertama.

## Fase 0: Fondasi dan platform data (L)
- Isi: proyek Flutter dan struktur folder (07), tema dan token (08, termasuk `accent-action`, text-muted baru, status anggaran), komponen inti (GlassCard, Hero, FilterChip, PrimaryButton, TransactionItem, BottomNavBar, Tanya AI, Latar), router dasar dengan ShellRoute, `Rupiah` dan format (BR-01, BR-02), proyek Supabase lokal, staging, dan produksi terpisah dengan kunci masing-masing, kerangka migrasi maju-saja (expand-contract), pola RPC `SECURITY DEFINER` berversi dengan pembungkus `client_request_id` di klien dan `request_log` di server, tabel `app_config` dan layar /update-required (placeholder fungsional, desain P2), lapisan error `NetworkFailure` (online-only), kerangka CI (termasuk audit hak dan pemindaian service role), pemicu pendaftaran untuk data bawaan, lint.
- Dependensi: tidak ada.
- DoD:
  1. `flutter analyze` bersih dan `flutter test` hijau di CI.
  2. Katalog komponen (halaman uji/golden) cocok dengan desain; semua token dipakai lewat tema, tanpa literal warna.
  3. Tes format rupiah lulus (05 C.6).
  4. Supabase lokal naik dengan migrasi kosong; skrip tes RLS berjalan.
  5. CLAUDE.md terisi dengan versi paket yang dikunci.
  6. Kontras token terverifikasi di perangkat (OI-18, OI-27): isi tombol dan chip aktif #047857, text-muted minimal 4,5:1.
  7. Pola tulis terbukti pada fixture pgTAP (tabel dan RPC contoh hanya ada di berkas tes, bukan di migrasi): DML dicabut dari `authenticated`, `EXECUTE` dicabut dari `anon`/`PUBLIC`, `search_path` tetap, idempotensi `client_request_id` (T-IDM-01 dan T-SEC lulus).
  8. Tiga lingkungan terpisah dengan kunci sendiri; `seed.sql` tidak ikut ke produksi; `--dart-define` hanya URL dan anon key (pemindaian rahasia pada paket lulus).
  9. Prosedur rotasi rahasia terdokumentasi; hasil pemeriksaan PITR oleh pemilik dicatat; cadangan manual berkala berjalan dan satu pemulihan ke staging berhasil (OI-49).
  10. Perilaku tanpa jaringan (07 bagian 12) terwujud di komponen bersama: pesan, tombol simpan nonaktif, retry aman.

## Fase 1: Autentikasi, profil, onboarding, dompet dasar (L)
- Isi: Masuk (default/error/loading), Daftar, Google (Apple menyusul bersama rilis iOS), Lupa Kata Sandi, Onboarding saldo awal (boleh dilewati), Profil, Edit Profil, Pengaturan (biometrik opsional), Keluar, Hapus Akun, layar Dompet dan form dompet; tabel `profiles`, `wallets`, `categories` (bawaan) dengan RLS; trigger buat profil (dengan `timezone` bawaan Asia/Jakarta), dompet "Saldo Utama", dan kategori bawaan; RPC dompet (`complete_onboarding_v1`, `create_wallet_v1`, `update_wallet_v1`; `archive_wallet_v1` menyusul di fase 2 karena butuh saldo dari transaksi); hapus akun lengkap (`delete-account` dengan langkah Storage, token Apple, `purge_user_data_v1`, hapus pengguna auth) dan pembersihan sisi klien.
- Dependensi: fase 0.
- DoD: AUT-01 sampai AUT-07, PRF-01 sampai PRF-04, WAL-01 sampai WAL-03 lulus kriteria; tes RLS profil dan dompet lulus; keluar menghapus sesi; Hapus Akun menghapus semua data (tes); Face ID bawaan mati dan hanya membuka sesi tersimpan; Total Saldo = jumlah dompet (BR-30); `profiles.timezone` dapat diubah dan dipakai server; hapus akun menghapus semua baris dan berkas, dapat diulang pada tiap langkah, dan notifikasi lokal serta sesi dibersihkan (T-DEL-01 sampai T-DEL-06); hapus akun tersedia di dalam aplikasi; perilaku Supabase saat pengguna memiliki objek Storage diuji di proyek dev (T-DEL-02, OI-42); pencabutan token Apple (T-DEL-07) ditunda ke rilis iOS (OI-51).

## Fase 2: Transaksi dan transfer (L)
- Isi: Beranda (ringkasan, daftar terbaru), Transaksi (cari, filter, grup harian), sheet Tambah Transaksi (pemasukan/pengeluaran, keypad, kategori seragam, dompet), Detail/Edit/Hapus Transaksi, Transfer antar dompet (tujuan Investasi diteruskan ke fase 6), tabel `transactions` + `source` + RPC + view saldo dan feed, kartu Hutang & Piutang/Investasi di Beranda sebagai placeholder sampai fase 5/6; `archive_wallet_v1` (menolak dompet bersaldo bukan nol dan dompet default), peringatan saldo negatif di klien (OI-31), matriks CHECK `type` x `source` x `counter_wallet_id` (bertahap per fase, 12-build-plan) dan FK komposit `(user_id, id)` untuk semua tabel anak; indeks 06 bagian 10 (termasuk parsial Analitik, `counter_wallet_id`, trigram pencarian) dan paginasi keyset; view `v_wallet_balance` dengan rumus eksplisit.
- Dependensi: fase 1.
- DoD: TRX-01 sampai TRX-09 dan WAL-04 lulus; angka Beranda cocok dengan view (BR-30, BR-04); tes RLS transaksi; tes nominal bigint; kategori pengeluaran 8 item tanpa Investasi; transfer tidak mengubah Total Saldo antar dompet; source `debt`/`debt_payment` di luar Analitik (tes dengan data sintetis); semua RPC tulis idempoten dengan `client_request_id` (T-IDM); kombinasi CHECK yang tidak valid ditolak (T-CHK); baris anak tidak dapat menunjuk induk milik pengguna lain (T-FK); rencana kueri memakai indeks parsial pada 50.000 transaksi (T-PERF-01 sampai T-PERF-05); p95 saldo di bawah 300 ms pada 10.000 transaksi, bila tidak maka cache saldo dibuat (T-PERF-06, OI-47); arsip dompet bersaldo bukan nol ditolak (T-WAL-08) dan saldo negatif diizinkan dengan peringatan (T-WAL-13).

## Fase 3: Anggaran dan analitik (M)
- Isi: Anggaran (total terpisah, kategori, ring, bar, warna 70/90, sisa hari), Atur Anggaran dengan validasi jumlah kategori tidak melebihi total, Analitik (donat, arus kas, insight), tabel `budgets`, `monthly_budgets`, view dan RPC.
- Dependensi: fase 2.
- DoD: BGT-01 sampai BGT-04 dan ANL-01 sampai ANL-03 lulus; hanya transaksi yang dihitung masuk (BR-04, tes dengan transfer, income, debt, debt_payment); angka demo sesuai OI-26 setelah disetujui; warna status tepat di batas 70 dan 90; batas bulan mengikuti `profiles.timezone` (T-TZ-01 sampai T-TZ-05, termasuk T-BGT-08); tes RLS dan hak anggaran.
- Akhir fase 3 = MVP siap uji pengguna.

## Fase 4: Scan nota (L)
- Isi: Scan Nota (kamera, galeri, flash, deteksi), Memproses, Hasil Scan, ML Kit, Edge Function `ocr-parse` dengan Google AI (model ringan, fallback vision) memakai JWT pengguna dan RPC `start_scan_v1`/`claim_scan_fallback_v1`, validasi keluaran LLM (07 bagian 8), `storage-janitor` terjadwal, validasi (BR-13), ambang amber 85% (BR-12), kuota 20 scan dan 10 fallback per hari, toggle "Simpan foto nota" di Pengaturan, penghapusan gambar (BR-15), `scans`, `transaction_items`, RPC simpan.
- Dependensi: fase 2.
- DoD: SCN-01 sampai SCN-09 lulus; set sampel nota nyata (minimal 30, [ASUMSI]) dengan akurasi total sesuai target; validasi menolak angka tidak cocok; field di bawah 85% amber; gambar tidak tersisa di perangkat/Storage bila toggle mati (tes); teks mentah OCR tidak tersimpan (tes); tidak ada kunci API di paket aplikasi (pemeriksaan otomatis); kuota ditegakkan dan idempoten (retry tidak memotong dua kali); kuota scan atau fallback habis menampilkan pesan dan mengarahkan ke input manual (OI-48); keluaran LLM yang melanggar skema ditolak (T-LLM); `ocr-parse` tidak memuat rujukan service role (CI); file Storage dihapus setelah commit dan file yatim dibersihkan janitor (T-JAN).

## Fase 5: Hutang-piutang dan saling hapus (L)
- Isi: 16 layar HUTANG & PIUTANG (varian Kosong - Pengguna Baru), kontak (tabel contacts, pemilih, dialog nama ganda), catatan, pembayaran, transaksi `debt` dan `debt_payment` dengan dompet, saling hapus FIFO (RPC atomik dengan `expected_amount`) dengan riwayat dicatat (layar riwayat ditunda), ubah/hapus hutang dan batalkan pembayaran bertaut (`update_debt_v1`, `delete_debt_v1`, `cancel_debt_payment_v1`), notifikasi lokal H-3 dan hari-H.
- Dependensi: fase 2.
- DoD: DBT-01 sampai DBT-08 dan NET-01 sampai NET-04, NET-06, NET-07 lulus (NET-05 ditunda, DBT-07 hanya notifikasi lokal); tes saling hapus sesuai 05 C.1 dan 10 (invarian, idempotensi, konkurensi, FIFO banyak catatan, pratinjau basi ditolak); pembatalan pembayaran menghapus transaksi tertaut atomik (T-PAY-10); layar konfirmasi saling hapus memuat peringatan tidak dapat dibatalkan dan tidak ada RPC pembatalan (T-NET-17); pencocokan hanya via contact_id (tes dua kontak bernama sama); RLS penuh; angka seed cocok BR-18; teks timbal balik benar arah; tombol Kirim Pengingat dan Lihat Riwayat tidak ada di MVP.

## Fase 6: Investasi dan scan investasi (L)
- Isi: 10 layar INVESTASI, `investments`, `investment_transactions`, `investment_valuations`, alokasi, untung/rugi, Tambah Investasi manual (menerima nominal dan sumber dana dari Transfer), Scan Investasi (pipeline fase 4) untuk Bibit, Tokopedia Emas, Pegadaian, Pluang, Lainnya, pencatatan transfer `source = 'investment'` dari dompet (BR-03); RPC investasi atomik (`create_investment_v1`, `add_investment_purchase_v1`, `update_investment_v1`, `delete_investment_v1`, `update_investment_value_v1`); nilai aset = valuasi terbaru (BR-23).
- Dependensi: fase 2, fase 4.
- DoD: INV-01 sampai INV-06 dan SIN-01 sampai SIN-04 lulus; angka seed cocok BR-18 dan 05 C.4; investasi tidak tampil di Analitik dan tidak masuk Total Saldo; transfer ke aset mengurangi Total Saldo; tes RLS investasi; hasil scan reksa dana dan emas sesuai contoh; sampel screenshot minimal 5 per platform [ASUMSI].

## Fase 7: Asisten AI (L)
- Isi: Chat, kartu Konfirmasi, chip saran, Edge Function `chat` dengan alat baca (Google AI), `pending_actions`, `confirm_pending_action_v1`, model chat dipilih pada gerbang fase ini (OI-40); kuota 50 pesan per hari (idempoten per pesan); `chat` memakai JWT pengguna dan tanpa service role; konteks yang berasal dari data tersimpan ditandai tak tepercaya (07 bagian 8); mikrofon dan layar riwayat ditunda.
- Dependensi: fase 2, 3, 5, 6 untuk cakupan jawaban; infrastruktur Edge Function dari fase 4.
- DoD: AIC-01 sampai AIC-04 lulus; tidak ada penulisan sebelum konfirmasi (BR-17), termasuk percobaan prompt injection; jawaban angka cocok dengan view (data seed); RLS berlaku pada alat baca; kuota ditegakkan; biaya dipantau.

## Fase 8: Pengerasan dan rilis (M)
- Isi: pengujian pemulihan cadangan/PITR, rotasi rahasia pertama, tinjauan hak (audit T-SEC) menyeluruh, halaman Syarat & Ketentuan dan Kebijakan Privasi (OI-30), aksesibilitas (kontras, ukuran teks, label semantik), performa, pelaporan crash, pembersihan isu P1/P2, build rilis bertanda tangan dan distribusi APK lewat Google Drive beserta panduan pasang dan perbarui (OI-53). Kategori Saya, Ekspor Data, Bantuan, Notifikasi, dan Riwayat Saling Hapus ditunda ke backlog pasca-rilis (OI-30).
- Dependensi: fase 1 sampai 7.
- DoD: tidak ada isu P0/P1 terbuka di OPEN_ISSUES; kontras ≥ 4,5:1 untuk teks (OI-18, wajib sebelum rilis); uji aksesibilitas dasar; pemindaian kerentanan dependensi; uji jalur lengkap di perangkat Android nyata (iOS ditunda, OI-51); build rilis bertanda tangan terpasang dan login Google berfungsi di perangkat bersih; pembaruan menimpa pemasangan lama (T-DST-01 sampai T-DST-06); dokumen diperbarui.

## Jalur kritis dan risiko jadwal
Jalur kritis: 0 → 1 → 2 → 4 → 6 → 7 (urutan modul rinci fase 0 sampai 3 di 12-build-plan). Skema transaksi/dompet dan pola tulis (RPC definer, `client_request_id`, online-only, zona waktu) sudah diputuskan, jadi fase 0 sampai 2 dapat dimulai; sisa risiko: persetujuan data demo (OI-26), kontras tombol (OI-27), dan perilaku Storage saat hapus akun (diuji di proyek dev pada fase 1, OI-42). Fase 0 dan 1 membesar menjadi L karena platform data, dompet, onboarding, dan hapus akun. Fase 4 dan 7 bergantung pada konfigurasi Google AI (Gemini API, akun dengan penagihan aktif untuk produksi) di Edge Function dan pemantauan biaya.
