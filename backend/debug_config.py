try:
    from app.core.config import settings
    print("Config loaded successfully!")
    print(f"DB User: {settings.POSTGRES_USER}")
except Exception as e:
    print(f"Error loading config: {e}")
