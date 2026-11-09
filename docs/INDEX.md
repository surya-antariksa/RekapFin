# Dokumentasi RekapFin: Daftar Isi

> Ringkasan: kumpulan dokumen produk dan teknis RekapFin (aplikasi pelacak keuangan pribadi, Flutter + Supabase) yang disusun dari analisis RekapFin.pen dan keputusan pemilik produk. Tidak ada kode di sini, hanya dokumen. Informasi berlabel [DESAIN] (terbaca dari file), [ASUMSI] (simpulan analis), atau [PERLU KEPUTUSAN]. Keputusan OI-01 sampai OI-57 sudah dimasukkan; empat butir Tertunda (OI-58 sampai OI-61) dan tindak lanjut terjadwal ada di OPEN_ISSUES bagian H dan G.

Tanggal analisis: 9 November 2026. Sumber desain: `RekapFin.pen` (43 layar produk 390 x 844 ditambah halaman dokumentasi dan komponen; 96 node tingkat atas pada 9 November 2026) dibaca lewat MCP pen.dev; dokumen tidak mengubah file itu. Perubahan yang perlu dilakukan di .pen ada di dokumen 11, status per layar di 14.

**Lokasi RekapFin.pen:** tidak ada di repo. File dibuka di aplikasi pen.dev dan tersimpan di `~/.pencil/documents/<uuid>/RekapFin.pen` pada mesin pemilik produk; isinya terenkripsi sehingga hanya terbaca lewat MCP Pencil (alat `mcp__pencil__*`), tidak lewat Read atau Grep. Ekspor PNG 46 layar dan halaman untuk rujukan visual ada di [design/](design/README.md) (skala 1, tanggal ekspor tercatat di sana). Agen yang tidak punya MCP Pencil memakai ekspor itu, 03, dan 08, dan tidak boleh mengubah desain (CLAUDE.md).

## Daftar dokumen dan status
| Dokumen | Isi | Status |
|---|---|---|
| [00-analisis-desain.md](00-analisis-desain.md) | Hasil analisis file .pen: jumlah frame, section, komponen, token, temuan (kondisi file apa adanya) | Draft (kondisi pembacaan pertama; tidak berubah) |
| [01-PRD.md](01-PRD.md) | Masalah, tujuan, persona, ruang lingkup per fase, metrik, di luar cakupan, risiko | Diperbarui; metrik awal sebagai target awal |
| [02-user-stories.md](02-user-stories.md) | User story dan kriteria penerimaan Given/When/Then dengan ID | Diperbarui |
| [03-inventaris-layar.md](03-inventaris-layar.md) | Tabel semua layar dan varian, termasuk 24 layar, sheet, dialog, dan state baru | Diperbarui; set demo disetujui |
| [04-alur-pengguna.md](04-alur-pengguna.md) | Alur utama dalam diagram Mermaid | Diperbarui (navigasi [ASUMSI]) |
| [05-aturan-bisnis.md](05-aturan-bisnis.md) | BR-01 sampai BR-47 dengan contoh hitungan | Diperbarui (audit: BR-39 sampai BR-46; BR-47 persetujuan AI); nilai awal [ASUMSI] di BR-19, BR-21, BR-34, BR-35 |
| [06-model-data.md](06-model-data.md) | Entitas, ERD tanpa siklus, FK komposit, matriks CHECK, rumus saldo, RLS dan kelas tulis, view, indeks, RPC berversi | Diperbarui (audit dan penutupan OI-38 sampai OI-49) |
| [07-arsitektur.md](07-arsitektur.md) | Stack, folder, OCR, chatbot, Edge Function, validasi LLM, keamanan, batas AI, hapus akun, tanpa jaringan, zona waktu, migrasi dan rahasia | Diperbarui (audit dan penutupan OI-38 sampai OI-49) |
| [08-design-system.md](08-design-system.md) | Token, tipografi, efek kaca, komponen, aturan layout, perubahan token | Disinkronkan dengan RekapFin.pen terkini (OI-55): nilai token, aturan layout scroll |
| [09-roadmap.md](09-roadmap.md) | Fase 0 sampai 8, dependensi, DoD, kompleksitas | Diperbarui |
| [10-test-plan.md](10-test-plan.md) | Strategi uji, skenario kritis, data uji | Diperbarui |
| [11-perubahan-pen.md](11-perubahan-pen.md) | Daftar perubahan untuk pen.dev sebagai prompt siap tempel | Disinkronkan dengan .pen terkini; P2-1 dan P2-1b sudah diterapkan, P2-2b baru |
| [12-build-plan.md](12-build-plan.md) | Urutan modul SQL (migrasi), Edge, dan Flutter fase 0 sampai 3 beserta definisi selesai | Diperbarui; generator data sintetis di S05; DoD purge per modul |
| [13-sprint-plan.md](13-sprint-plan.md) | Rencana sprint mingguan (33 sprint, 245 poin [ASUMSI]), aturan kerja, backlog, dependensi, risiko, dan tabel pelacakan | Baru; kapasitas dikalibrasi setelah Sprint 1 dan 2 |
| [14-status-desain.md](14-status-desain.md) | Status RekapFin.pen terhadap 03 dan 11: ADA & SESUAI, PERLU KOREKSI, BELUM ADA, urutan per sprint, dan pemblokir Sprint 0 sampai 3 | Diregenerasi terhadap .pen terkini (9 Nov 2026) |
| [OPEN_ISSUES.md](OPEN_ISSUES.md) | Masalah desain, keputusan (status Diputuskan), set data demo yang disetujui, tindak lanjut terjadwal | OI-01 sampai OI-57 Diputuskan; OI-58 sampai OI-61 Tertunda (bagian H); tindak lanjut terjadwal di bagian G |
| [../CLAUDE.md](../CLAUDE.md) | Aturan tetap untuk agen coding | Diperbarui |

## Cara membaca
1. Mulai dari ringkasan 3 sampai 5 baris di setiap dokumen.
2. Pemilik produk: OPEN_ISSUES bagian G (tindak lanjut terjadwal) → bagian C (set data demo) → 11 → 13.
3. Desainer: 11 → 03 → 08 → 00 (urutan desain per sprint ada di 13 bagian 5.1).
4. Pengembang: CLAUDE.md → 07 → 06 → 05 → 03 → 04 → 02 → 10 → 09 → 12 → 13.
5. Rujukan silang memakai ID: OI-xx (isu), BR-xx (aturan), AUT/PRF/WAL/TRX/BGT/ANL/SCN/DBT/NET/INV/SIN/AIC-xx (user story).
6. Bila dokumen bertentangan, urutan prioritas: keputusan di OPEN_ISSUES → 05-aturan-bisnis → dokumen lain. Pengecualian untuk nilai visual (warna, ukuran, radius, token): RekapFin.pen terkini yang benar (OI-55), dan 08 menyalinnya. Layar produk di .pen belum semuanya mengikuti keputusan isi/teks (lihat 14); untuk isi dan teks, ikuti 03 dan 11, bukan .pen.

## Konvensi
- Bahasa Indonesia; nama layar dan route persis seperti di desain, mis. "Hutang & Piutang (/debts)"; route layar baru bertanda [ASUMSI nama].
- Nominal rupiah utuh, tampil "Rp 1.250.000".
- Ide di luar desain tidak masuk cakupan; dicatat di bagian Usulan OPEN_ISSUES.
- Memperbarui dokumen: ubah status di tabel ini bila ada perubahan.

## Glosarium
| Istilah | Arti |
|---|---|
| Pemilik produk | Pengambil keputusan produk (pemilik proyek). Semua status "Diputuskan" berasal darinya. Push, perubahan desain, dan keputusan Tertunda ada di tangannya. |
| Pengembang | Orang yang menjalankan sprint, dibantu agen coding. Bisa orang yang sama dengan pemilik produk. |
| Analis | Penyusun dokumen ini (tahap analisis dan perencanaan); tidak mengambil keputusan produk. |
| Desainer | Pihak yang mengubah RekapFin.pen di pen.dev. |
| Kode modul S | Modul SQL (migrasi dan tes pgTAP), mis. S05 Transaksi inti. Kode S02 dan seterusnya memakai penomoran 12-build-plan. |
| Kode modul F | Modul Flutter, mis. F23 Tambah/Edit/Hapus Transaksi. |
| Kode modul E | Modul Edge Function (Deno/TypeScript), mis. E02 ocr-parse. |
| Kode X | Pekerjaan non-fitur (keystore, cadangan, ikon, teks hukum, beta, build rilis), mis. X-04. |
| Kode D | Pekerjaan desain di pen.dev, mis. D-01 token; tiap D merujuk prompt di 11. D-15 sampai D-19 ditambahkan untuk dialog dan halaman yang sebelumnya tanpa item. |
| Sprint | Satu minggu kerja (mulai Senin), dinomori dari 0; kapasitas 8 poin [ASUMSI]. |
| Gerbang | Titik akhir fase: semua DoD fase lulus sebelum fase berikutnya dibuka. |
| ID tes T-xxx-nn | Skenario tes di 10, mis. T-RLS-01 (RLS), T-WAL (dompet), T-CNS (persetujuan AI), T-DEL (hapus akun). |
| Kelas A / kelas B | Tabel kelas A hanya ditulis lewat RPC `SECURITY DEFINER` berversi (wallets, transactions, debts, dan lainnya); tabel kelas B (profiles dengan hak kolom, categories, contacts, chat_sessions, chat_messages) ditulis langsung di bawah RLS. Daftar di 06 bagian 1. |
| Keputusan audit N | Salah satu dari 13 keputusan audit arsitektur di [OPEN_ISSUES bagian F](OPEN_ISSUES.md#f-keputusan-audit-arsitektur-diterapkan-di-dokumen). |
| [DESAIN] | Nilai terbaca dari RekapFin.pen. |
| [ASUMSI] | Usulan atau perkiraan analis yang belum dikonfirmasi pemilik produk; boleh dipakai sebagai nilai awal. |
| [DIPUTUSKAN] | Keputusan pemilik produk yang belum tentu sudah ada di .pen. |
| [PROVISIONAL] | Modul atau jadwal fase 4 sampai 8 di 13 yang belum dipecah di 12; berlaku sampai 12 diperluas (sebelum Sprint 17). |
| [TERTUNDA] | Belum diputuskan; tercatat di OPEN_ISSUES bagian H dengan pemilik dan tenggat. |
| [PERLU KEPUTUSAN] | Label lama pada teks yang ditulis sebelum butirnya diputuskan; tidak ada lagi butir yang menunggu selain bagian H. |
| DoD / DoR | Definition of Done / Ready (13 bagian 2). |
| BR-xx, OI-xx | Aturan bisnis (05) dan butir keputusan (OPEN_ISSUES). |
