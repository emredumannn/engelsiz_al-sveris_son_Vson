from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.core.config import settings

# PostgreSQL connection string
# SQLALCHEMY_DATABASE_URL = f"postgresql://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}@{settings.POSTGRES_SERVER}/{settings.POSTGRES_DB}"

connect_args = {}
if "sqlite" in settings.SQLALCHEMY_DATABASE_URI:
    connect_args["check_same_thread"] = False

engine = create_engine(
    settings.SQLALCHEMY_DATABASE_URI, 
    connect_args=connect_args
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
