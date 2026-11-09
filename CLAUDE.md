# CLAUDE.md: RekapFin

Aturan tetap untuk agen coding di proyek ini. Aplikasi pelacak keuangan pribadi berbahasa Indonesia (Flutter + Supabase). Sumber kebenaran produk ada di [docs/](docs/INDEX.md). Perintah di bagian "Perintah" berlaku setelah scaffolding (Sprint 0, docs/13-sprint-plan.md; fase 0 di docs/09-roadmap.md). Istilah kode modul, kelas tabel, dan peran ada di glosarium [docs/INDEX.md](docs/INDEX.md).

## Stack
Flutter (Dart), flutter_riverpod, go_router, supabase_flutter, freezed + json_serializable, fl_chart, local_auth, google_mlkit_text_recognition, intl, flutter_local_notifications (notifikasi lokal jatuh tempo). Backend: Supabase (Postgres, RLS, Edge Functions Deno/TypeScript, Storage). LLM: Google AI (Gemini API) hanya lewat Edge Function (model ringan; vision hanya fallback). Produksi wajib akun dengan penagihan aktif; data pengguna nyata tidak dikirim lewat kuota gratis. Detail di [docs/07-arsitektur.md](docs/07-arsitektur.md). Kunci versi paket di pubspec saat scaffolding dan catat di sini.

## Struktur folder (feature-first)
```
lib/app/ (router, theme)  lib/core/ (design_system, money, supabase, errors)
lib/features/<fitur>/{data,domain,presentation}
supabase/{migrations,functions,seed.sql,tests}   test/   docs/
```
Fitur: auth, home, wallets, transactions, budget, analytics, scan, chat, profile, debts, investments, notifications. Fitur tidak mengimpor fitur lain secara langsung. Tidak ada panggilan Supabase di widget; lewat repository.

## Aturan keras
1. Nominal rupiah = bigint di basis data (maksimum Rp 100 miliar per transaksi) dan `int` di Dart (kelas `Rupiah`). Dilarang `double`/float untuk uang. Tampilan "Rp 1.250.000" lewat satu fungsi format. (BR-01, BR-02)
2. RLS wajib di setiap tabel data pengguna, di migrasi yang sama dengan tabelnya, kebijakan `user_id = auth.uid()`. Tabel tanpa RLS tidak boleh digabung. View `security_invoker`. (BR-29)
3. Tipe transaksi `income | expense | transfer` dengan `source` (`manual`, `scan`, `chat`, `debt`, `debt_payment`, `investment`). Analitik, Anggaran, dan kartu Pemasukan/Pengeluaran Beranda hanya menghitung income/expense dengan source BUKAN `debt` dan BUKAN `debt_payment`; `transfer` tidak pernah dihitung. Daftar Transaksi menampilkan semua. (BR-03, BR-04, BR-37)
4. Investasi BUKAN pengeluaran: transfer dari dompet ke aset (`source = 'investment'`). Tidak ada kategori "Investasi" di tab Pengeluaran. Nilai investasi tidak ikut Total Saldo. (BR-03, BR-25, BR-30)
5. Dompet: Tunai, Bank, E-wallet, default "Saldo Utama". Total Saldo = jumlah semua dompet. Setiap transaksi punya dompet. (BR-30, BR-31)
6. Hutang = uang yang saya pinjam; piutang = uang saya yang dipinjam orang. Orang dicocokkan lewat tabel `contacts` dan `contact_id`, bukan nama; nama ganda memicu dialog konfirmasi. Hutang/piutang baru dan pembayaran membuat transaksi (`debt`, `debt_payment`) hanya bila toggle aktif. (BR-05, BR-08, BR-09, BR-33)
7. Saling hapus hanya lewat RPC atomik, alokasi FIFO jatuh tempo terdekat di kedua sisi, tidak mengubah saldo dompet, tidak membuat transaksi, riwayat dicatat. (BR-06, BR-07, BR-34)
8. Kunci API/LLM tidak boleh ada di aplikasi; hanya di rahasia Edge Function. Aplikasi hanya memegang URL dan anon key. Jangan membaca, menampilkan, atau meng-commit `.env*`, kunci, token. (BR-16)
9. Chatbot tidak menulis ke database tanpa kartu konfirmasi pengguna; penulisan hanya lewat `confirm_pending_action_v1`. (BR-17)
10. OCR: ML Kit on-device, Google AI (model ringan) merapikan lewat Edge Function menjadi JSON dengan keyakinan per field; fallback vision hanya bila parsing/validasi gagal. Amber "Periksa kembali" bila keyakinan di bawah 85% atau total tidak cocok rincian. Gambar dihapus setelah dibaca kecuali pengaturan "Simpan foto nota" (bawaan mati) aktif; teks mentah OCR tidak disimpan. Batas awal 20 scan, 50 pesan chat, dan 10 fallback vision per hari (fallback tidak memotong kuota scan, hanya sekali per scan, membawa `scan_id`), dari tabel konfigurasi. (BR-10 sampai BR-15, BR-28)
11. Operasi multi-langkah (pembayaran + transaksi, batalkan pembayaran, saling hapus, simpan scan, transfer, investasi, arsip dompet) berjalan atomik di server dalam satu RPC, bukan beberapa panggilan klien.
12. Anggaran: Total Anggaran terpisah dari batas kategori, jumlah batas kategori tidak boleh melebihi total; warna kurang dari 70% hijau, 70 sampai 90 amber, lebih dari 90 merah. (BR-22)
13. Tulis hanya lewat RPC: tabel kelas A (docs/06 bagian 1: wallets, transactions, transaction_items, budgets, monthly_budgets, debts, debt_payments, debt_offsets, debt_offset_items, investments, investment_transactions, investment_valuations, scans, pending_actions, ai_usage, request_log) tidak boleh ditulis langsung; DML dicabut dari `authenticated`. RPC tulis `SECURITY DEFINER` berversi (`create_transaction_v1`), `search_path` tetap, cek `auth.uid()` di awal, tidak pernah menerima `user_id` dari klien, `EXECUTE` dicabut dari `anon` dan `PUBLIC` (dicabut ulang setiap migrasi yang membuat fungsi). Jangan menulis tabel kelas A dari klien. Tabel kelas B (profiles dengan hak kolom, categories, contacts, chat_sessions, chat_messages) ditulis langsung di bawah RLS dengan `id` dari klien (retry idempoten lewat kunci primer); server tidak mencegah nama kontak ganda, klien memakai `find_similar_contacts_v1` dan dialog konfirmasi. (BR-08, BR-40)
14. Setiap RPC tulis wajib `client_request_id` (uuid dari klien, dipakai ulang saat retry), unik per `(user_id, client_request_id)`. Nama `idempotency_key` tidak dipakai. (BR-40)
15. Tabel anak memakai FK komposit `(user_id, id)`. Tidak ada FK melingkar: transaksi menunjuk induknya (`debt_id`, `debt_payment_id`, `investment_transaction_id`, `scan_id`). Hanya kombinasi `type` x `source` x kolom penunjuk di docs/06 bagian 5 yang valid. (BR-38; keputusan audit 6 dan 7, lihat [docs/OPEN_ISSUES.md bagian F](docs/OPEN_ISSUES.md#f-keputusan-audit-arsitektur-diterapkan-di-dokumen))
16. Saldo dompet dihitung dari view (rumus di docs/06 bagian 6), tidak disimpan. Saldo negatif diizinkan dengan peringatan di klien. Dompet bersaldo bukan nol tidak boleh diarsipkan. Cache saldo hanya bila p95 saldo lebih dari 300 ms pada 10.000 transaksi. (BR-30, BR-43)
17. MVP online-only: tanpa antrean tulis lokal. OCR ML Kit, Biometrik, dan notifikasi lokal tetap jalan offline. Tanpa jaringan: error konsisten, tombol simpan nonaktif, isian dipertahankan, retry aman. (BR-39)
18. "Hari" dan "bulan" dihitung di server menurut `profiles.timezone` (bawaan `Asia/Jakarta`), bukan di klien; kuota harian ikut zona itu. Waktu disimpan `timestamptz`; tanggal kalender `date`. (BR-42)
19. Edge Function memakai JWT pengguna: buat klien dari URL, anon key, dan header Authorization pemanggil; verifikasi JWT aktif. Service role dilarang di `ocr-parse` dan `chat` (CI memindai). Service role hanya di `delete-account` (dengan pembatasan, docs/07 bagian 7.2) dan `storage-janitor` (terjadwal, tidak dapat dipanggil pengguna, hanya menghapus file yatim; diputuskan, OI-41). (BR-16)
20. Fitur AI (scan, chat) hanya jalan bila `profiles.ai_consent_at` terisi lewat `record_ai_consent_v1`; RPC yang memotong kuota AI (`start_scan_v1`, `claim_scan_fallback_v1`, `consume_chat_quota_v1`) menolak dengan `ai_consent_required` bila kosong. (BR-47, OI-54)
21. Keluaran LLM wajib skema ketat; `category_suggestion` hanya id kategori pengguna; panggilan OCR tanpa alat; teks OCR dan gambar dipisah dari instruksi sistem; data tersimpan yang masuk konteks chat diperlakukan sebagai tak tepercaya. (BR-45)
22. Skema berubah maju-saja dengan pola expand-contract; RPC berversi; aplikasi di bawah `min_app_version` diblokir. `seed.sql` hanya lokal/staging; data bawaan produksi lewat pemicu di migrasi. Kunci terpisah per lingkungan; `--dart-define` hanya URL dan anon key, tidak pernah rahasia. (BR-41)
23. Hapus akun: `ON DELETE CASCADE` dari `auth.users`; urutan Storage (lewat Storage API), pencabutan token Apple bila ada (hanya rilis iOS), `purge_user_data_v1`, hapus pengguna auth; tiap langkah idempoten; klien membatalkan notifikasi lokal dan membersihkan sesi. Penghapusan file Storage mengikuti commit database. (BR-44)
24. Platform dan distribusi: rilis pertama hanya Android (OI-51) dan berupa APK bertanda tangan yang dibagikan lewat Google Drive, bukan Play Store (OI-53). Tidak ada Sign in with Apple, TestFlight, atau pencabutan token Apple di rilis ini; kode dan desain dibuat agar iOS dapat menyusul. Biometrik memakai biometrik perangkat. Keystore, kata sandinya, dan berkas `.jks` tidak boleh masuk repo; `versionCode` naik pada setiap build yang dibagikan; SHA-1 keystore didaftarkan pada klien OAuth Google. Pembaruan manual lewat `app_config.update_url`.

## Desain dan token
- JANGAN ubah desain tanpa izin. Jangan memodifikasi `RekapFin.pen`. Bila render berbeda dari desain atau desain bermasalah, laporkan ke [docs/OPEN_ISSUES.md](docs/OPEN_ISSUES.md), jangan "memperbaiki" diam-diam. Sumber kebenaran nilai visual (warna, ukuran, radius, token) adalah RekapFin.pen terkini (OI-55); docs/08 menyalinnya. Bila keduanya berbeda, ikuti .pen dan perbarui docs/08. Untuk aturan bisnis dan keputusan produk, dokumen yang benar; selisih .pen terhadap keputusan dicatat di [docs/11-perubahan-pen.md](docs/11-perubahan-pen.md) dan [docs/14-status-desain.md](docs/14-status-desain.md). Berkas .pen tidak ada di repo; lokasinya di [docs/INDEX.md](docs/INDEX.md).
- Token warna (hanya lewat tema, tanpa literal warna di widget): bg-base #F0FDF4, accent #10B981 (non-teks), accent-action #047857 (isi tombol/chip aktif dan ikon/label nav aktif; putih/#047857 = 5,48:1, OI-27), income #059669, expense #DC2626, warning #D97706 (isi/ikon) dan warning-text #B45309 (teks), status-ok #047857 / status-warn #B45309 / status-danger #B91C1C (+ `-fill` #10B981 / #D97706 / #DC2626), text-primary #0B2E22, text-secondary #4F6B5E, text-muted #557566, glass-fill #FFFFFF8C, glass-border #FFFFFFCC, glass-shadow #0F172A14, gradien hero #047857 ke #078761. Daftar lengkap di [docs/08-design-system.md](docs/08-design-system.md).
- Font Plus Jakarta Sans (dibundel). Ikon Lucide 1,75 px. Radius: kartu 24, tombol 16, chip 999 (pil), nav 34. Tombol primer 350 x 56. Ukuran teks: fs-display 36, fs-page-title 28, fs-title 20, fs-subtitle 16, fs-body 14, fs-caption 12, fs-micro 11. Spasi 8/16/24/32, padding layar 20.
- Layout (OI-55): frame 390 x 844 adalah viewport; padding konten 20, atas 54, bawah 24. Konten yang lebih tinggi dari viewport digulir dengan padding bawah 160 px. BottomNavBar 350 x 68 di x=20,y=752 dan tombol Tanya AI fixed (tidak ikut gulir). Tombol Tanya AI 130 x 52 di (240, 684); zona bebas teks/nominal x 302..390, y 672..744. Jarak minimum antar section 16 dan antar kartu 12. Chip filter berupa baris yang bisa digeser, chip terakhir boleh terpotong. Teks minimal 12 px kecuali label BottomNavBar, "Tanya AI", dan label Aksi Cepat (11 px, pengecualian sengaja).
- Gaya: iOS glassmorphism terang, satu warna emerald. Jangan menambah fitur di luar desain dan keputusan; ide tambahan masuk "Usulan" di OPEN_ISSUES.
- Ditunda (jangan dibangun): antrean tulis offline dan tampilan terakhir hanya-baca, layar Notifikasi, layar Riwayat Saling Hapus (data tetap dicatat), mikrofon di chat, pengingat via WhatsApp, impor kontak perangkat, mata uang selain IDR.

## Perintah (setelah scaffolding)
```
flutter pub get
dart format --set-exit-if-changed lib test
flutter analyze
flutter test                         # semua
flutter test test/features/debts     # tes paling sempit yang relevan
supabase start
supabase db reset                    # terapkan migrasi + seed
supabase test db                     # pgTAP: RLS, RPC, view
supabase functions serve             # Edge Function lokal
```
Jalankan tes paling sempit yang relevan; klaim "selesai" harus dibuktikan dengan menjalankannya. Laporkan tes gagal apa adanya.

## Kerja sehari-hari
- Baca dokumen yang relevan sebelum mengimplementasikan: layar → docs/03; aturan → docs/05; tabel → docs/06; fase → docs/09; tes → docs/10.
- Perubahan minimal, ikuti gaya kode sekitar, tanpa refaktor di luar tugas.
- Git (OI-56): commit per modul (satu modul = satu commit, docs/13 bagian 2.3) diizinkan setelah tes yang relevan hijau. Push hanya atas perintah pemilik produk. Jangan menghapus berkas tanpa diminta. Jangan mengarang nama field/API/angka; verifikasi atau tandai belum diverifikasi.
- Angka contoh kanonik (seed dan tes): Piutang Rp 6.100.000 (5 orang), Hutang Rp 2.750.000 (3 orang), saldo bersih +Rp 3.350.000; investasi nilai Rp 12.930.000, modal Rp 12.640.000, untung Rp 290.000 (+2,3%), alokasi 39,6% / 37,7% / 22,7%; dompet Saldo Utama 18.500.000 + Tunai 1.250.000 + E-wallet 5.000.000 = Rp 24.750.000. Set demo anggaran dan transaksi di OPEN_ISSUES bagian C sudah disetujui (OI-26) dan menjadi seed.
- Butir OI-01 sampai OI-57 sudah Diputuskan. Empat butir tertunda terjadwal (OI-58 sampai OI-61: privasi task switcher, fokus input dan skeleton, metrik, kapasitas) ada di docs/OPEN_ISSUES.md bagian H; tindak lanjut terjadwal lain di bagian G. Urutan pembangunan fase 0 sampai 3 ada di docs/12-build-plan.md dan jadwal sprint di docs/13-sprint-plan.md. Bila menemukan hal yang tidak diputuskan, tanyakan, jangan menebak.

## Tautan
[docs/INDEX.md](docs/INDEX.md) · [PRD](docs/01-PRD.md) · [Aturan bisnis](docs/05-aturan-bisnis.md) · [Model data](docs/06-model-data.md) · [Arsitektur](docs/07-arsitektur.md) · [Design system](docs/08-design-system.md) · [Roadmap](docs/09-roadmap.md) · [Rencana uji](docs/10-test-plan.md) · [Perubahan pen.dev](docs/11-perubahan-pen.md) · [Build plan](docs/12-build-plan.md) · [Isu terbuka](docs/OPEN_ISSUES.md)
