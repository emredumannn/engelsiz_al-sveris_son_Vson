@echo off
echo Engelsiz Alisveris Backend Baslatiliyor...
cd backend
echo Sanal ortam (venv) kontrol ediliyor...
if not exist "venv" (
    echo Sanal ortam bulunamadi, olusturuluyor...
    python -m venv venv
    echo Bagimliliklar yukleniyor...
    call venv\Scripts\activate
    pip install -r requirements.txt
) else (
    call venv\Scripts\activate
)

echo Sunucu baslatiliyor (http://localhost:8000)...
timeout /t 3 >nul
start "" "http://localhost:8000"
uvicorn main:app --reload --host 0.0.0.0 --port 8000
pause
