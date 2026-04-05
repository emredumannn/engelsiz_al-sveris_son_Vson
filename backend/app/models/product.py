from sqlalchemy import Column, Integer, String, Float, Text
from app.db.base_class import Base

class Product(Base):
    id = Column(Integer, primary_key=True, index=True)
    barcode = Column(String, unique=True, index=True, nullable=True) # Barkod olmayabilir (OCR ile bulduysa)
    name = Column(String, index=True, nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)
    currency = Column(String, default="TRY")
    
    # Görüntü işleme metadata'sı
    image_url = Column(String, nullable=True)
    weight = Column(String, nullable=True)
    ocr_text = Column(Text, nullable=True) # OCR'dan okunan ham metin
