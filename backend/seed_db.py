import sys
import os
sys.path.append(os.getcwd())
from app.db.session import SessionLocal
from app.models.product import Product

def seed_db():
    db = SessionLocal()
    try:
        if not db.query(Product).first():
            print("Test urunu ekleniyor...")
            p = Product(
                name="Ornek Sut", 
                price=25.50, 
                description="Test icin eklenen ornek urun.", 
                barcode="123456789", 
                currency="TRY",
                image_url="https://placehold.co/600x400/png" # Ornek gorsel
            )
            db.add(p)
            db.commit()
            print("Test urunu eklendi!")
        else:
            print("Veritabaninda zaten urun var.")
    except Exception as e:
        print(f"Hata olustu: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_db()
