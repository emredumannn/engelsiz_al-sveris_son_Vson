from fastapi import APIRouter
from app.api.v1.endpoints import products

from app.api.v1.endpoints import auth, admin, favorites, utils

api_router = APIRouter()
api_router.include_router(auth.router, tags=["login"])
api_router.include_router(admin.router, prefix="/admin", tags=["admin"])

# Router'ları buraya ekleyeceğiz
api_router.include_router(products.router, prefix="/products", tags=["products"])
api_router.include_router(favorites.router, prefix="/favorites", tags=["favorites"])
api_router.include_router(utils.router, tags=["utils"])

from app.api.v1.endpoints import ai
api_router.include_router(ai.router, prefix="/ai", tags=["ai"])
# api_router.include_router(users.router, prefix="/users", tags=["users"])
