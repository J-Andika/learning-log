# Soal Latihan SQL (20 soal) — tanpa jawaban

Database: `shop.sqlite` (dibuat oleh `build_db.py`).

## Skema
- `customers(id, name, city, segment, signup_date)` — 500 baris. `segment` ∈ {retail, smb, enterprise}. `signup_date` format `YYYY-MM-DD`.
- `products(id, name, category, price)` — 40 baris, 5 kategori.
- `orders(id, customer_id, order_date, status)` — ±1.400 baris. `status` ∈ {completed, cancelled, returned}.
- `order_items(order_id, product_id, qty, unit_price, discount)` — ±3.500 baris. `discount` = fraksi 0–0.3.

## Aturan yang berlaku untuk semua soal
- **revenue** = `qty * unit_price * (1 - discount)`.
- Hanya `orders.status = 'completed'` dihitung sebagai penjualan, kecuali soal bilang lain.
- Pembandingan hasil: nilai baris saja (nama kolom/alias tidak dinilai), urutan bebas, float dibulatkan 2 desimal.
- Kalau soal minta "top N" dan ada nilai seri, urutkan sekunder dengan `id`/`name` supaya hasilnya deterministik.

---

**Q1.** Berapa jumlah seluruh customer?

**Q2.** 5 kota dengan customer terbanyak. Output: kota, jumlah. Urut turun, seri diurutkan nama kota.

**Q3.** Total revenue dari seluruh order yang selesai (1 baris).

**Q4.** 10 produk dengan revenue tertinggi. Output: nama produk, revenue. Seri diurutkan nama.

**Q5.** Berapa customer yang **belum pernah** membuat order sama sekali (status apa pun)?

**Q6.** Revenue per bulan sepanjang 2025 (hanya order selesai). Output: `YYYY-MM`, revenue. Urut naik.

**Q7.** Rata-rata nilai order (AOV) per `segment` customer. Hitung revenue per order dulu, baru dirata-rata. Output: segment, aov.

**Q8.** Revenue dan persentase kontribusi per kategori produk. Output: kategori, revenue, pct (0–100, 2 desimal). Urut revenue turun.

**Q9.** Customer dengan minimal 3 order selesai. Output: id, nama, jumlah order. Urut jumlah turun, lalu id. Batasi 10.

**Q10.** Revenue bulanan 2025 **plus** running total kumulatif. Output: bulan, revenue, running_total. Urut naik.

**Q11.** Produk terlaris (unit terbanyak) **per kategori**. Output: kategori, nama produk, unit. Satu baris per kategori.

**Q12.** Repeat rate: persentase customer yang punya lebih dari 1 order selesai, dibagi customer yang punya minimal 1 order selesai. Output 1 baris, dalam persen.

**Q13.** Berapa customer yang total belanjanya **di atas rata-rata** total belanja semua customer pembeli?

**Q14.** Pertumbuhan revenue bulan-ke-bulan sepanjang 2025 dalam persen. Output: bulan, revenue, mom_pct. Bulan pertama boleh NULL.

**Q15.** Cohort: customer yang signup bulan 2025-01. Berapa yang aktif (order selesai) di 2025-01, 2025-02, 2025-03? Output: bulan, jumlah customer aktif. Harus tetap muncul walau 0.

**Q16.** Sebaran customer berdasarkan bulan order selesai pertamanya. Output: `YYYY-MM`, jumlah customer. Urut naik.

**Q17.** Berapa produk yang tidak pernah terjual di order selesai?

**Q18.** Per kategori: revenue dan rata-rata diskon (persen). Output: kategori, revenue, avg_discount_pct. Urut revenue turun.

**Q19.** Rata-rata jumlah hari dari `signup_date` sampai order selesai pertama, per segment.

**Q20.** Customer dengan revenue tertinggi **di tiap kota**. Output: kota, id, nama, revenue. Satu baris per kota, urut kota.

---

Butuh petunjuk tanpa jawaban? Minta ke mentor: sebut nomor soalnya.
