"""Bikin database latihan deterministik. Jalankan sekali: python3 build_db.py"""
import os, random, sqlite3
from datetime import date, timedelta

HERE = os.path.dirname(os.path.abspath(__file__))
DB = os.path.join(HERE, "shop.sqlite")
random.seed(42)

CITIES = ["Jakarta", "Bandung", "Surabaya", "Medan", "Yogyakarta", "Semarang", "Makassar", "Denpasar"]
SEGMENTS = ["retail", "smb", "enterprise"]
FIRST = ["Andi", "Budi", "Citra", "Dewi", "Eko", "Fitri", "Gita", "Hadi", "Indra", "Joko", "Kirana", "Lestari", "Maya", "Nanda", "Oka"]
LAST = ["Pratama", "Wijaya", "Santoso", "Halim", "Nugroho", "Saputra", "Hartono", "Kusuma", "Siregar", "Rahman"]
CATS = {"Elektronik": (800_000, 12_000_000), "Fashion": (80_000, 900_000),
        "Rumah Tangga": (50_000, 2_000_000), "Kesehatan": (30_000, 600_000), "Olahraga": (100_000, 3_000_000)}

def d(y, m, day):
    return date(y, m, day).isoformat()

def main():
    if os.path.exists(DB):
        os.remove(DB)
    con = sqlite3.connect(DB)
    con.executescript("""
    CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT, city TEXT, segment TEXT, signup_date TEXT);
    CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, category TEXT, price REAL);
    CREATE TABLE orders(id INTEGER PRIMARY KEY, customer_id INTEGER, order_date TEXT, status TEXT);
    CREATE TABLE order_items(order_id INTEGER, product_id INTEGER, qty INTEGER, unit_price REAL, discount REAL);
    """)

    # customers: signup tersebar 2024-07 .. 2025-12
    start = date(2024, 7, 1)
    custs = []
    for i in range(1, 501):
        sd = start + timedelta(days=random.randint(0, 540))
        custs.append((i, f"{random.choice(FIRST)} {random.choice(LAST)}", random.choice(CITIES),
                      random.choice(SEGMENTS), sd.isoformat()))
    con.executemany("INSERT INTO customers VALUES (?,?,?,?,?)", custs)

    # products
    prods = []
    pid = 1
    for cat, (lo, hi) in CATS.items():
        for n in range(8):
            price = round(random.uniform(lo, hi), -3)
            prods.append((pid, f"{cat} {chr(65+n)}", cat, price))
            pid += 1
    con.executemany("INSERT INTO products VALUES (?,?,?,?)", prods)

    # orders 2025-01 .. 2026-06, status mayoritas completed
    ostats = ["completed"] * 82 + ["cancelled"] * 12 + ["returned"] * 6
    oid = 1
    order_rows, item_rows = [], []
    for cid in range(1, 501):
        n_orders = random.choice([0, 1, 1, 2, 2, 3, 4, 5, 7])
        for _ in range(n_orders):
            od = max(date.fromisoformat(custs[cid-1][4]),
                     date(2025, 1, 1) + timedelta(days=random.randint(0, 545)))
            order_rows.append((oid, cid, od.isoformat(), random.choice(ostats)))
            for p in random.sample(prods, random.randint(1, 4)):
                disc = round(random.choice([0, 0, 0, 0.05, 0.1, 0.15, 0.2, 0.3]), 2)
                item_rows.append((oid, p[0], random.randint(1, 4), p[3], disc))
            oid += 1
    con.executemany("INSERT INTO orders VALUES (?,?,?,?)", order_rows)
    con.executemany("INSERT INTO order_items VALUES (?,?,?,?,?)", item_rows)
    con.commit()

    for t in ("customers", "products", "orders", "order_items"):
        print(t, con.execute(f"SELECT count(*) FROM {t}").fetchone()[0])
    con.close()

if __name__ == "__main__":
    main()
