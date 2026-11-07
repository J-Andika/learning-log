# Roadmap 24 Minggu — Data / Analytics Engineering
Track: **Data Engineering → Analytics Engineering**. Dipilih karena: volume lowongan tinggi di ID, bisa masuk lewat jalur Data Analyst dulu, hambatan masuk paling rendah untuk orang tanpa portofolio, dan paling tahan terhadap AI (karena kerjaan intinya model data, definisi metrik, dan pipeline yang nggak boleh bohong).

**Kontrak belajar:** 12 jam/minggu × 24 minggu = ~290 jam. Kalau realistisnya cuma 8 jam/minggu, roadmap ini jadi 36 minggu — itu normal, bukan kegagalan. Yang gagal adalah yang berhenti.

**Aturan main (penting, jangan dilewat):**
1. Satu fase tidak boleh dimulai sebelum gate fase sebelumnya lulus.
2. Tiap 2 minggu: 1 tulisan 400 kata di `notes/` — apa yang dibangun, **kenapa** dipilih begitu, apa yang gagal. Ini yang nanti jadi bahan interview.
3. Nggak ada tutorial passif. Tiap video/bab wajib menghasilkan file yang jalan.
4. Kalau macet >45 menit: kirim error + apa yang sudah dicoba ke gw. Jangan diem 2 hari.
5. Bahasa Inggris 30 menit/hari, sejak minggu 1, tanpa kecuali. Ini yang paling menentukan batas karir lu, bukan SQL.

---

## Fase 0 — Minggu 1: Pondasi & kebiasaan
Tanpa ini, semua fase berikutnya bocor.

- Install: Python 3.12, VS Code, Git, DBeaver (atau DataGrip), Docker Desktop.
- Git minimal: `init`, `add`, `commit`, `push`, `branch`, `merge`. Bikin repo pertama `learning-log`.
- Terminal dasar: pipe, redirect, `grep`, `find`, `curl`.
- SQL: `sqlbolt.com` sampai selesai (interaktif, ~3 jam).
- Mulai `practice/` di repo ini: **kerjakan Q1–Q6**.

**Gate:** repo publik ada, ≥5 commit, Q1–Q6 pass di `python3 check.py`.

---

## Fase 1 — Minggu 2–5: SQL sampai refleks
Ini 40% nilai interview junior. Nggak bisa diakali.

| Minggu | Materi | Deliverable |
|---|---|---|
| 2 | SELECT, WHERE, ORDER, agregasi, GROUP BY, HAVING | Q1–Q9 pass |
| 3 | JOIN semua jenis, NULL semantics, subquery | Q10–Q15 pass, tulis 5 query ad-hoc sendiri di `practice/extra.sql` |
| 4 | Window function (ROW_NUMBER, RANK, LAG, SUM OVER), CTE | Q16–Q20 pass + 5 window query baru |
| 5 | EXPLAIN, index dasar, normalisasi vs denormalisasi | `notes/01-sql.md`: jelaskan kapan pakai CTE vs subquery |

Sumber: `sqlbolt.com` → `pgexercises.com` (pakai Postgres di Docker) → buku *SQL for Data Analysis* (Cathy Tanimura) bab 1–8.
**Gate:** 20/20 pass **tanpa** lihat kunci, plus bisa jelaskan bedanya `WHERE` vs `HAVING` dan kenapa `LEFT JOIN` bisa menghasilkan NULL, secara lisan/tertulis.

> Ponytail: skip jendela advanced (recursive CTE, pivot kompleks) sampai ada kasus nyata. Buka kalau interview minta.

---

## Fase 2 — Minggu 6–9: Python untuk data (bukan Python umum)
Fokus: baca/tulis data, API, bersih-bersih, bukan bikin aplikasi.

- Minggu 6: `csv`, `json`, `pathlib`, exception, fungsi, virtualenv. Latihan: parse file CSV 100k baris, hitung metrik per kota.
- Minggu 7: `requests` + pagination + retry + rate limit. Ambil data dari API publik nyata (contoh: data BPS/BMKG/open data Jakarta), simpan ke SQLite via `sqlite3` stdlib.
- Minggu 8: pandas/Polars dasar — `read_*`, `merge`, `groupby`, `pivot_table`, tipe data, NaN. Latihan: bersihkan dataset kotor yang sengaja gw kasih.
- Minggu 9: DuckDB (SQL di atas file Parquet/CSV) + Parquet. **Gate:** pipeline pertama jalan end-to-end: API → cleaning → Parquet → query SQL.

**Deliverable:** `project-01-ingest/` dengan `README.md` yang menjelaskan skema, asumsi, dan cara menjalankan.
**Gate:** bisa dijalankan ulang dari nol dengan satu perintah, hasil identik (idempotent).

---

## Fase 3 — Minggu 10–13: Project 1 yang layak dipamerkan
Satu proyek bagus > lima proyek tutorial.

Bangun: **pipeline harian + data warehouse lokal + dashboard**.
- Sumber: 1 API publik + 1 file CSV besar.
- Staging → cleaned → mart (3 layer, walau semuanya di DuckDB/Postgres lokal).
- Orkestrasi sederhana: cron atau `Makefile`/GitHub Actions schedule.
- Dashboard: Metabase (Docker) atau Streamlit.
- Kualitas data: minimal 6 test (not null, unique, accepted values, referential, freshness, row count drift).

**Gate:** proyek jalan 7 hari berturut tanpa intervensi manual, screenshot dashboard ada di README, dan lu bisa menjelaskan alur data dari sumber sampai chart dalam 3 menit tanpa lihat catatan.

---

## Fase 4 — Minggu 14–17: Cloud + Docker + CI (tiket masuk interview)
- Minggu 14: Docker — image, layer, volume, compose. Bungkus project 1 jadi container.
- Minggu 15: GitHub Actions — lint, test, build. CI hijau = bukti kerja.
- Minggu 16–17: satu sertifikasi. Pilih **satu**:
  - **GCP Professional Data Engineer** (lebih relevan data, lebih sulit) — atau
  - **AWS Certified Data Engineer – Associate** (paling dicari di ID) — atau
  - kalau waktu mepet: **AWS Cloud Practitioner** dulu sebagai pemanasan, lanjut Associate.
  - Biaya ujian ~$100–200. Bayar sekali, jangan ambil 3 sertif sekaligus.

**Gate:** sertifikat lulus/lulus-trial + project 1 bisa di-`docker compose up` di mesin bersih.
**Catatan jujur:** sertifikat itu **tiket masuk screening**, bukan bukti kompetensi. Tanpa proyek, sertifikat cuma hiasan.

---

## Fase 5 — Minggu 18–21: Analytics engineering (pembeda utama)
Ini yang bikin lu naik dari "bisa SQL" ke "bisa dipercaya megang angka perusahaan".
- dbt (core, gratis): model, `ref()`, materialization, `dbt test`, `dbt docs`, incremental model, snapshot.
- Konsep wajib: dimensional modeling (fact/dim), grain, slowly changing dimension, idempotency, backfill.
- Orkestrasi: Airflow **atau** Dagster (pilih satu, jangan dua). Cukup paham DAG, dependency, retry, SLA.
- Git workflow: branch, PR, review sendiri pakai checklist.

**Project 2:** dbt project di atas data project 1 — 15+ model, 20+ test, dokumentasi, 2 incremental model, satu "incident postmortem" (sengaja rusak pipeline, lalu tulis analisisnya: gejala, akar masalah, perbaikan, pencegahan). Postmortem ini yang paling sering bikin interviewer terkesan.
**Gate:** `dbt build` hijau, `dbt docs` bisa di-host GitHub Pages.

---

## Fase 6 — Minggu 22–24: Cari kerja (ini kerjaan penuh waktu juga)
- Minggu 22: CV 1 halaman (format: hasil > tools > pendidikan), LinkedIn, GitHub profile rapi (README profil + 3 repo pinned + deskripsi jelas).
- Minggu 23: latihan interview. 20 soal SQL live (timer 15 menit/soal), 5 pertanyaan sistem data ("kalau tabel 1 miliar baris, kenapa lambat?"), 3 cerita proyek versi 3 menit.
- Minggu 24: apply **25–30 loker/minggu**. Target judul: Data Analyst, BI Analyst, Analytics Engineer, Junior Data Engineer, ETL Developer. Bukan "Senior".
- Jalur masuk realistis: **Data Analyst dulu 6–12 bulan → Analytics Engineer**. Jangan ngotot langsung DE di perusahaan besar.

Metrik usaha, bukan metrik hasil: 100 lamaran → ~10 interview → 1–3 offer. Itu normal. Yang gagal adalah yang berhenti di lamaran ke-20.

---

## Target gaji (riset sendiri, ini kisaran kasar Jakarta 2026)
- Data Analyst junior: Rp7–11jt
- Analytics Engineer / DE junior: Rp9–15jt
- Setelah 2–3 tahun + cloud cert: Rp18–30jt, atau remote luar $1.500–3.000/bulan kalau bahasa Inggris cukup.

---

## Yang **tidak** masuk roadmap (sengaja)
Spark, Kafka, Kubernetes advanced, ML, blockchain, "AI engineer". Semuanya nanti. Menambah sekarang = menunda kerja 6 bulan. Add when: sudah dapat kerja dan perusahaan pakai.

---

## Cara pakai gw sebagai mentor
- Kirim kode/SQL/error → gw review, kasih versi lebih baik + alasannya.
- Minta kuis: "tes gw window function" → gw kasih soal, nilai jawabanmu, tunjuk lubangnya.
- Tiap akhir fase: gate check. Gw yang nanya, lu yang jawab. Kalau nggak lulus, ngulang — itu lebih murah daripada gagal di interview.
- Jangan minta gw bikinin proyeknya. Gw bikinin = lu nggak belajar. Gw bikinin **kisi-kisinya**.

Mulai dari: `practice/` → Q1. Sekarang.
