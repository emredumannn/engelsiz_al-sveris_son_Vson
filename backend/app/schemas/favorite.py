from pydantic import BaseModel
from app.schemas.product import Product

class FavoriteBase(BaseModel):
    product_id: int

class FavoriteCreate(FavoriteBase):
    pass

class Favorite(FavoriteBase):
    id: int
    user_id: int
    product: Product

    class Config:
        from_attributes = True
