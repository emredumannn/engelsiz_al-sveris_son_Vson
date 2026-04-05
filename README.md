# Engelsiz Alışveriş Asistanı

Görme engelli bireyler için sesli asistan destekli alışveriş uygulaması.

## Proje Yapısı

- **backend/**: FastAPI (Python) ile yazılmış sunucu tarafı.
- **mobile/**: Flutter (Dart) ile yazılmış mobil uygulama.

## Kurulum

### Backend Kurulumu (Güvenlik Güncellemesi Sonrası)
1. `backend` klasörüne gidin.
2. `.env.example` dosyasının ismini `.env` yapın veya yeni bir `.env` dosyası oluşturup aşağıdaki bilgileri doldurun:
   ```env
   SECRET_KEY=rastgele_guclu_bir_anahtar_olusturun
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=veritabani_sifreniz
   POSTGRES_SERVER=localhost
   POSTGRES_DB=engelsiz_db
   BACKEND_CORS_ORIGINS=["http://localhost:8000"]
   ```
3. `venv\Scripts\activate.bat` ile sanal ortamı aktif edin.
4. `run_backend.bat` dosyasını çalıştırın veya `uvicorn main:app --reload` yazın.

### Mobile
`mobile` klasöründe `flutter run` komutunu kullanın.

## 📱 Uygulamayı Telefonda Açma (Ekstra)
Eğer uygulamayı bilgisayarınızdan yayınlayıp telefondan girmek isterseniz (En sağlıklı yöntem):
1. `mobile` klasöründe şu komutu çalıştırın (Tek seferlik derleme yapar):
   `flutter build web --release --web-renderer html`
2. Derleme bitince şu komutu çalıştırın (Sunucuyu başlatır):
   `cd build/web && python -m http.server 8080`
3. Yeni bir terminal açıp proje ana dizininde şu komutu yazın:
   `npx localtunnel --port 8080`
4. Size verilen linki (`https://....loca.lt`) telefondan açın.
Yusuf Serhat Tümtürk