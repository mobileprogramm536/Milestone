import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'personal_details_page.dart';
import 'about_us_page.dart';
import 'privacy_policy_page.dart';
import 'singIn_page.dart'; // Giriş yapma sayfası

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: const Color(0xFF1C1C1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Geri dön
          },
        ),
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hesap Başlığı
            const Text(
              "Hesap",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Kişisel Detaylar
            _buildMenuItem(
              context,
              title: "Kişisel Detaylar",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalDetailsPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // Milestone Başlığı
            const Text(
              "Milestone",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Bizim Hakkımızda
            _buildMenuItem(
              context,
              title: "Bizim Hakkımızda",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutUsPage()),
                );
              },
            ),

            // Gizlilik Politikası
            _buildMenuItem(
              context,
              title: "Gizlilik Politikası",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage()),
                );
              },
            ),

            const Spacer(),

            // Çıkış Yap Butonu
            _buildLogoutButton(context),

            const SizedBox(height: 10),

            // Hesabı Sil
            Center(
              child: TextButton(
                onPressed: () => _showPasswordDialog(context), // Şifre girişi ekranı
                child: const Text(
                  "Hesabı Sil",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menü Öğesi Widget
  Widget _buildMenuItem(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // Çıkış Yap Butonu
  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut(); // Firebase'den çıkış yap
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
                (route) => false,
          ); // Giriş sayfasına yönlendir
        },
        child: const Text(
          "Çıkış Yap",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Hesabı Silmek için Şifre Sor Dialog'u
  Future<void> _showPasswordDialog(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E), // Arka plan rengi
        title: const Text(
          'Kimlik Doğrulama',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Şifrenizi girin',
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, passwordController.text);
            },
            child: const Text('Onayla', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ).then((password) {
      if (password != null && password.isNotEmpty) {
        _deleteAccount(context, password); // Şifre ile doğrulama
      }
    });
  }

  // Hesabı Silme İşlemi
  Future<void> _deleteAccount(BuildContext context, String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      // Kullanıcıyı yeniden doğrula
      await user.reauthenticateWithCredential(credential);

      // Hesabı sil
      await user.delete();

      // Başarılıysa giriş ekranına yönlendir
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hesap silinemedi: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

