# Engelsiz Alışveriş Asistanı - Ekip Çalışma Planı

Bu belge, proje ekibinin görev dağılımı, çalışma yöntemleri ve projeye katkı sağlama süreçlerini düzenlemek için hazırlanmıştır.

## 1. Görev Dağılımı (Roller)

Projenin teknik yelpazesi (Flutter & Python) nedeniyle ekibi iki ana uzmanlık alanına ayırmak verimli olacaktır.
**Planlanan Ekip:** 2 Mobil Geliştirici, 3 Backend Geliştirici.

### 📱 Mobil Ekibi (Flutter - 2 Kişi)
**Hedef:** Son kullanıcıya hitap eden, erişilebilir (TalkBack/VoiceOver uyumlu) ve akıcı bir deneyim sunmak.

*   **Üye 1 (Arayüz & Erişilebilirlik Sorumlusu):**
    *   Sayfa tasarımlarının koda dökülmesi.
    *   **Semantics** widget'ları ile uygulamanın körler için tam uyumlu çalışmasını sağlamak.
    *   Renk kontrastları ve buton büyüklüklerini ayarlamak.
    *   **TTS (Metin Okuma)** entegrasyonunu yönetmek.
*   **Üye 2 (Fonksiyon & Entegrasyon Sorumlusu):**
    *   Backend API ile haberleşme servisini yazmak (`Dio` / `Http`).
    *   **Kamera & Barkod** kütüphanelerini entegre etmek.
    *   State Management (Durum Yönetimi) yapısını kurmak (Örn: Provider veya Riverpod).

### 🖥️ Backend Ekibi (Python/FastAPI - 3 Kişi)
**Hedef:** Hızlı, güvenli ve doğru data sağlayan bir servis mimarisi kurmak.

*   **Aleyna (API & Veritabanı Mimarı):**
    *   Veritabanı modellerini (`SQLAlchemy`) tasarlamak ve yönetmek (Migration işlemleri).
    *   Temel API uçlarını (Endpoint) yazmak (Ürün ekle, getir, listele).
    *   Projenin genel mimarisini ve klasör yapısını kurmak.
*   **Yusuf (Güvenlik & Admin Paneli Sorumlusu):**
    *   Kullanıcı yetkilendirme (Auth) ve güvenlik (JWT) işlemlerini yapmak.
    *   Admin paneli için gerekli raporlama ve yönetim servislerini hazırlamak.
    *   Loglama ve hata yakalama mekanizmalarını kurmak.
*   **Emre (Veri & Yapay Zeka/Görüntü İşleme Sorumlusu):**
    *   Ürün verilerini zenginleştirmek (Web scraping veya dataset işlemleri).
    *   AI modelini API'ye bağlamak ve görüntü işleme servislerini yazmak.
    *   Veritabanı performans optimizasyonu ve cache mekanizmaları (Redis vb.).

----

### Mobil Tarafı
- [ ] **Google ML Kit Entegrasyonu:** Barkod okuma özelliğinin stabil çalıştırılması.
- [ ] **TTS (Sesli Okuma) Senaryoları:** Uygulama açılınca "Hoşgeldiniz", ürün bulununca "Ürün adı: Süt, Fiyatı: 20 TL" gibi sesli geri bildirimlerin tüm akışa eklenmesi.
- [ ] **Ayarlar Sayfası:** Konuşma hızı, ses tonu gibi erişilebilirlik ayarlarının yapılması.

### Backend Tarafı
- [ ] **Ürün Veritabanının Dolması:** Test için en az 50-100 adet gerçek barkodlu ürün verisi girilmesi. (Barkod, İsim, Fiyat, Gramaj).
- [ ] **Resim Upload Servisi:** Ürünlere fotoğraf yüklenebilmesi için API desteği.
- [ ] **Favoriler/Geçmiş:** Kullanıcının daha önce okuttuğu ürünleri kaydeden mekanizma.

---

## 3. Çalışma Yöntemi (Nasıl Katkı Sağlanır?)

Ekip üyelerinin birbirinin kodunu bozmadan çalışabilmesi için **Git Flow** (Dallanma Stratejisi) uygulanmalıdır.

### Adım 1: Görev Seçimi
Trello, Notion veya GitHub Projects üzerinde yapılacak işler kartlar halinde açılır.
*   Örn: "Barkod okuma ekranı yapılacak", "Login API yazılacak".

### Adım 2: Branch (Dal) Açma
Kimse doğrudan `main` (ana) dala kod yazmamalıdır. Herkes yapacağı iş için yeni bir dal açar:
*   `feature/barkod-okuma`
*   `backend/urun-api`
*   `fix/login-hatasi`

```bash
git checkout -b feature/yeni-ozellik-adi
```

### Adım 3: Geliştirme ve Test
Kişi kendi bilgisayarında geliştirmesini yapar ve test eder.

### Adım 4: Pull Request (PR) Gönderme
İş bitince kodlar GitHub'a yüklenir (`git push`) ve **Pull Request** açılır.
*   **Kural:** En az 1 diğer ekip üyesi kodu inceleyip (Code Review) onaylamadan `main` dala birleştirilmez. Bu sayede hatalı kodun projeyi bozması engellenir.

### Adım 5: Birleştirme (Merge)
Onaylanan kodlar proje yöneticisi tarafından ana projeye dahil edilir.

---

## 4. Projeye Yeni Özellik Ekleme/Çıkarma

Bir ekip üyesi "Şunu da ekleyelim" dediğinde şu sorular sorulmalıdır:

1.  **Hedef Kitleye Uygun mu?** (Görme engelli bir birey bunu rahatça kullanabilir mi?)
2.  **Maliyeti Ne?** (Bu özellik uygulamanın açılış hızını yavaşlatır mı? Çok fazla veri harcar mı?)

**Örnek Senaryo:**
*   **Fikir:** "Uygulamaya video oynatıcı ekleyelim."
*   **Karar:** Görme engelli odaklı olduğumuz için video yerine gelişmiş *sesli betimleme* eklemek daha doğru olur. Video özelliği elenir.

**Öneri:** Her hafta 1 "Refinement" (İyileştirme) toplantısı yapıp gereksiz kodlar temizlenmeli ve yeni fikirler oylanmalıdır.
