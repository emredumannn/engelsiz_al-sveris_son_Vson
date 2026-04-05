import redis
from app.core.config import settings
import json
from typing import Optional, Any

class CacheService:
    _redis_client = None

    @classmethod
    def get_client(cls):
        if cls._redis_client is None:
            try:
                cls._redis_client = redis.from_url(settings.REDIS_URL, decode_responses=True)
                # Test connection
                cls._redis_client.ping()
                print("[INFO] Redis baglantisi basarili.")
            except Exception as e:
                print(f"[WARNING] Redis baglantisi basarisiz. Onbellekleme devre disi. Hata: {e}")
                cls._redis_client = None
        return cls._redis_client

    @staticmethod
    def get(key: str) -> Optional[Any]:
        client = CacheService.get_client()
        if client:
            try:
                data = client.get(key)
                return json.loads(data) if data else None
            except Exception as e:
                print(f"Redis Okuma Hatası: {e}")
        return None

    @staticmethod
    def set(key: str, value: Any, expire: int = 300):
        client = CacheService.get_client()
        if client:
            try:
                client.setex(key, expire, json.dumps(value))
            except Exception as e:
                print(f"Redis Yazma Hatası: {e}")

    @staticmethod
    def delete_prefix(prefix: str):
        """Belirli bir prefix ile başlayan tüm keyleri siler (Cache Invalidation)"""
        client = CacheService.get_client()
        if client:
            try:
                keys = client.keys(f"{prefix}*")
                if keys:
                    client.delete(*keys)
            except Exception as e:
                 print(f"Redis Silme Hatası: {e}")
