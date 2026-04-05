from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import models, schemas
from app.api import deps
from app.models.user import User
from app.schemas.user import User as UserSchema

router = APIRouter()

@router.get("/users", response_model=List[UserSchema])
def read_users(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: models.user.User = Depends(deps.get_current_superuser),
) -> Any:
    """
    Retrieve users. Only for superusers.
    """
    users = db.query(User).offset(skip).limit(limit).all()
    return users

@router.get("/stats")
def read_system_stats(
    db: Session = Depends(deps.get_db),
    current_user: models.user.User = Depends(deps.get_current_superuser),
) -> Any:
    """
    Get system statistics (e.g., total users). Only for superusers.
    """
    user_count = db.query(User).count()
    # Placeholder for product count if Product model is available
    # product_count = db.query(models.product.Product).count() 
    
    return {
        "total_users": user_count,
        "status": "system_healthy"
    }
