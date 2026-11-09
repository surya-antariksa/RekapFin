# 05. Aturan Bisnis

> Ringkasan: aturan bisnis bernomor BR-01 sampai BR-47 beserta contoh hitungan. BR-01 sampai BR-18 adalah aturan yang ditetapkan pemilik produk pada awal proyek (dokumen sumber awal tidak ada di repo; aturan ini dikonfirmasi dan sebagian diperbarui oleh keputusan OI-07 sampai OI-25); BR-19 sampai BR-38 diturunkan dari desain dan keputusan; BR-39 sampai BR-47 berasal dari audit arsitektur ([13 keputusan audit](OPEN_ISSUES.md#f-keputusan-audit-arsitektur-diterapkan-di-dokumen)), keputusan distribusi, dan persetujuan AI (tulis hanya lewat RPC, online-only, zona waktu, matriks CHECK, hapus akun, validasi LLM, distribusi APK). Butir bertanda [ASUMSI] adalah nilai awal yang sudah disetujui dan dikalibrasi saat implementasi. Setiap aturan harus punya tes di [10-test-plan.md](10-test-plan.md).

Status: Diperbarui setelah keputusan OI-01 sampai OI-57, audit arsitektur, dan penutupan semua butir tersebut. Butir yang masih bertanda [ASUMSI] hanyalah detail kecil di BR-19 (ambang 7 hari, disetujui OI-37), BR-21, BR-34 (seri), dan BR-35, yang dipakai sebagai nilai awal dan dikalibrasi saat implementasi. Semua nominal dalam rupiah utuh.

## A. Aturan inti (ditetapkan pemilik produk, diperbarui)

| ID | Aturan | Catatan |
|---|---|---|
| BR-01 | Nominal rupiah disimpan sebagai bigint rupiah utuh (tanpa sen, tanpa float/double/numeric desimal). Di Dart memakai `int`. | Persentase dan unit non-rupiah (gram, unit reksa dana) disimpan terpisah sebagai numeric. |
| BR-02 | Tampilan nominal: "Rp 1.250.000" (titik ribuan, spasi setelah Rp, tanpa desimal). Negatif: satu karakter minus di seluruh aplikasi (OI-16). Ringkas "Rp 24,8 jt" hanya untuk kartu ringkas, pembulatan setengah ke atas. | Satu fungsi format di kode. |
| BR-03 | Investasi (reksa dana, emas) BUKAN pengeluaran. Dicatat sebagai `transfer` dari dompet ke aset dengan `source = 'investment'`. | Tidak pernah bertipe `expense`. Tidak ada kategori "Investasi" di tab Pengeluaran (OI-06). |
| BR-04 | Analitik hanya menghitung transaksi dengan `source` bukan `debt` dan bukan `debt_payment`; pengeluaran = `type = 'expense'`, pemasukan = `type = 'income'`. `transfer` tidak pernah dihitung. | Berlaku juga untuk Anggaran dan kartu Pemasukan/Pengeluaran bulan ini di Beranda [ASUMSI, OI-28]. Daftar Transaksi menampilkan semua. |
| BR-05 | Hutang = uang yang pengguna pinjam dari orang. Piutang = uang pengguna yang dipinjam orang. | `direction`: `borrowed` = hutang, `lent` = piutang. |
| BR-06 | Saling hapus (netting): untuk orang yang sama, saldo bersih = total piutang sisa dikurangi total hutang sisa. Kedua sisi berkurang sebesar nilai yang lebih kecil. | Contoh di bagian C. |
| BR-07 | Saling hapus tidak mengubah saldo dompet dan tidak tercatat sebagai transaksi; hanya masuk riwayat "Saling hapus". Saling hapus tidak dapat dibatalkan di MVP (tidak ada RPC pembatalan); layar konfirmasi wajib dan memuat peringatan bahwa tindakan tidak dapat dibatalkan. | Data riwayat tetap dicatat; layar riwayat ditunda (OI-17). OI-46 Diputuskan. |
| BR-08 | Orang dicocokkan lewat `contact_id` (tabel `contacts`), bukan nama. Mengetik nama yang sama dengan kontak yang ada memicu dialog konfirmasi di klien (`find_similar_contacts_v1`): pakai kontak yang ada atau buat kontak baru. `contacts` adalah tabel kelas B (tulis langsung di bawah RLS), jadi server tidak mencegah nama ganda; server hanya menjaga kepemilikan, keunikan `(user_id, phone)`, dan `RESTRICT` pada catatan hutang. | OI-13, OI-38 Diputuskan. |
| BR-09 | Pembayaran hutang/piutang dengan toggle "Catat ke transaksi" aktif membuat transaksi otomatis: terima pembayaran piutang = `income`, bayar hutang = `expense`, keduanya `source = 'debt_payment'` dan pada dompet yang dipilih. | Tidak masuk Analitik (BR-04). Membatalkan pembayaran (`cancel_debt_payment_v1`) menghapus pembayaran dan transaksi `debt_payment` tertaut secara atomik. |
| BR-10 | OCR: foto nota dan screenshot investasi dibaca on-device (ML Kit). | Teks hasil OCR dikirim, bukan gambar, kecuali fallback (BR-14). |
| BR-11 | Teks OCR dirapikan Google AI (Gemini API) (model ringan) lewat Supabase Edge Function menjadi JSON dengan skor keyakinan per field. | Skema JSON di [07-arsitektur.md](07-arsitektur.md). |
| BR-12 | Field berkeyakinan di bawah 85% (0,85) ditandai amber "Periksa kembali". | OI-24. |
| BR-13 | Validasi OCR nota: jumlah item = subtotal; subtotal + pajak = total. Total yang tetap tidak cocok setelah fallback ditandai amber. | Toleransi 0 rupiah [ASUMSI]. |
| BR-14 | Bila parsing gagal atau validasi gagal, fallback ke vision (gambar dikirim lewat Edge Function), satu kali per scan (membawa `scan_id`). Keyakinan rendah saja tidak memicu fallback. Fallback tidak memotong kuota scan tetapi dibatasi 10 per hari. Bila kuota fallback habis: tampil pesan batas harian dan arahan ke input manual ("Ketik Manual"), tanpa hasil amber. | OI-24, OI-48 Diputuskan. |
| BR-15 | Gambar dihapus setelah dibaca. Gambar hanya disimpan bila pengaturan "Simpan foto nota" (bawaan mati) diaktifkan. Teks mentah OCR tidak disimpan. Penghapusan file Storage dilakukan setelah commit database; file yatim dibersihkan `storage-janitor` terjadwal. | OI-09, OI-10, keputusan 13. |
| BR-16 | Kunci API tidak boleh ada di aplikasi. Hanya di rahasia Edge Function. | Aplikasi hanya memegang URL dan anon key Supabase. |
| BR-17 | Chatbot tidak boleh menulis ke database tanpa kartu konfirmasi dari pengguna. | Penulisan hanya lewat `confirm_pending_action_v1`. |
| BR-18 | Data contoh konsisten: Piutang Rp 6.100.000 (5 orang), Hutang Rp 2.750.000 (3 orang), saldo bersih +Rp 3.350.000; investasi total nilai Rp 12.930.000, modal Rp 12.640.000, untung Rp 290.000 (+2,3%), alokasi 39,6% / 37,7% / 22,7%. | Seed dan uji. Set demo lain di OPEN_ISSUES bagian C. |

## B. Aturan turunan dari desain dan keputusan

| ID | Aturan | Sumber |
|---|---|---|
| BR-19 | Status catatan: Lunas bila sisa = 0; Terlambat bila jatuh tempo lewat dan sisa > 0; Jatuh tempo bila jatuh tempo dalam 0 sampai 7 hari dan sisa > 0 (filter); Belum lunas selain itu. Teks relatif "Jatuh tempo N hari lagi" untuk 0 sampai 3 hari, "Terlambat N hari" untuk lewat, tanggal absolut selain itu. | [DESAIN] teks, [ASUMSI] ambang (OI-37) |
| BR-20 | Pembayaran tidak boleh melebihi sisa; nominal > 0; "Bayar Lunas" = sisa; "Setengah" = sisa dibagi 2 dibulatkan ke bawah. | [DESAIN], [ASUMSI] pembulatan |
| BR-21 | Sisa = total - terbayar - total alokasi saling hapus. Persen terbayar = terbayar / total, dibulatkan ke bilangan bulat. Saling hapus pengurang sisa; apakah dihitung "terbayar" pada persen [ASUMSI: tidak dihitung terbayar, ditampilkan terpisah]. | [ASUMSI] |
| BR-22 | Anggaran: Total Anggaran bulanan adalah angka terpisah dari batas kategori; jumlah batas kategori tidak boleh melebihi Total Anggaran. Terpakai total = semua expense bulan itu yang dihitung Analitik (BR-04), termasuk kategori tanpa anggaran. Terpakai kategori = expense kategori itu. Persen = terpakai / batas (dibulatkan). Sisa = batas - terpakai. Warna: kurang dari 70% hijau; 70% sampai 90% amber; lebih dari 90% merah. Sisa hari = hari tersisa pada bulan berjalan (30 - 9 = 21 pada 9 Nov). | OI-11; angka demo disetujui (OI-26) |
| BR-23 | Investasi: nilai saat ini sebuah aset = valuasi terbaru tersimpan (bigint, dari Perbarui Nilai, scan, atau input "Nilai sekarang"); bila belum ada valuasi, nilai = modal. Harga per unit/gram "hari ini" adalah informasi turunan. Untung/rugi = nilai - modal; persen = untung / modal (satu desimal); alokasi = nilai aset / total nilai, jumlah 100,0% (metode sisa terbesar). Harga beli rata-rata = modal / unit. Nilai investasi tidak ikut Total Saldo. | [DESAIN], OI-08, OI-14 butir 12 |
| BR-24 | Saldo bersih global = total piutang sisa - total hutang sisa (Rp 6.100.000 - Rp 2.750.000 = Rp 3.350.000). Saling hapus tidak mengubah angka ini. | [DESAIN] |
| BR-25 | Kategori pengeluaran: Makanan, Transport, Belanja, Tagihan, Hiburan, Kesehatan, Pendidikan, Lainnya (sama di semua varian). Kategori pemasukan: Gaji, Bonus, Freelance, Investasi (hasil investasi), Hadiah, Penjualan, Refund, Lainnya. | OI-06, OI-32 |
| BR-26 | Daftar transaksi dikelompokkan per hari; total grup = income dikurangi expense hari itu (semua source). Transfer antar dompet tidak mengubah total grup; transfer ke investasi dihitung pengurang. Label "Hari Ini", "Kemarin", selainnya tanggal penuh. | [DESAIN], [ASUMSI] |
| BR-27 | Pengingat jatuh tempo: notifikasi lokal pada H-3 (dapat diubah pada form) dan hari-H, hanya untuk catatan dengan jatuh tempo dan sisa > 0. Dijadwalkan ulang saat catatan berubah. Pengiriman WhatsApp ditunda. | OI-22 |
| BR-28 | Batas pemakaian AI per pengguna per hari, dikonfigurasi di server: 20 scan, 50 pesan chat, dan 10 fallback vision. Fallback tidak menambah kuota scan. "Hari" kuota mengikuti `profiles.timezone`. Retry dengan `client_request_id` sama tidak memotong kuota dua kali. Satu paket gratis. | OI-09, OI-21, keputusan 5 |
| BR-29 | Semua tabel data pengguna wajib RLS dengan `user_id = auth.uid()`; tabel tanpa RLS tidak boleh dimigrasikan. Tabel berinvarian tidak dapat ditulis langsung (BR-40). Penghapusan akun menghapus semua baris dan berkas pengguna (BR-44). | [ASUMSI] |
| BR-30 | Total Saldo = jumlah saldo semua dompet yang tidak diarsipkan. Saldo dompet dihitung (tidak disimpan) dengan rumus eksplisit per kombinasi `type` x `source` di 06 bagian 6: income menambah, expense mengurangi, transfer antar dompet mengurangi sumber dan menambah tujuan, transfer ke investasi (`counter_wallet_id` kosong) hanya mengurangi sumber. Semua source ikut dihitung. Nilai investasi dan piutang tidak ikut. Saldo negatif diizinkan dengan peringatan di klien; server tidak menolak. | OI-08, keputusan 8, OI-31 Diputuskan |
| BR-31 | Dompet: jenis Tunai, Bank, E-wallet. Dompet default "Saldo Utama" dibuat otomatis. Saldo awal diisi di onboarding (boleh dilewati, bernilai 0) dan dapat diubah di layar Dompet. Setiap transaksi memiliki dompet. | OI-08. Arsip: lihat BR-43. Saldo negatif diizinkan dengan peringatan (OI-31 Diputuskan). |
| BR-32 | Transfer: antar dompet (dompet asal dan tujuan berbeda, nominal > 0) atau dompet ke investasi. Transfer ke investasi dibuat lewat alur Tambah Investasi/Hasil Scan Investasi (BR-03); layar Transfer dengan tujuan "Investasi" meneruskan ke /add-investment dengan nominal dan sumber dana terisi [ASUMSI]. | OI-06, OI-07 |
| BR-33 | Hutang atau piutang baru dengan toggle "Catat ke saldo & transaksi" aktif membuat transaksi `source = 'debt'` pada dompet yang dipilih: hutang baru = `income` (saldo naik), piutang baru = `expense` (saldo turun). Toggle mati: saldo tidak berubah dan tidak ada transaksi. | OI-07 |
| BR-34 | Alokasi saling hapus per sisi: FIFO berdasarkan jatuh tempo terdekat. Catatan tanpa jatuh tempo terakhir; seri: tanggal pinjam lebih lama, lalu waktu dibuat. Jumlah alokasi sisi piutang = sisi hutang = nilai saling hapus. | OI-12 [ASUMSI untuk seri dan tanpa jatuh tempo] |
| BR-35 | Ambang status warna anggaran dan teks bantu: 90% sampai 100% "Hampir melebihi batas!", di atas 100% "Melebihi batas". | OI-11 [ASUMSI] |
| BR-36 | Face ID opsional (bawaan mati), diaktifkan di Pengaturan; hanya membuka sesi tersimpan, bukan pengganti login pertama. | OI-25 |
| BR-37 | Tidak ada kategori transaksi untuk `transfer`, `debt`, dan `debt_payment` yang tampil di Analitik; baris tersebut tetap tampil di daftar Transaksi dengan label sumber. | OI-07 [ASUMSI] |
| BR-38 | Edit transaksi: transaksi bersumber `debt`, `debt_payment`, `investment` hanya dapat diubah/dihapus lewat catatan induknya (hutang, pembayaran, investasi) agar data tetap sinkron. Penunjuk satu arah: transaksi menunjuk induknya (`debt_id`, `debt_payment_id`, `investment_transaction_id`). | OI-31, keputusan 6 |
| BR-39 | MVP online-only: tanpa antrean tulis lokal dan tanpa sinkronisasi. OCR ML Kit, Face ID, dan notifikasi lokal tetap jalan tanpa jaringan; baca/tulis data, login, perapian LLM, dan chat butuh jaringan. Tanpa jaringan: error konsisten, tombol simpan nonaktif, isian form dipertahankan, retry aman karena `client_request_id`. | keputusan 2; 07 bagian 12 |
| BR-40 | Tabel kelas A (06 bagian 1: wallets, transactions, transaction_items, budgets, monthly_budgets, debts, debt_payments, debt_offsets, debt_offset_items, investments, investment_transactions, investment_valuations, scans, pending_actions, ai_usage, request_log) hanya ditulis lewat RPC `SECURITY DEFINER` berversi (`_v1`) dengan `search_path` tetap, cek `auth.uid()`, `EXECUTE` dicabut dari `anon` dan `PUBLIC`, DML dicabut dari `authenticated`. Setiap RPC tulis wajib `client_request_id` (uuid dari klien) unik per `(user_id, client_request_id)`; pengulangan mengembalikan hasil lama; id sama dengan muatan berbeda ditolak. Nama `idempotency_key` tidak dipakai. Tabel kelas B (profiles, categories, contacts, chat_sessions, chat_messages) ditulis langsung di bawah RLS dengan `id` dari klien (retry idempoten lewat kunci primer). | keputusan 1, 3, 5 |
| BR-41 | Perubahan skema maju-saja dengan pola expand-contract; RPC berversi; aplikasi di bawah versi minimum (`app_config`) diblokir sampai diperbarui. | keputusan 3 |
| BR-42 | "Hari" dan "bulan" dihitung di server menurut `profiles.timezone` (bawaan `Asia/Jakarta`): hari = tanggal kalender zona itu; bulan = tanggal 1 pukul 00.00 sampai tanggal 1 bulan berikutnya pukul 00.00 zona itu. Berlaku untuk daftar Transaksi, Anggaran, Analitik, sisa hari, dan reset kuota. | keputusan 4; daftar zona OI-44 |
| BR-43 | Dompet bersaldo tidak sama dengan 0 tidak boleh diarsipkan; dompet default tidak dapat diarsipkan; dompet terarsip tidak menerima transaksi baru. | keputusan 8 |
| BR-44 | Hapus akun: `ON DELETE CASCADE` dari `auth.users`; urutan Storage, pencabutan token Apple bila ada (hanya rilis iOS), `purge_user_data_v1`, hapus pengguna auth; setiap langkah idempoten dan dapat diulang; klien membatalkan notifikasi lokal dan membersihkan sesi. | keputusan 9; 07 bagian 11 |
| BR-45 | Keluaran LLM wajib skema ketat; `category_suggestion` hanya berupa id kategori pengguna; nilai, tanggal, dan panjang string dibatasi; panggilan OCR tanpa alat; teks OCR dan gambar terpisah dari instruksi sistem; data tersimpan yang masuk konteks chat ditandai tak tepercaya. | keputusan 12; 07 bagian 8 |
| BR-46 | Distribusi rilis pertama: APK Android bertanda tangan keystore pemilik, dibagikan lewat Google Drive ke akun tertentu, dipasang manual; pembaruan manual dengan `versionCode` yang naik; `app_config` memuat `min_app_version`, `recommended_version`, dan `update_url`. Keystore dan kata sandinya tidak masuk repo; SHA-1 didaftarkan pada klien OAuth Google. Play Store dan syarat tokonya bukan bagian rilis pertama. | OI-53, 07 bagian 16.1 |
| BR-47 | Persetujuan pemrosesan AI: sebelum fitur AI pertama dipakai (scan nota, scan investasi, pembacaan ulang, chat) pengguna menyetujui bahwa teks atau gambar dikirim ke Google (Gemini API) lewat Edge Function. Persetujuan dicatat di `profiles.ai_consent_at` dan `ai_consent_version` hanya lewat `record_ai_consent_v1`. RPC yang memotong kuota AI (`start_scan_v1`, `claim_scan_fallback_v1`, `consume_chat_quota_v1`) menolak dengan kode `ai_consent_required` bila `ai_consent_at` kosong, tanpa memotong kuota. Input manual tidak butuh persetujuan. Pencabutan persetujuan tidak ada di rilis pertama [ASUMSI]. | OI-54; 07 bagian 10.1 |

## C. Contoh hitungan

### C.1 Saling hapus (BR-06, BR-07, BR-24, BR-34)
| Kasus | Piutang sisa | Hutang sisa | Saldo bersih | Saling hapus | Sesudah |
|---|---|---|---|---|---|
| Budi (dia berhutang) | 2.000.000 | 750.000 | +1.250.000 | min = 750.000 | Hutang 0 (Lunas); Piutang 1.250.000 |
| Pak Hendra (kamu berhutang) | 400.000 | 1.500.000 | -1.100.000 | min = 400.000 | Piutang 0 (Lunas); Hutang 1.100.000 |
| Kak Rina (impas) | 500.000 | 500.000 | 0 | min = 500.000 | keduanya Lunas |

Invarian: saldo bersih per orang dan global tidak berubah oleh saling hapus.
Setelah ketiganya: Total Piutang 6.100.000 - 750.000 - 400.000 - 500.000 = Rp 4.450.000; Total Hutang 2.750.000 - 750.000 - 400.000 - 500.000 = Rp 1.100.000; selisih tetap Rp 3.350.000. Piutang tinggal Budi, Siti, Andi (3 orang); hutang tinggal Pak Hendra (1 orang).

Alokasi FIFO: Budi punya dua piutang A (jatuh tempo 12 Nov, sisa 1.000.000) dan B (jatuh tempo 20 Des, sisa 1.000.000), dan satu hutang 1.500.000. Nilai saling hapus = min(2.000.000, 1.500.000) = 1.500.000. Sisi piutang: A dikurangi 1.000.000 (Lunas), B dikurangi 500.000 (sisa 500.000). Sisi hutang: dikurangi 1.500.000 (Lunas).

### C.2 Pembayaran dan transaksi otomatis (BR-09, BR-20, BR-33)
Budi (piutang): total 3.000.000, terbayar 1.000.000 (33%), sisa 2.000.000. Menerima pembayaran 500.000 dengan "Catat ke transaksi" aktif: terbayar 1.500.000 (50%), sisa 1.500.000, dan satu transaksi `income` Rp 500.000 `source = 'debt_payment'` pada dompet yang dipilih; tidak masuk Analitik. Toggle mati: hanya sisa berubah. Nominal 2.500.000 ditolak karena melebihi sisa.
Piutang baru Rp 3.000.000 dengan toggle aktif: transaksi `expense` 3.000.000 `source = 'debt'`; saldo dompet turun 3.000.000; Analitik pengeluaran tidak berubah.

### C.3 Anggaran (BR-22) dengan set demo (disetujui, OI-26)
Total Anggaran 6.000.000; batas kategori 2.400.000 + 1.400.000 + 550.000 + 1.500.000 = 5.850.000 (tidak melebihi total).
| Kategori | Terpakai / batas | Persen | Sisa | Warna |
|---|---|---|---|---|
| Makanan | 1.990.000 / 2.400.000 | 82,9% → 83% | 410.000 | amber |
| Transport | 730.000 / 1.400.000 | 52,1% → 52% | 670.000 | hijau |
| Hiburan | 520.000 / 550.000 | 94,5% → 95% | 30.000 | merah |
| Tagihan | 1.255.000 / 1.500.000 | 83,7% → 84% | 245.000 | amber |
| Total | 5.230.000 / 6.000.000 | 87,2% → 87% | 770.000 | amber |
Terpakai total 5.230.000 = 1.990.000 + 730.000 + 520.000 + 1.255.000 + 735.000 (Belanja, tanpa anggaran). Hari tersisa pada 9 November: 21.
Pembayaran hutang (source `debt_payment`) dan transfer tidak menambah Terpakai.

### C.4 Investasi (BR-23)
Nilai = 5.120.000 + 4.870.000 + 2.940.000 = 12.930.000. Modal = 5.000.000 + 4.640.000 + 3.000.000 = 12.640.000. Untung = 290.000; persen = 290.000 / 12.640.000 = 2,29% (tampil +2,3%). Alokasi: 39,6% / 37,7% / 22,7%; jumlah 100,0%.
Emas: 3,2 gram, modal 2.900.000 + 1.740.000 = 4.640.000, harga beli rata-rata 1.450.000 per gram; nilai tersimpan 4.870.000 (harga hari ini sekitar 1.522.000 per gram); untung 230.000 / 4.640.000 = 4,96% (tampil +5,0%).
Reksa dana saham: nilai tersimpan 2.940.000; modal 3.000.000; rugi -60.000 (-2,0%).
Transfer ke aset 5.000.000: saldo dompet sumber turun 5.000.000 dan Total Saldo turun 5.000.000 (nilai investasi tidak ikut); expense bulan itu tidak berubah.

### C.5 Validasi nota dan ambang (BR-12, BR-13)
Hasil Scan contoh: (2 x 25.000) + (2 x 6.000) + (1 x 32.000) = 94.000 = subtotal. Pajak 10% = 9.400. 94.000 + 9.400 = 103.400 = total. Lulus. Bila total terbaca 108.400: validasi gagal, fallback vision; bila tetap tidak cocok, total amber. Field dengan keyakinan 0,84 amber; 0,85 tidak amber [ASUMSI batas: di bawah 0,85 amber].

### C.6 Format nominal (BR-02)
| Nilai (int) | Tampilan |
|---|---|
| 1250000 | Rp 1.250.000 |
| -35000 | -Rp 35.000 (satu karakter minus sesuai OI-16) |
| 0 | Rp 0 |
| 24750000 (ringkas) | Rp 24,8 jt |

### C.7 Total Saldo dan dompet (BR-30)
Demo: Saldo Utama 18.500.000 + Tunai 1.250.000 + E-wallet 5.000.000 = 24.750.000. Transfer 500.000 dari Saldo Utama ke Tunai: 18.000.000 + 1.750.000 + 5.000.000 = tetap 24.750.000. Transfer ke investasi 5.000.000 dari Saldo Utama: Total Saldo 19.750.000.
Rumus per kombinasi (06 bagian 6): transfer 500.000 Saldo Utama ke Tunai adalah satu baris `transfer`/`manual`: Saldo Utama -500.000 (sumber), Tunai +500.000 (`counter_wallet_id`). Transfer 5.000.000 ke investasi adalah `transfer`/`investment` tanpa `counter_wallet_id`: hanya Saldo Utama -5.000.000.
Arsip dompet (BR-43): Tunai bersaldo 1.250.000 tidak dapat diarsipkan; setelah Rp 1.250.000 ditransfer ke Saldo Utama, saldo Tunai 0 dan dompet dapat diarsipkan; Total Saldo tetap Rp 24.750.000.

### C.8 Idempotensi (BR-40)
Pengguna menekan "Simpan Pembayaran" Rp 500.000; respons hilang karena jaringan putus. Klien mengulang dengan `client_request_id` yang sama: server mengembalikan hasil pembayaran pertama, sisa tetap 1.500.000 (bukan 1.000.000), hanya satu transaksi `debt_payment`. Bila id yang sama dikirim dengan nominal 400.000, server menolak (`request_id_reuse`).
Pesan chat dengan `client_request_id` sama yang dikirim dua kali memotong kuota chat satu kali (50 per hari).

### C.9 Zona waktu (BR-42)
Transaksi pukul 23.30 WIB tanggal 31 Oktober 2026 (16.30 UTC): pengguna `Asia/Jakarta` melihatnya di bulan Oktober; pengguna `Asia/Makassar` (WITA, UTC+8) melihatnya pukul 00.30 tanggal 1 November, jadi masuk bulan November. Kuota harian pengguna WITA direset pukul 00.00 WITA, bukan pukul 00.00 WIB. Sisa hari anggaran pada 9 November di kedua zona dihitung dari tanggal kalender zona masing-masing.
