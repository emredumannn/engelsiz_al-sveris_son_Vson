import requests

API_URL = "http://127.0.0.1:8000/products/"

urunler = [
    {"name": "Çaykur Rize Turist Çayı", "price": 145.00, "barcode": "8690637060017", "weight": "500gr", "description": "Geleneksel lezzet", "image_url": "http://127.0.0.1:8000/static/cay.jpg"},
    {"name": "Torku Tam Yağlı Süt", "price": 34.50, "barcode": "8690120060007", "weight": "1L", "description": "Pastörize süt", "image_url": "http://127.0.0.1:8000/static/sut.jpg"},
    {"name": "Coca-Cola Original", "price": 45.00, "barcode": "5449000000996", "weight": "1L", "description": "Gazlı içecek", "image_url": "http://127.0.0.1:8000/static/kola.jpg"},
    {"name": "Ülker Çikolatalı Gofret", "price": 6.75, "barcode": "8690504060236", "weight": "36gr", "description": "Çıtır gofret", "image_url": "http://127.0.0.1:8000/static/gofret.jpg"},
    {"name": "Uno Tost Ekmeği", "price": 55.00, "barcode": "8690605021019", "weight": "670gr", "description": "Dilimli ekmek", "image_url": "http://127.0.0.1:8000/static/ekmek.jpg"},
]

print("⏳ Yükleme başladı...")
for urun in urunler:
    try:
        requests.post(API_URL, json=urun)
        print(f"✅ Eklendi: {urun['name']}")
    except:
        print("❌ HATA: Sunucu kapalı! İlk terminali kontrol et.")