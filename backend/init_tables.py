import sys
import os

# Add the backend directory to the sys.path so we can import 'app'
# Assuming this script is run from 'backend/' directory
sys.path.append(os.getcwd())

from app.db.session import engine
from app.db.base_class import Base
from app.models.product import Product
from app.models.user import User
from app.models.favorite import Favorite

def init_db():
    print("Veritabani tablolari olusturuluyor...")
    Base.metadata.create_all(bind=engine)
    print("Tablolar basariyla olusturuldu!")

if __name__ == "__main__":
    init_db()
