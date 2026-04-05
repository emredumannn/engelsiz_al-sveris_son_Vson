from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user
from app.models.favorite import Favorite
from app.models.product import Product
from app.models.user import User
from app.schemas.favorite import Favorite as FavoriteSchema, FavoriteCreate

router = APIRouter()

@router.get("/", response_model=List[FavoriteSchema])
def read_favorites(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: User = Depends(get_current_user),
) -> Any:
    """
    Retrieve current user's favorites.
    """
    favorites = (
        db.query(Favorite)
        .filter(Favorite.user_id == current_user.id)
        .offset(skip)
        .limit(limit)
        .all()
    )
    return favorites

@router.post("/{barcode}", response_model=FavoriteSchema)
def add_favorite(
    barcode: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> Any:
    """
    Add a product to favorites by barcode.
    """
    # 1. Find Product
    product = db.query(Product).filter(Product.barcode == barcode).first()
    if not product:
        raise HTTPException(status_code=404, detail="Ürün bulunamadı")

    # 2. Check if already favorite
    existing_fav = (
        db.query(Favorite)
        .filter(Favorite.user_id == current_user.id, Favorite.product_id == product.id)
        .first()
    )
    if existing_fav:
        raise HTTPException(status_code=400, detail="Bu ürün zaten favorilerde ekli!")

    # 3. Add to favorites
    favorite = Favorite(user_id=current_user.id, product_id=product.id)
    db.add(favorite)
    db.commit()
    db.refresh(favorite)
    return favorite

@router.delete("/{barcode}", response_model=FavoriteSchema)
def delete_favorite(
    barcode: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> Any:
    """
    Remove a product from favorites by barcode.
    """
    product = db.query(Product).filter(Product.barcode == barcode).first()
    if not product:
        raise HTTPException(status_code=404, detail="Ürün bulunamadı")

    favorite = (
        db.query(Favorite)
        .filter(Favorite.user_id == current_user.id, Favorite.product_id == product.id)
        .first()
    )
    if not favorite:
        raise HTTPException(status_code=404, detail="Ürün favorilerde bulunamadı")

    db.delete(favorite)
    db.commit()
    return favorite
