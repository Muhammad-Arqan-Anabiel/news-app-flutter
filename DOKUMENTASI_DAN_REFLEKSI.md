# DOKUMENTASI DAN JAWABAN TUGAS REFLEKSI (PERTEMUAN 1 - 5)
**SMK IDN — Modul Pembelajaran Pemrograman Mobile: News App Flutter**

---

## 📋 Bagian I: Matriks Checklist Keberhasilan

| No | Kriteria Praktik | Status | Keterangan Verifikasi |
|---|---|---|---|
| 1 | Project Flutter terkonfigurasi & berjalan lancar | ✅ Terpenuhi | Menggunakan Flutter SDK dengan Material 3 |
| 2 | Model `Article` lengkap dengan parsing null-safe | ✅ Terpenuhi | Terdapat fallback nilai default pada operator `??` |
| 3 | `NewsService` mengambil berita dari NewsAPI | ✅ Terpenuhi | Terintegrasi endpoint `/v2/top-headlines` & `/v2/everything` |
| 4 | Kategori berita (7 kategori) aktif & dinamis | ✅ Terpenuhi | Berita ter-update saat kategori diubah |
| 5 | Pencarian berita API berfungsi | ✅ Terpenuhi | Input kata kunci memanggil endpoint pencarian API |
| 6 | Filter lokal judul berita berfungsi instan | ✅ Terpenuhi | Menggunakan `filterByTitle` di sisi klien tanpa request baru |
| 7 | Halaman detail menerima objek `Article` dinamis | ✅ Terpenuhi | Objek dikirim via constructor saat kartu diketuk |
| 8 | Navigasi kembali (`Navigator.pop`) berjalan | ✅ Terpenuhi | Tombol kembali di AppBar berfungsi sempurna |
| 9 | Fitur "Baca Artikel Asli" membuka browser | ✅ Terpenuhi | Menggunakan package `url_launcher` dengan validasi skema |
| 10 | Penanganan 4 kondisi UI (Loading, Error, Empty, Success) | ✅ Terpenuhi | Indikator loading, penanganan offline, dan pesan kosong |
| 11 | Tombol "Coba Lagi" mengulang request aktif | ✅ Terpenuhi | Mengulang kategori aktif atau pencarian aktif |
| 12 | Keamanan API Key dengan `.env` & `flutter_dotenv` | ✅ Terpenuhi | API key dipisahkan, `.env` di-ignore oleh Git, ada `.env.example` |

---

## 🧪 Bagian II: Lembar Pengujian Sistematis (10 Skenario Pertemuan 4)

| No | Skenario Pengujian | Langkah Pengujian | Hasil yang Diharapkan | Hasil Pengujian Aktual | Status |
|---|---|---|---|---|---|
| 1 | **Berita Utama** | Buka aplikasi pada pertama kali | Daftar berita kategori umum muncul dengan indikator loading di awal | Berita umum berhasil dimuat dan tampil dalam ListView | **LULUS** |
| 2 | **Kategori Berita** | Ketuk chip "Teknologi" atau "Olahraga" | Daftar berita berganti sesuai kategori yang dipilih | Berita kategori baru berhasil di-fetch dan ditampilkan | **LULUS** |
| 3 | **Pencarian API** | Ketik kata kunci "Artificial Intelligence" lalu tekan enter/cari | Menampilkan artikel hasil pencarian dari endpoint everything | Berita relevan muncul sesuai kata kunci pencarian | **LULUS** |
| 4 | **Filter Lokal** | Ketik sebagian judul pada kolom "Filter judul berita" | Daftar berita langsung tersaring secara instan tanpa reload API | Judul yang cocok langsung terfilter secara *real-time* | **LULUS** |
| 5 | **Buka Halaman Detail** | Ketuk salah satu kartu berita | Terbuka halaman detail dengan judul, tanggal, gambar, & sumber sesuai berita tersebut | Konten detail sama persis dengan berita yang diketuk | **LULUS** |
| 6 | **Navigasi Kembali** | Tekan tombol kembali di AppBar halaman detail | Kembali ke daftar berita di halaman utama tanpa me-reset state | Layar kembali ke daftar berita dengan posisi semula | **LULUS** |
| 7 | **Data Kosong** | Cari kata kunci acak yang tidak masuk akal (misal: "xyzqwertyuiop123") | Menampilkan pesan "Berita tidak ditemukan." | Teks data kosong muncul di tengah layar | **LULUS** |
| 8 | **Error Jaringan / API Key Belum Diisi** | Kosongkan API key pada `.env` atau putuskan internet | Muncul ikon offline, pesan error informatif, dan tombol Coba Lagi | Error tertangkap ramah dan tombol Coba Lagi tersedia | **LULUS** |
| 9 | **Tombol Coba Lagi** | Perbaiki koneksi/isi API key lalu tekan tombol "Coba Lagi" | Permintaan diulang sesuai kategori/pencarian yang aktif | Future dipanggil ulang dan berita berhasil dimuat | **LULUS** |
| 10 | **Gambar Rusak / Kosong** | Tampilkan berita yang memiliki URL gambar tidak valid | Aplikasi tidak crash; widget fallback ikon broken_image muncul | ErrorBuilder menangani gambar rusak secara anggun | **LULUS** |

---

## 📝 Bagian III: Jawaban Lengkap Tugas Refleksi Mandiri

### 🔹 Pertemuan 1: Mengambil dan Menampilkan Berita dari NewsAPI
1. **Jelaskan alur data dari NewsAPI sampai tampil di layar.**  
   *Jawaban:*  
   Alur dimulai ketika aplikasi mengirimkan HTTP GET Request ke server NewsAPI via `NewsService`. Server merespons dengan teks berformat JSON. `NewsService` melakukan deserialisasi teks JSON menjadi `Map<String, dynamic>` menggunakan `jsonDecode()`, lalu memetakan daftar objek JSON ke dalam bentuk `List<Article>` melalui factory constructor `Article.fromJson()`. Data `Future<List<Article>>` tersebut diterima oleh widget `FutureBuilder` di `NewsPage`. Saat status koneksi selesai (`ConnectionState.done`) dan data tersedia, `FutureBuilder` membangun antarmuka daftar berita menggunakan widget `ListView.builder`.

2. **Apa fungsi class Article dan method Article.fromJson()?**  
   *Jawaban:*  
   Class `Article` berfungsi sebagai model data (*type-safe data model*) yang merepresentasikan satu entitas berita dengan tipe data yang jelas di Dart (seperti String title, imageUrl, dsb). Method `Article.fromJson()` adalah sebuah *factory constructor* yang bertugas membaca key-value dari `Map<String, dynamic>` kiriman API dan menginisialisasi objek `Article`. Method ini juga memberikan perlindungan *null-safety* menggunakan fallback operator `??` agar aplikasi tidak crash jika terdapat field API bernilai null.

3. **Apa arti Future<List<Article>> pada fungsi fetchTopHeadlines()?**  
   *Jawaban:*  
   Artinya fungsi tersebut bekerja secara asinkron (*asynchronous*). Nilai kembaliannya bukan seketika tersedia, melainkan berupa sebuah "janji" (*Future*) yang pada masa depan akan menghasilkan data bertipe `List<Article>` jika sukses, atau melempar kesalahan (*Exception*) jika request jaringan gagal.

4. **Mengapa request dijalankan di initState(), bukan langsung di build()?**  
   *Jawaban:*  
   Karena method `build()` dapat dijalankan berkali-kali oleh Flutter engine setiap kali terjadi render ulang (misalnya keyboard muncul/sembunyi, orientasi berganti, atau widget induk me-refresh). Jika request ditaruh di `build()`, aplikasi akan berulang kali menembak API tanpa henti (*infinite request loop*) yang menghabiskan kuota dan bandwidth. `initState()` hanya dipanggil tepat satu kali ketika state widget pertama kali dibuat dalam memory.

5. **Apa perbedaan kondisi loading, error, dan data kosong?**  
   *Jawaban:*  
   - **Loading:** Proses request jaringan sedang berlangsung dan respons server belum selesai diterima (`ConnectionState.waiting`).
   - **Error:** Permintaan mengalami kegagalan, seperti jaringan terputus, API key salah, atau server error (`snapshot.hasError == true`).
   - **Data Kosong:** Permintaan sukses (kode HTTP 200), tetapi server tidak memiliki artikel yang sesuai dengan kriteria yang dicari (`articles.isEmpty`).

6. **Sebutkan minimal dua penyebab data berita gagal ditampilkan.**  
   *Jawaban:*  
   1. Perangkat tidak tersambung ke koneksi internet, atau lupa menambahkan izin `<uses-permission android:name="android.permission.INTERNET" />` pada `AndroidManifest.xml`.  
   2. API key salah, belum diatur di file `.env`, atau kuota batas permintaan harian NewsAPI sudah habis (HTTP 401 / 429).

---

### 🔹 Pertemuan 2: Kategori, Pencarian, dan Filter
1. **Apa perbedaan endpoint /v2/top-headlines dan /v2/everything?**  
   *Jawaban:*  
   - `/v2/top-headlines`: Mengambil berita-berita utama (headlines) terbaru yang dapat difilter menurut negara (`country`) dan kategori (`category`).  
   - `/v2/everything`: Mengambil artikel dari seluruh database berita global berdasarkan kata kunci pencarian (`q`), dengan kemampuan pengurutan berdasarkan waktu rilis (`sortBy: 'publishedAt'`).

2. **Mengapa memilih kategori mengirim request baru pada aplikasi ini?**  
   *Jawaban:*  
   Karena setiap kategori berita (seperti Bisnis, Olahraga, Teknologi) memiliki data yang berbeda di server NewsAPI. Dengan mengirim request baru berserta parameter `category`, server NewsAPI akan mengembalikan 20 berita teratas khusus kategori terpilih tersebut.

3. **Mengapa filter lokal tidak membutuhkan request API?**  
   *Jawaban:*  
   Karena filter lokal menyaring data berita yang sudah berhasil diunduh dan berada di memori perangkat klien. Penyaringan dijalankan langsung oleh CPU perangkat menggunakan perulangan/kondisi Dart (`.where()`), sehingga instan, tidak memakan kuota, dan dapat berjalan secara luring.

4. **Apa fungsi trim(), toLowerCase(), contains(), dan where()?**  
   *Jawaban:*  
   - `trim()`: Menghapus karakter spasi kosong di awal dan di akhir teks input.  
   - `toLowerCase()`: Mengubah teks menjadi huruf kecil semua agar proses perbandingan tidak sensitif huruf besar/kecil (*case-insensitive*).  
   - `contains()`: Memeriksa apakah teks tertentu mengandung penggalan substring yang dicari.  
   - `where()`: Memfilter kumpulan item dalam list yang memenuhi kondisi logika tertentu dan mengembalikan kumpulan item yang lolos seleksi.

5. **Bagian mana yang paling sulit dan bagaimana kamu menyelesaikannya?**  
   *Jawaban:*  
   Mengintegrasikan filter pencarian API dan filter lokal judul tanpa menimbulkan layout overflow. Solusinya adalah membungkus `FutureBuilder` di dalam widget `Expanded`, serta memastikan filter lokal diterapkan langsung terhadap list hasil dari `snapshot.data` sebelum dioper ke `ListView.builder`.

---

### 🔹 Pertemuan 3: Membuat Halaman Detail Berita dan Navigasi Antarmuka
1. **Apa fungsi halaman detail berita pada aplikasi News App?**  
   *Jawaban:*  
   Untuk menampilkan informasi artikel secara utuh dan terfokus (gambar berukuran besar, judul lengkap, tanggal rilis, nama sumber, ringkasan/deskripsi berita), serta menyediakan tombol untuk membuka berita asli di browser.

2. **Apa perbedaan fungsi Navigator.push() dan Navigator.pop()?**  
   *Jawaban:*  
   - `Navigator.push()`: Menaruh halaman baru di atas tumpukan layar (*route stack*) untuk berpindah ke halaman detail.  
   - `Navigator.pop()`: Menghapus layar teratas dari tumpukan untuk kembali ke halaman sebelumnya.

3. **Mengapa objek Article perlu dikirim ke halaman detail?**  
   *Jawaban:*  
   Agar halaman detail menerima data artikel yang spesifik sesuai kartu yang diketuk pengguna, sehingga konten yang ditampilkan akurat tanpa perlu melakukan query API tambahan.

4. **Apa yang terjadi jika data yang dikirim selalu menggunakan objek berita yang sama?**  
   *Jawaban:*  
   Halaman detail akan selalu menampilkan berita yang sama (misalnya berita pertama), tidak peduli berita mana yang diklik oleh pengguna.

5. **Mengapa SingleChildScrollView diperlukan pada halaman detail?**  
   *Jawaban:*  
   Karena teks judul dan isi berita panjangnya bervariasi dan dapat melebihi tinggi layar ponsel. `SingleChildScrollView` membuat halaman dapat digulir dan mencegah error *RenderFlex overflow*.

6. **Apa manfaat penggunaan errorBuilder pada gambar berita?**  
   *Jawaban:*  
   Mencegah aplikasi menampilkan area kosong atau crash saat URL gambar rusak atau gagal dimuat, dengan menampilkan widget pengganti berupa ikon `Icons.broken_image`.

7. **Kendala apa yang kamu temui dan bagaimana cara mengatasinya?**  
   *Jawaban:*  
   Penanganan tautan artikel eksternal yang tidak memiliki format URL yang valid. Diselesaikan dengan memvalidasi skema tautan menggunakan `Uri.tryParse()` dan pengecekan skema `http`/`https` sebelum memanggil `launchUrl()`.

---

### 🔹 Pertemuan 4: Error Handling, Integrasi, dan Pengujian
1. **Apa perbedaan kondisi error dan data kosong?**  
   *Jawaban:*  
   Kondisi error terjadi saat proses permintaan data mengalami kegagalan (HTTP 4xx/5xx atau tidak ada koneksi). Sedangkan data kosong terjadi saat komunikasi server berhasil (HTTP 200), namun tidak ada artikel berita yang ditemukan.

2. **Mengapa pemeriksaan status HTTP perlu dilakukan di NewsService?**  
   *Jawaban:*  
   Karena hanya HTTP status 200 yang menandakan keberhasilan. Status selain 200 (seperti 401 atau 429) mengirimkan pesan error, bukan daftar artikel. Memeriksa status HTTP memastikan kesalahan dapat diintersepsi lebih awal dan dilempar sebagai Exception yang jelas.

3. **Apa fungsi tombol Coba Lagi?**  
   *Jawaban:*  
   Untuk memicu pemanggilan ulang `Future` request berita tanpa pengguna harus me-restart aplikasi, sangat berguna setelah koneksi internet yang sempat putus kembali pulih.

4. **Mengapa Future sebaiknya tidak dibuat berulang kali di dalam builder FutureBuilder?**  
   *Jawaban:*  
   Karena blok `builder` dapat dieksekusi berkali-kali pada setiap frame render ulang. Menaruh inisialisasi Future di dalam builder akan memicu request HTTP tanpa henti yang menghabiskan kuota dan membuat aplikasi lemot.

5. **Bagaimana kamu memastikan halaman detail menampilkan berita yang benar?**  
   *Jawaban:*  
   Dengan mengoper artikel dari indeks list aktif (`filteredArticles[index]`) langsung ke parameter constructor `ArticleDetailPage(article: article)` di dalam `onTap`.

6. **Sebutkan satu bug yang ditemukan saat pengujian dan cara memperbaikinya:**  
   *Jawaban:*  
   Ketika tombol "Coba Lagi" ditekan dalam mode pencarian, aplikasi sempat mengulang fetch kategori umum alih-alih mengulang pencarian kata kunci yang sedang dicari. Bug ini diperbaiki dengan menyimpan query pencarian aktif dalam variabel `_activeSearchQuery` sehingga fungsi `_retryFetch()` dapat mengulang request yang sesuai.

---

### 🔹 Pertemuan 5: Konfigurasi API Key, File .env, dan Keamanan GitHub
1. **Mengapa API key sebaiknya tidak ditulis langsung di file service?**  
   *Jawaban:*  
   Karena jika ditulis langsung (*hardcoded*), API key tersebut akan rawan ikut terunggah saat kode di-commit dan di-push ke GitHub publik, sehingga dapat dicuri dan disalahgunakan pihak lain.

2. **Apa fungsi flutter_dotenv?**  
   *Jawaban:*  
   Untuk memuat variabel lingkungan dari file eksternal `.env` pada saat startup aplikasi dan menyediakannya melalui pemanggilan `dotenv.env['KEY']`.

3. **Apa perbedaan .env dan .env.example?**  
   *Jawaban:*  
   - `.env`: Menyimpan konfigurasi lokal dan API key asli milik pengembang. File ini tidak diunggah ke GitHub (masuk `.gitignore`).  
   - `.env.example`: Berisi template konfigurasi dengan contoh nama variabel dummy (`NEWS_API_KEY=your_news_api_key_here`) yang aman untuk dibagikan ke publik sebagai petunjuk bagi pengembang lain.

4. **Mengapa .env ditambahkan ke .gitignore?**  
   *Jawaban:*  
   Agar sistem pelacakan Git secara otomatis mengabaikan file `.env` sehingga kredensial pribadi tidak pernah masuk ke commit repositori.

5. **Apakah .env membuat API key benar-benar aman dari pengguna aplikasi Flutter? Jelaskan.**  
   *Jawaban:*  
   Tidak. File `.env` didaftarkan sebagai asset di `pubspec.yaml`, yang berarti isinya ikut dikemas ke dalam berkas instalasi aplikasi (seperti file APK). Pengguna yang memiliki keahlian rekayasa balik (*reverse engineering*) dapat membongkar APK dan mengekstrak file asset tersebut. `.env` hanya mengamankan kunci dari kebocoran di Git repository, bukan dari pengguna akhir.

6. **Bagaimana backend membantu melindungi API key pada aplikasi produksi?**  
   *Jawaban:*  
   Pada arsitektur produksi, API key disimpan secara rahasia di server backend. Aplikasi Flutter hanya berkomunikasi dengan backend internal (menggunakan token pengguna), lalu backend yang meneruskan request ke NewsAPI. Dengan cara ini, API key tidak pernah dikirimkan atau disimpan di dalam aplikasi mobile pengguna.

7. **Apa yang harus dilakukan jika API key terlanjur diunggah ke repositori publik?**  
   *Jawaban:*  
   Segera masuk ke dashboard penyedia API (NewsAPI), cabut (*revoke*) atau hapus kunci yang bocor, buat kunci API baru, perbarui file `.env` lokal, dan pastikan aturan `.gitignore` sudah aktif sebelum melakukan commit berikutnya.

