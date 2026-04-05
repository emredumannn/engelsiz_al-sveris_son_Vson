from fastapi import APIRouter, File, UploadFile
import shutil
import os

router = APIRouter()

@router.post("/upload-image/")
async def upload_image(file: UploadFile = File(...)):
    os.makedirs("static", exist_ok=True)
    file_location = f"static/{file.filename}"
    with open(file_location, "wb+") as file_object:
        shutil.copyfileobj(file.file, file_object)
    
    # URL'yi oluştur - Gerçek ortamda domain/ip olmalı
    # Şimdilik localhost üzerinden örnek veriyoruz
    base_url = "http://127.0.0.1:8000" 
    return {"info": "Resim yüklendi", "url": f"{base_url}/static/{file.filename}"}
