import sys
import os

# Add the current directory to sys.path to ensure we can import from app
sys.path.append(os.getcwd())

from app.db.session import SessionLocal
from app.models.product import Product

def list_products():
    db = SessionLocal()
    try:
        products = db.query(Product).all()
        if not products:
            print("Veritabanında hiç ürün bulunamadı.")
            return

        print(f"{'ID':<5} {'Barkod':<15} {'Fiyat':<10} {'Ürün Adı'}")
        print("-" * 50)
        for p in products:
            print(f"{p.id:<5} {p.barcode:<15} {p.price:<10} {p.name}")
            
    except Exception as e:
        print(f"Hata oluştu: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    list_products()
