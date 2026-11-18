# Backend Proxy NewsAPI (Keamanan Produksi)

Folder ini berisi backend proxy ringan agar **`NEWS_API_KEY` tersimpan aman di server** (tidak pernah terekspos ke kode Flutter Web / GitHub Pages) sekaligus mengatasi pembatasan CORS NewsAPI di domain publik.

---

## Opsi A: Deploy Gratis ke Vercel (Paling Mudah)

1. Buka [https://vercel.com/new](https://vercel.com/new) dan login menggunakan GitHub.
2. Import repository `news-app-flutter`.
3. Pada **Root Directory**, klik **Edit** dan pilih folder **`backend`**.
4. Pada bagian **Environment Variables**, tambahkan:
   - Name: `NEWS_API_KEY`
   - Value: *(API key NewsAPI milikmu)*
5. Klik **Deploy**. Setelah selesai, salin URL endpoint-nya, misalnya:
   `https://nama-project-kamu.vercel.app/api/news`
6. Masuk ke repository GitHub kamu → **Settings** → **Secrets and variables** → **Actions** → tab **Variables** → **New repository variable**:
   - Name: `API_PROXY_URL`
   - Value: `https://nama-project-kamu.vercel.app/api/news`
7. Jalankan ulang workflow **Deploy Flutter Web to GitHub Pages** di tab **Actions**.

---

## Opsi B: Deploy Gratis ke Cloudflare Workers

1. Buka [Cloudflare Dashboard](https://dash.cloudflare.com/) → **Workers & Pages** → **Create Worker**.
2. Tempel isi file `backend/worker.js`, lalu **Deploy**.
3. Masuk ke **Settings** → **Variables and Secrets** → tambahkan Secret:
   - Name: `NEWS_API_KEY`
   - Value: *(API key NewsAPI milikmu)*
4. Salin URL Worker kamu (misal `https://news-proxy.username.workers.dev`) ke GitHub Repository Variable `API_PROXY_URL`, lalu jalankan ulang GitHub Actions.
