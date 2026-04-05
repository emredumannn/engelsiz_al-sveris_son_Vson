import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Hesabım ve Ayarlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kişisel Bilgiler Kartı
            _buildSectionCard(
              title: 'Kişisel Bilgiler',
              icon: Icons.person,
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kullanıcı: ${auth.userName}', style: const TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 16),
                    const Text('Alerjen Uyarılarım:', style: TextStyle(color: Colors.white70, fontSize: 18)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: auth.availableAllergens.map((allergen) {
                        final isSelected = auth.allergens.contains(allergen);
                        return Semantics(
                          label: '$allergen uyarısı ${isSelected ? "Aktif" : "Kapalı"}',
                          button: true,
                          child: FilterChip(
                            label: Text(allergen, style: TextStyle(fontSize: 16, color: isSelected ? Colors.black : Colors.white)),
                            selectedColor: AppTheme.accentColor,
                            backgroundColor: AppTheme.surfaceColor,
                            selected: isSelected,
                            onSelected: (bool selected) {
                              auth.toggleAllergen(allergen);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ayarlar Kartı
            _buildSectionCard(
              title: 'Ayarlar',
              icon: Icons.settings,
              child: Column(
                children: [
                   Semantics(
                     button: true,
                     label: 'Sesli Okuma (TTS) Ayarları',
                     child: ListTile(
                       contentPadding: EdgeInsets.zero,
                       leading: const Icon(Icons.volume_up, color: Colors.white),
                       title: const Text('Sesli Okuma Ayarları', style: TextStyle(color: Colors.white, fontSize: 18)),
                       trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
                       onTap: () {
                         // Gelecekte hız ve ses seviyesi ayarı sayfası eklenecek
                       },
                     ),
                   ),
                   const Divider(color: Colors.white24),
                   Semantics(
                     button: true,
                     label: 'Görünüm ve Kontrast Ayarları',
                     child: ListTile(
                       contentPadding: EdgeInsets.zero,
                       leading: const Icon(Icons.contrast, color: Colors.white),
                       title: const Text('Görünüm",', style: TextStyle(color: Colors.white, fontSize: 18)),
                       trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
                       onTap: () {},
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Yardım Kartı (SOS)
            Consumer<AuthProvider>(
              builder: (context, auth, _) => Semantics(
                label: 'Acil Yardım Çağır',
                button: true,
                child: ElevatedButton.icon(
                  onPressed: () => auth.triggerSOS(),
                  icon: const Icon(Icons.warning, size: 36, color: Colors.white),
                  label: const Text('Mağaza İçi Yardım Çağır (SOS)', textAlign: TextAlign.center),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.dangerColor, // Kırmızı
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Çıkış Yap
            Semantics(
               label: 'Hesaptan Çıkış Yap',
               button: true,
               child: OutlinedButton.icon(
                 onPressed: () {
                   context.read<AuthProvider>().logout();
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                 },
                 icon: const Icon(Icons.logout, color: AppTheme.accentColor),
                 label: const Text('Çıkış Yap'),
                 style: OutlinedButton.styleFrom(
                   foregroundColor: AppTheme.accentColor,
                   side: const BorderSide(color: AppTheme.accentColor, width: 2),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                 ),
               ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: AppTheme.accentColor),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const Divider(color: Colors.white24, height: 32, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }
}
