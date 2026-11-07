"""Cek jawabanmu. Tulis di answers.sql (format sama: penanda -- Q1, -- Q2, ...), lalu:
    python3 check.py            # cek semua
    python3 check.py 7 12       # cek soal tertentu
Hasil dibandingkan sebagai himpunan baris; float dibulatkan 2 desimal; urutan bebas.
"""
import os, re, sqlite3, sys

HERE = os.path.dirname(os.path.abspath(__file__))
DB = os.path.join(HERE, "shop.sqlite")
MARK = re.compile(r"^\s*--\s*Q(\d+)\s*$", re.M)

def parse(path):
    txt = open(path, encoding="utf-8").read()
    parts = MARK.split(txt)
    out = {}
    for i in range(1, len(parts) - 1, 2):
        sql = parts[i + 1]
        sql = "\n".join(l for l in sql.splitlines() if not l.strip().startswith("--")).strip()
        if sql:
            out[int(parts[i])] = sql
    return out

def norm(rows):
    def f(v):
        return round(v, 2) if isinstance(v, float) else v
    return sorted(tuple(f(v) for v in r) for r in rows)

def run(con, sql):
    cur = con.execute(sql)
    return cur.fetchall()

def main():
    if not os.path.exists(DB):
        sys.exit("db belum ada: jalankan python3 build_db.py dulu")
    gold, mine = parse(os.path.join(HERE, "solutions.sql")), parse(os.path.join(HERE, "answers.sql"))
    want = [int(a) for a in sys.argv[1:]] or sorted(gold)
    con = sqlite3.connect(DB)
    ok = 0
    for q in want:
        if q not in gold:
            print(f"Q{q}: tidak ada di solutions.sql"); continue
        if q not in mine:
            print(f"Q{q}: SKIP (belum dijawab)"); continue
        try:
            got = run(con, mine[q])
        except Exception as e:
            print(f"Q{q}: ERROR {e}"); continue
        exp = run(con, gold[q])
        if norm(got) == norm(exp):
            ok += 1; print(f"Q{q}: PASS ({len(exp)} baris)")
        else:
            print(f"Q{q}: FAIL — dapat {len(got)} baris, harusnya {len(exp)}")
            print("  punyamu :", got[:3])
            print("  kunci   :", exp[:3])
    total = len([q for q in want if q in gold])
    print(f"\n{ok}/{total} pass")
    if ok != total:
        print("Hint: cek jenis JOIN, filter status='completed', dan apakah perlu DISTINCT.")
    con.close()

if __name__ == "__main__":
    main()
