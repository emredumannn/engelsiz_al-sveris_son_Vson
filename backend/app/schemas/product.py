from typing import Optional
from pydantic import BaseModel

class ProductBase(BaseModel):
    name: str
    price: float
    description: Optional[str] = None
    barcode: Optional[str] = None
    weight: Optional[str] = None
    image_url: Optional[str] = None

class ProductCreate(ProductBase):
    pass

class ProductUpdate(ProductBase):
    pass

class Product(ProductBase):
    id: int
    currency: str
    ocr_text: Optional[str] = None

    class Config:
        from_attributes = True
