from datetime import timedelta
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app import models, schemas
from app.api import deps
from app.core import security
from app.core.config import settings
from app.models.user import User

router = APIRouter()

@router.post("/login/access-token", response_model=schemas.token.Token)
def login_access_token(
    db: Session = Depends(deps.get_db),
    form_data: OAuth2PasswordRequestForm = Depends()
) -> Any:
    """
    OAuth2 compatible token login, get an access token for future requests
    """
    # Note: crud.user.authenticate needs to be implemented or we do it inline here if crud is not ready yet.
    # Looking at file structure, I didn't see crud directory in the list_dir output earlier?
    # Wait, I saw 'app' -> 'models', 'schemas', 'api', 'core', 'db'. I didn't see 'crud'.
    # I should verify if CRUD exists. If not, I'll do it inline for now or create CRUD.
    # For now, I'll assume standard direct query since I didn't see CRUD.
    
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not security.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect email or password",
        )
    elif not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Inactive user",
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    return {
        "access_token": security.create_access_token(
            user.id, expires_delta=access_token_expires
        ),
        "token_type": "bearer",
    }
