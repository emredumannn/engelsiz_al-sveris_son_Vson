import requests
from typing import Optional, Dict, Any

class EnrichmentService:
    BASE_URL = "https://world.openfoodfacts.org/api/v2/product"

    @staticmethod
    def fetch_product_data(barcode: str) -> Optional[Dict[str, Any]]:
        """
        Fetches product data from OpenFoodFacts API using the barcode.
        """
        try:
            url = f"{EnrichmentService.BASE_URL}/{barcode}.json"
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                data = response.json()
                if data.get("status") == 1:
                    product = data.get("product", {})
                    return {
                        "name": product.get("product_name"),
                        "brand": product.get("brands"),
                        "image_url": product.get("image_url"),
                        "ingredients": product.get("ingredients_text"),
                        "allergen_info": product.get("allergens"),
                        "nutritional_values": product.get("nutriscore_grade"), # Simplified for now
                        "category": product.get("categories", "").split(",")[0] if product.get("categories") else None
                    }
            return None
        except Exception as e:
            print(f"Error fetching data for {barcode}: {e}")
            return None
