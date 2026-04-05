import requests
import sys
import os

# API URL
API_URL = "http://127.0.0.1:8000/api/v1/products/"

# Ürün Veritabanı (main.py'den alındı)
products = [
    # --- RESİMLİ İLK 5 ÜRÜN ---
    {"name": "Çaykur Rize Turist Çayı", "price": 145.00, "barcode": "8690637060017", "weight": "500gr", "description": "Geleneksel lezzet", "image_url": "http://127.0.0.1:8000/static/cay.jpg"},
    {"name": "Torku Tam Yağlı Süt", "price": 34.50, "barcode": "8690120060007", "weight": "1L", "description": "Pastörize süt", "image_url": "http://127.0.0.1:8000/static/sut.jpg"},
    {"name": "Coca-Cola Original", "price": 45.00, "barcode": "5449000000996", "weight": "1L", "description": "Gazlı içecek", "image_url": "http://127.0.0.1:8000/static/kola.jpg"},
    {"name": "Ülker Çikolatalı Gofret", "price": 6.75, "barcode": "8690504060236", "weight": "36gr", "description": "Çıtır gofret", "image_url": "http://127.0.0.1:8000/static/gofret.jpg"},
    {"name": "Uno Tost Ekmeği", "price": 55.00, "barcode": "8690605021019", "weight": "670gr", "description": "Dilimli ekmek", "image_url": "http://127.0.0.1:8000/static/ekmek.jpg"},

    # --- RESİMSİZ DİĞER ÜRÜNLER ---
    {"name": "Eti Cin Portakallı", "price": 8.50, "barcode": "8690526008513", "weight": "25gr"},
    {"name": "Nescafe 3ü1 Arada", "price": 5.00, "barcode": "8690632025820", "weight": "17gr"},
    {"name": "Erikli Su", "price": 12.00, "barcode": "8690562000298", "weight": "1.5L"},
    {"name": "SuperFresh Pizza King", "price": 120.00, "barcode": "8690574201829", "weight": "780gr"},
    {"name": "Solo Tuvalet Kağıdı", "price": 210.00, "barcode": "8690530136271", "weight": "32'li"},
    {"name": "Fairy Bulaşık Deterjanı", "price": 85.00, "barcode": "8001090382759", "weight": "1.5L"},
    {"name": "Barilla Spaghetti", "price": 32.00, "barcode": "8076809513753", "weight": "500gr"},
    {"name": "Nutella Fındık Kreması", "price": 115.00, "barcode": "8000500179864", "weight": "400gr"},
    {"name": "Lay's Klasik Cips", "price": 40.00, "barcode": "8690624101341", "weight": "150gr"},
    {"name": "Domestos Çamaşır Suyu", "price": 65.00, "barcode": "8690637172529", "weight": "750ml"},
    {"name": "Ruffles Peynir Soğan", "price": 40.00, "barcode": "8690624201348", "weight": "150gr"},
    {"name": "Doritos Taco", "price": 40.00, "barcode": "8690624301345", "weight": "150gr"},
    {"name": "Pınar Labne", "price": 45.00, "barcode": "8690547012345", "weight": "400gr"},
    {"name": "İçim Kaşar Peyniri", "price": 180.00, "barcode": "8690547056789", "weight": "700gr"},
    {"name": "Aytaç Dana Sucuk", "price": 250.00, "barcode": "8690547098765", "weight": "500gr"},
    {"name": "Maret Sosis", "price": 90.00, "barcode": "8690547043210", "weight": "250gr"},
    {"name": "Filiz Burgu Makarna", "price": 18.50, "barcode": "8690574205555", "weight": "500gr"},
    {"name": "Tat Domates Salçası", "price": 65.00, "barcode": "8690574206666", "weight": "830gr"},
    {"name": "Yudum Ayçiçek Yağı", "price": 195.00, "barcode": "8690574207777", "weight": "5L"},
    {"name": "Komili Sızma Zeytinyağı", "price": 450.00, "barcode": "8690574208888", "weight": "2L"},
    {"name": "Söke Un", "price": 35.00, "barcode": "8690574209999", "weight": "2kg"},
    {"name": "Bal Küpü Şeker", "price": 42.00, "barcode": "8690123456789", "weight": "1kg"},
    {"name": "Çaykur Tiryaki Çayı", "price": 135.00, "barcode": "8690637060024", "weight": "500gr"},
    {"name": "Lipton Yellow Label", "price": 150.00, "barcode": "8690637060031", "weight": "100'lü"},
    {"name": "Doğuş Earl Grey", "price": 45.00, "barcode": "8690637060048", "weight": "48'li"},
    {"name": "Beypazarı Maden Suyu", "price": 6.00, "barcode": "8690637060055", "weight": "200ml"},
    {"name": "Sırma Su", "price": 5.00, "barcode": "8690637060062", "weight": "500ml"},
    {"name": "Hayat Su", "price": 15.00, "barcode": "8690637060079", "weight": "5L"},
    {"name": "Colgate Diş Macunu", "price": 75.00, "barcode": "8690637060086", "weight": "75ml"},
    {"name": "Ipana Diş Macunu", "price": 65.00, "barcode": "8690637060093", "weight": "75ml"},
    {"name": "Oral-B Diş Fırçası", "price": 50.00, "barcode": "8690637060109", "weight": "1 adet"},
    {"name": "Head & Shoulders Şampuan", "price": 110.00, "barcode": "8690637060116", "weight": "400ml"},
    {"name": "Pantene Şampuan", "price": 105.00, "barcode": "8690637060123", "weight": "400ml"},
    {"name": "Elidor Saç Kremi", "price": 85.00, "barcode": "8690637060130", "weight": "350ml"},
    {"name": "Nivea Deodorant", "price": 95.00, "barcode": "8690637060147", "weight": "150ml"},
    {"name": "Rexona Deodorant", "price": 90.00, "barcode": "8690637060154", "weight": "150ml"},
    {"name": "Gillette Tıraş Köpüğü", "price": 80.00, "barcode": "8690637060161", "weight": "200ml"},
    {"name": "Permatik Banyo", "price": 45.00, "barcode": "8690637060178", "weight": "5'li"},
    {"name": "Selpak Kağıt Havlu", "price": 120.00, "barcode": "8690637060185", "weight": "6'lı"},
    {"name": "Familia Tuvalet Kağıdı", "price": 190.00, "barcode": "8690637060192", "weight": "32'li"},
    {"name": "Vernel Yumuşatıcı", "price": 75.00, "barcode": "8690637060208", "weight": "1.5L"},
    {"name": "Omo Matik", "price": 220.00, "barcode": "8690637060215", "weight": "5kg"},
    {"name": "Pril Bulaşık Deterjanı", "price": 45.00, "barcode": "8690637060222", "weight": "750ml"},
    {"name": "Cif Krem", "price": 55.00, "barcode": "8690637060239", "weight": "500ml"},
    {"name": "Ace Çamaşır Suyu", "price": 40.00, "barcode": "8690637060246", "weight": "1L"},
]

print(f"⏳ {len(products)} adet ürün yükleniyor...")

success_count = 0
fail_count = 0

for product in products:
    try:
        response = requests.post(API_URL, json=product)
        if response.status_code == 200 or response.status_code == 201:
            print(f"✅ Eklendi: {product['name']}")
            success_count += 1
        else:
            print(f"⚠️ Hata ({response.status_code}): {product['name']} - {response.text}")
            fail_count += 1
    except requests.exceptions.ConnectionError:
        print("❌ HATA: Sunucuya bağlanılamadı. Backend'in çalıştığından emin olun.")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Beklenmedik Hata: {e}")
        fail_count += 1

print(f"\nSonuç: {success_count} başarılı, {fail_count} hatalı.")
