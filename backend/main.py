from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
import logging
import time

from app.core.config import settings
from app.api.v1.api import api_router

# Logging Setup
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    description="Görme engelli bireyler için sesli asistan ve alışveriş API servisi."
)

from fastapi.staticfiles import StaticFiles
import os
os.makedirs("static", exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = (time.time() - start_time) * 1000
    formatted_process_time = "{0:.2f}".format(process_time)
    logger.info(f"path={request.url.path} method={request.method} status={response.status_code} duration={formatted_process_time}ms")
    return response

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Global error occurred: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"message": "Internal Server Error"},
    )


app.include_router(api_router, prefix=settings.API_V1_STR)


# Güvenlik: CORS Ayarları
# Mobil uygulamanın API ile konuşabilmesi için gereklidir.
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

@app.get("/", response_class=HTMLResponse)
async def root():
    return """
    <!DOCTYPE html>
    <html lang="tr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Engelsiz Alışveriş API</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; text-align: center; padding: 50px; background-color: #f0f2f5; }
            h1 { color: #2c3e50; }
            p { color: #555; }
            a { display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; }
            a:hover { background-color: #0056b3; }
        </style>
    </head>
    <body>
        <h1>Engelsiz Alışveriş Asistanı API</h1>
        <p>Arka uç servisi sorunsuz çalışıyor. 🚀</p>
        <p>API dokümantasyonuna ve test ekranına gitmek için aşağıdaki butona tıklayın.</p>
        <a href="/docs">API Dokümantasyonu (Swagger)</a>
    </body>
    </html>
    """

@app.get("/health")
async def health_check():
    """
    Load Balancer veya Kubernetes için sağlık kontrol noktası.
    """
    return {"status": "healthy"}
