import pandas as pd
# 1. Baca file excel (Asumsi kolom A = kata salah, kolom B = kata baku)
df = pd.read_excel('kamuskatabaku.xlsx')


kamus_dict = dict(zip(df['slang'].str.lower(), df['formal'].str.lower()))

# 3. Simpan langsung menjadi file kamus_typo.json di dalam folder backend
import json
with open('kamus_typo.json', 'w', encoding='utf-8') as f:
    json.dump(kamus_dict, f, ensure_ascii=False, indent=4)