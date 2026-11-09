# 02. User Story dan Kriteria Penerimaan

> Ringkasan: user story per fitur dengan ID (AUT, PRF, WAL, TRX, BGT, ANL, SCN, DBT, NET, INV, SIN, AIC) dan kriteria penerimaan Given/When/Then. Cakupan mengikuti desain RekapFin.pen ditambah layar yang diwajibkan keputusan pemilik produk (dompet, transfer, detail/edit transaksi, atur anggaran, lupa kata sandi, pengaturan). Aturan bisnis dirujuk sebagai BR-xx dari [05-aturan-bisnis.md](05-aturan-bisnis.md). Layar dirujuk dari [03-inventaris-layar.md](03-inventaris-layar.md).

Status: Diperbarui setelah keputusan OI-01 sampai OI-25. Fase mengikuti [09-roadmap.md](09-roadmap.md). Story yang ditunda ditandai "Ditunda". Label [ASUMSI] dipakai di tempat yang belum pasti.

## AUT: Autentikasi (fase 1)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| AUT-01 | Sebagai pengguna baru, saya mendaftar dengan nama, email, nomor HP, kata sandi agar punya akun. | Given form Daftar terisi valid dan syarat dicentang, When tekan "Daftar", Then akun dibuat dan masuk ke /home. Given syarat belum dicentang, Then tombol Daftar tidak aktif [ASUMSI]. Given kata sandi diketik, Then indikator kekuatan (mis. "Kuat") tampil. |
| AUT-02 | Sebagai pengguna, saya masuk dengan email dan kata sandi. | Given kredensial benar, When "Masuk", Then ke /home. Given kredensial salah, Then tampil "Email atau kata sandi salah" dengan ikon error. Given permintaan berjalan, Then tombol berlabel "Memproses..." dan tidak dapat ditekan dua kali. |
| AUT-03 | Sebagai pengguna, saya masuk dengan Google (rilis Android). Sign in with Apple menyusul bersama rilis iOS (OI-51). | Given penyedia dipilih dan berhasil, Then masuk ke /home. Given dibatalkan, Then tetap di layar tanpa error. |
| AUT-04 | Sebagai pengguna, saya mengaktifkan biometrik (Face ID di iOS) dari Pengaturan (opsional, bawaan mati) dan membuka sesi tersimpan dengannya. | Given Face ID diaktifkan di /settings dan perangkat mendukung biometrik, When "Masuk dengan Biometrik" lolos, Then ke /home. Given belum diaktifkan atau tidak ada sesi tersimpan, Then opsi tidak tampil atau meminta masuk biasa (OI-25, BR-36). |
| AUT-05 | Sebagai pengguna, saya mereset kata sandi. | Given email terdaftar, When "Lupa kata sandi?" lalu "Kirim Tautan Reset" di /forgot-password, Then tautan reset dikirim dan tampil state terkirim. Given email tidak valid, Then error. Layar wajib MVP (OI-17). |
| AUT-06 | Sebagai pengguna, saya keluar. | Given di /profile, When "Keluar" dikonfirmasi, Then sesi dihapus dan kembali ke /login. |
| AUT-07 | Sebagai pengguna baru, saya mengisi saldo awal saat onboarding atau melewatinya. | Given akun baru selesai mendaftar, When di /onboarding mengisi nominal lalu "Lanjut", Then saldo awal Saldo Utama tersimpan. Given "Lewati", Then saldo awal Rp 0 dan dapat diubah di /wallets (OI-08). |

## PRF: Profil (fase 1)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| PRF-01 | Saya melihat profil dan statistik. | Given masuk, Then tampil nama, email, "Akun Gratis", jumlah transaksi, total saldo, lama aktif. |
| PRF-02 | Saya mengubah nama, nomor HP, tanggal lahir, foto. | Given data valid, When "Simpan Perubahan", Then tersimpan dan tampil di /profile. Email tidak dapat diubah di desain [ASUMSI]. |
| PRF-03 | Saya menghapus akun. | Given "Hapus Akun" dikonfirmasi dengan dialog, Then semua data pengguna terhapus (BR-29) dan sesi berakhir. Dialog belum didesain. |
| PRF-04 | Saya mengatur Face ID dan "Simpan foto nota" di Pengaturan. | Given /settings, When toggle diubah, Then tersimpan (keduanya bawaan mati; OI-10, OI-25). |
| PRF-05 | Saya mengatur notifikasi, kategori, ekspor data, bantuan. **Ditunda ke backlog pasca-rilis.** | Notifikasi, Kategori Saya, Ekspor Data, dan Bantuan tidak ada di MVP maupun fase lanjutan sampai setelah rilis (OI-17, OI-30). |

## WAL: Dompet (fase 1/2)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| WAL-01 | Saya melihat daftar dompet dan Total Saldo. | Given tiga dompet (Saldo Utama Bank 18.500.000, Tunai 1.250.000, E-wallet 5.000.000), Then /wallets menampilkan Total Saldo Rp 24.750.000 = jumlah semua dompet; nilai investasi tidak ikut (BR-30). |
| WAL-02 | Saya menambah, mengubah, dan mengarsipkan dompet. | Given nama, jenis (Tunai, Bank, E-wallet), saldo awal, When "Simpan", Then dompet muncul. Dompet berisi transaksi hanya dapat diarsipkan [ASUMSI, OI-31]. |
| WAL-03 | Saya mengubah saldo awal. | Given /wallets, When saldo awal diubah, Then saldo dompet dan Total Saldo dihitung ulang. |
| WAL-04 | Saya memindahkan saldo antar dompet (Transfer). | Given /transfer, dompet asal dan tujuan berbeda, nominal > 0, When "Simpan Transfer", Then satu transaksi `transfer`; saldo asal turun, saldo tujuan naik, Total Saldo tetap, Analitik tidak berubah (BR-32). Given asal = tujuan, Then error. |
| WAL-05 | Saya memindahkan saldo ke Investasi. | Given /transfer dengan "Ke: Investasi", Then diarahkan ke /add-investment dengan nominal dan sumber dana terbawa; hasil akhirnya transfer `source = 'investment'` (BR-03). |

## TRX: Transaksi (fase 2)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| TRX-01 | Saya mencatat pengeluaran dengan nominal, dompet, kategori, tanggal, catatan. | Given nominal lebih dari 0, dompet (bawaan Saldo Utama), dan kategori dari 8 kategori pengeluaran, When "Simpan Transaksi", Then transaksi expense tersimpan dengan nominal bigint rupiah (BR-01), saldo dompet dan Total Saldo berkurang, dan muncul di daftar. Given nominal 0, Then tombol simpan tidak aktif. |
| TRX-02 | Saya mencatat pemasukan. | Given tab Pemasukan dan kategori (Gaji, Bonus, dst.), When simpan, Then income tersimpan dan saldo bertambah. |
| TRX-03 | Saya memasukkan nominal lewat keypad. | Given keypad (1-9, 0, 000, hapus), When tekan, Then nominal tampil format "Rp 45.000" (BR-02) dan tidak menerima desimal. |
| TRX-04 | Saya melihat daftar transaksi dikelompokkan per hari. | Given transaksi ada, Then dikelompokkan "Hari Ini", "Kemarin", tanggal; header memuat total bersih hari itu (mis. -Rp 85.000). Warna: expense merah, income hijau. Transfer, hutang, dan pembayaran hutang tampil dengan label sumber (BR-26, BR-37). |
| TRX-05 | Saya mencari dan memfilter. | Given kata kunci atau chip (Semua, Pemasukan, Pengeluaran, kategori), Then daftar menyaring catatan/merchant. |
| TRX-06 | Saya melihat ringkasan di Beranda. | Given bulan berjalan, Then tampil Total Saldo (jumlah dompet), Pemasukan dan Pengeluaran bulan ini (BR-04), lima transaksi terbaru, kartu Hutang & Piutang dan Investasi. |
| TRX-07 | Saya melihat, mengubah, atau menghapus transaksi. | Given tap baris, Then /transaction-detail. Given transaksi manual/scan/chat, When Ubah lalu Simpan, Then perubahan tersimpan dan saldo dihitung ulang; When Hapus dan konfirmasi, Then terhapus. Given source debt/debt_payment/investment, Then hanya tautan ke catatan induk (BR-38). Layar wajib MVP. |
| TRX-08 | Saya tidak dapat memilih kategori Investasi pada pengeluaran. | Given tab Pengeluaran, Then daftar kategori 8 item tanpa "Investasi". Investasi dicatat lewat /transfer atau /investments (BR-03, OI-06). |
| TRX-09 | Saya mencatat transfer. | Aksi Cepat "Transfer" membuka /transfer; lihat WAL-04 dan WAL-05. |

## BGT: Anggaran (fase 3)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| BGT-01 | Saya melihat anggaran bulan ini. | Given Total Anggaran Rp 6.000.000 dan terpakai Rp 5.230.000 (set demo disetujui, OI-26), Then tampil Terpakai, Sisa Rp 770.000, ring 87% berwarna amber, chip "21 hari tersisa". Terpakai total mencakup kategori tanpa anggaran dan tidak mencakup source debt/debt_payment atau transfer (BR-22, BR-04). |
| BGT-02 | Saya melihat anggaran per kategori dengan warna status. | Given batas kategori, Then tampil "Rp 1.990.000 / Rp 2.400.000", "83% terpakai", "Sisa Rp 410.000" (amber). Kurang dari 70% hijau, 70% sampai 90% amber, lebih dari 90% merah; 90% sampai 100% "Hampir melebihi batas!", di atas 100% "Melebihi batas" (BR-22, BR-35). |
| BGT-03 | Saya mengganti bulan. | Given pemilih bulan, When bulan lain dipilih, Then data bulan itu tampil. |
| BGT-04 | Saya mengatur anggaran. | Given /budget-edit, total dan batas per kategori; When jumlah batas kategori melebihi Total Anggaran, Then ditolak dengan pesan dan tombol Simpan tidak aktif; kategori tanpa batas diperbolehkan (OI-11). Layar wajib MVP. |

## ANL: Analitik (fase 3)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| ANL-01 | Saya melihat pengeluaran per kategori. | Given periode, Then donut dan legenda persen; hanya expense dengan source bukan debt/debt_payment yang dihitung (BR-04); transfer (termasuk investasi) tidak masuk. |
| ANL-02 | Saya melihat arus kas. | Given toggle 1/3/6 bulan ("Bulan Ini", "3 Bulan", "6 Bulan"), Then grafik area pemasukan dan pengeluaran per bulan; tooltip "Selisih +Rp 3,7 jt". |
| ANL-03 | Saya membaca insight. | Given data, Then kalimat seperti "Makanan naik 12% dari bulan lalu." dihitung dari data [ASUMSI]. |

## SCN: Scan Nota (fase 4)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| SCN-01 | Saya memotret nota. | Given izin kamera, Then pratinjau dengan bingkai dan pill "Deteksi otomatis aktif"; ada flash dan galeri. |
| SCN-02 | Saya melihat proses baca. | Given foto diambil, Then kartu "Membaca nota..." dengan tahap Mendeteksi teks, Mengenali item, Menentukan kategori. |
| SCN-03 | Saya memeriksa hasil. | Given hasil, Then tampil Merchant, Tanggal, Kategori ("Disarankan AI"), Total, rincian item, subtotal, pajak, "Akurasi 96%". Given keyakinan field di bawah 85%, Then tag amber "Periksa kembali" (BR-12). |
| SCN-04 | Saya diperingatkan bila angka tidak cocok. | Given jumlah item tidak sama subtotal atau subtotal + pajak tidak sama total, Then fallback vision dicoba satu kali; bila masih tidak cocok, total ditandai amber (BR-13, BR-14). |
| SCN-05 | Saya menyimpan hasil. | Given "Simpan Transaksi" dan dompet, Then transaksi expense dibuat dengan item; gambar dihapus setelah dibaca kecuali "Simpan foto nota" aktif di Pengaturan (bawaan mati); teks mentah OCR tidak disimpan (BR-15, OI-10). |
| SCN-08 | Saya dibatasi 20 scan per hari. | Given 20 scan hari ini, Then scan ke-21 ditolak dengan pesan jelas dan "Ketik Manual" tetap tersedia (BR-28). |
| SCN-09 | Saya menyetujui pemrosesan AI sebelum memakai fitur AI. | Given belum ada persetujuan, When membuka scan atau chat pertama kali, Then dialog persetujuan menyebut Google sebagai pemroses; Setuju mencatat persetujuan; Tolak membuka input manual; server menolak operasi AI tanpa persetujuan (BR-47). |
| SCN-06 | Saya mengisi manual bila scan gagal. | Given "Ketik Manual", Then ke form Tambah Transaksi. |
| SCN-07 | Saya mengulang scan. | "Foto Ulang" dan "Scan Nota Lain" kembali ke /scan. |

## DBT: Hutang & Piutang (fase 5)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| DBT-01 | Saya melihat ringkasan dan daftar. | Given data contoh, Then Total Hutang Saya Rp 2.750.000 (3 orang), Total Piutang Rp 6.100.000 (5 orang), "Saldo bersih kamu: +Rp 3.350.000" (BR-24); tab Hutang Saya/Piutang; filter Semua, Belum Lunas, Jatuh Tempo, Lunas. |
| DBT-02 | Saya menambah piutang atau hutang. | Given nama (dipilih dari contacts atau diketik), nominal, tanggal pinjam, opsional jatuh tempo, catatan, pengingat (H-3), cicilan, "Catat ke saldo & transaksi" (dengan Dompet), When "Simpan", Then catatan dibuat dengan contact_id. Given nama yang diketik sama dengan kontak yang ada, Then dialog "Pakai kontak ini" / "Buat kontak baru" (BR-08). Given kontak punya catatan lawan, Then pesan timbal balik dengan arah benar tampil, mis. "Kamu punya piutang Rp 2.000.000 ke Budi. Akan dihitung saling hapus." (OI-15). |
| DBT-03 | Saya melihat detail catatan. | Then Total, Terbayar, Sisa, persen terbayar, Informasi, Riwayat Pembayaran, aksi (Catat Pembayaran/Bayar Cicilan, Edit, Hapus; "Kirim Pengingat" via WhatsApp ditunda, OI-22). |
| DBT-04 | Saya mencatat pembayaran. | Given nominal tidak lebih dari sisa, When "Simpan Pembayaran", Then terbayar bertambah dan sisa berkurang; "Bayar Lunas" mengisi sisa; "Setengah" mengisi separuh (dibulatkan ke bawah [ASUMSI]); metode Tunai/Transfer/E-wallet. Given nominal melebihi sisa, Then ditolak. |
| DBT-05 | Saya memilih mencatat pembayaran ke transaksi. | Given toggle "Catat ke transaksi" aktif dan dompet dipilih, Then piutang dibayar membuat income dan bayar hutang membuat expense, `source = 'debt_payment'`, dan keduanya tidak masuk Analitik (BR-09, BR-04). Given hutang atau piutang baru dengan toggle "Catat ke saldo & transaksi" aktif, Then transaksi `source = 'debt'`: hutang baru income, piutang baru expense, di luar Analitik (BR-33). |
| DBT-06 | Saya melihat status lunas. | Given sisa 0, Then badge "Lunas" dan 100% terbayar. |
| DBT-07 | Saya menerima pengingat jatuh tempo. Pengiriman WhatsApp: Ditunda (OI-22). | Given catatan dengan jatuh tempo dan sisa > 0, Then notifikasi lokal pada H-3 (dapat diubah di form) dan hari-H; dijadwalkan ulang bila catatan diubah atau lunas membatalkannya (BR-27). |
| DBT-08 | Saya melihat status jatuh tempo. | Given 0 sampai 3 hari: "Jatuh tempo N hari lagi"; lewat: "Terlambat N hari"; tanpa tanggal: "Belum lunas"; lain: tanggal absolut, mis. Pak Hendra "Jatuh tempo 30 Nov 2026" (OI-05, OI-37) [ASUMSI]. |

## NET: Saling hapus (fase 5)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| NET-01 | Saya melihat saldo bersih per orang. | Given kontak punya piutang dan hutang, Then /debt-net menampilkan "X berhutang ke kamu" / "Kamu berhutang ke X" / "Impas", nilai bersih, rumus, dan pratinjau "Setelah saling hapus" (BR-06). |
| NET-02 | Saya mengonfirmasi saling hapus. | Given Budi piutang 2.000.000 dan hutang 750.000, When "Saling Hapus Rp 750.000" dan "Konfirmasi Saling Hapus", Then hutang jadi Lunas, piutang jadi 1.250.000, saldo dompet tidak berubah, tidak ada transaksi baru, riwayat "Saling hapus" tercatat (BR-07). Given kontak punya beberapa catatan, Then nilai dialokasikan FIFO jatuh tempo terdekat di kedua sisi (BR-34). |
| NET-03 | Saya menyelesaikan saat impas. | Given piutang sama dengan hutang (Kak Rina 500.000), When "Selesaikan Semua", Then keduanya Lunas. |
| NET-04 | Saya menyelesaikan saat kamu berhutang. | Given Pak Hendra piutang 400.000, hutang 1.500.000, Then saling hapus 400.000, hutang menjadi 1.100.000, piutang Lunas. |
| NET-05 | Saya melihat riwayat saling hapus. **Ditunda** (OI-17). | Layar riwayat di luar MVP; kejadian tetap tercatat di basis data; tombol "Lihat Riwayat" disembunyikan di MVP. |
| NET-06 | Saya mengakses dari detail. | Tombol "Lihat & Saling Hapus" menuju /debt-net (OI-02). |
| NET-07 | Saling hapus aman dari ganda. | Given dua permintaan bersamaan, Then hanya satu berhasil (idempotensi dan kunci baris). |

## INV: Investasi (fase 6)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| INV-01 | Saya melihat portofolio. | Given data contoh, Then Total Nilai Rp 12.930.000, +Rp 290.000 (+2,3%), Modal Rp 12.640.000, alokasi 39,6/37,7/22,7%, daftar aset dengan persen (BR-23). |
| INV-02 | Saya memfilter aset. | Chip Semua, Reksa Dana, Emas, Saham, Lainnya. |
| INV-03 | Saya menambah aset manual. | Given jenis, nama, platform, nominal modal, unit/gram, tanggal beli, nilai sekarang opsional, When "Simpan", Then aset dan pembelian tercatat; bila "Catat sebagai transfer dari saldo" aktif, Then transfer dari dompet terpilih ke aset dibuat (`transfer`, `source = 'investment'`), bukan expense (BR-03); Total Saldo turun sebesar nominal. |
| INV-04 | Saya melihat detail aset. | Then nilai saat ini, untung/rugi (hijau/merah), modal, grafik 1B/3B/6B, informasi (platform, unit, harga beli rata-rata, harga hari ini), riwayat transaksi. |
| INV-05 | Saya menambah pembelian dan memperbarui nilai. | Given "Tambah Pembelian"/"Perbarui Nilai" (belum didesain, OI-17), Then harga beli rata-rata dan nilai diperbarui. |
| INV-06 | Keadaan kosong. | Given tidak ada aset, Then semua Rp 0 dan ajakan "Scan screenshot pertamamu". |

## SIN: Scan Investasi (fase 6)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| SIN-01 | Saya mengunggah screenshot. | Given pilih satu atau beberapa gambar dan opsional platform (Bibit, Tokopedia Emas, Pegadaian, Pluang, Lainnya; kelimanya didukung, OI-23), When "Baca Screenshot", Then proses "Membaca screenshot..." (Mendeteksi platform, Membaca nominal dan unit, Mencocokkan aset). |
| SIN-02 | Saya memeriksa hasil. | Then Platform, Jenis ("Disarankan AI"), Nama, Tanggal, Nominal, Jumlah unit atau Berat dan Harga per gram, Akurasi; field keyakinan rendah ditandai "Periksa kembali". |
| SIN-03 | Saya menyimpan ke portofolio. | Given "Simpan ke Portofolio" dan Sumber dana (dompet), Then dicatat sebagai `transfer` `source = 'investment'` dari dompet itu (bukan pengeluaran) dengan penjelasan "Tidak akan dihitung sebagai pengeluaran di Analitik." |
| SIN-04 | Saya diarahkan dari Scan Nota. | Segmen "Investasi" di /scan menuju /scan-investment (OI-02). |

## AIC: Asisten AI (fase 7)
| ID | Story | Kriteria penerimaan |
|---|---|---|
| AIC-01 | Saya bertanya tentang keuangan. | Given "Pengeluaran makanan bulan ini berapa?", Then jawaban berisi angka dari data pengguna (set usulan: Rp 1.990.000 atau 83% dari anggaran Rp 2.400.000), bukan karangan, dan memakai aturan hitung Analitik (BR-04). |
| AIC-02 | Saya mencatat lewat percakapan. | Given "Catat makan siang 45rb di Warteg", Then kartu "Konfirmasi transaksi" (Warteg, -Rp 45.000, Makanan, Hari ini) dengan "Simpan" dan "Ubah"; tidak ada tulis ke database sebelum "Simpan" (BR-17). |
| AIC-03 | Saya memakai saran cepat. | Chip: Ringkasan minggu ini, Tips hemat, Scan nota, Siapa yang belum bayar?, Berapa untung investasiku?, Hitung saldo bersih dengan Budi. |
| AIC-04 | Saya dibatasi pemakaian. | Given 50 pesan hari ini (dapat dikonfigurasi), Then pesan ke-51 ditolak dengan penjelasan dan input dinonaktifkan sementara (BR-28, OI-09). |
| AIC-05 | Saya mengirim foto/suara. | Kamera menuju /scan [ASUMSI]; mikrofon Ditunda (OI-20). |
