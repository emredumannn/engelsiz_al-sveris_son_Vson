import sys
import os
sys.path.append(os.getcwd())

from app.db.session import SessionLocal
from app.api.v1.endpoints.products import read_products
from fastapi.encoders import jsonable_encoder

def debug():
    db = SessionLocal()
    try:
        print("Calling read_products...")
        # Mocking skip/limit defaults
        products = read_products(skip=0, limit=100, db=db)
        print("read_products executed successfully.")
        print(f"Result type: {type(products)}")
        
        # Test serialization if it wasn't done inside read_products (it is done for cache side effect)
        # But wait, read_products calls jsonable_encoder internally for cache set.
        
        print("Done.")
    except Exception as e:
        print("\n!!! CAUGHT EXCEPTION !!!")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    debug()
