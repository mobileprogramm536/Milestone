import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color(0xFF1C1C1E),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gizlilik Politikası',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Milestone olarak, kullanıcılarımızın gizliliğini korumayı taahhüt ediyoruz. '
                    'Bu gizlilik politikası, hangi verileri topladığımızı, nasıl kullandığımızı ve '
                    'hangi haklara sahip olduğunuzu açıklamaktadır.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Toplanan Veriler',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '- Kişisel bilgiler: Ad, soyad, e-posta adresi.\n'
                    '- Konum bilgileri: Rota planlama ve paylaşma için.\n'
                    '- Cihaz bilgileri: IP adresi ve cihaz modeli.\n'
                    '- Kullanım bilgileri: Oluşturulan rotalar ve favorilere eklenen yerler.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Verilerin Kullanımı',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Toplanan veriler, kullanıcı deneyimini iyileştirmek, kişiselleştirilmiş öneriler '
                    'sunmak ve güvenlik sağlamak amacıyla kullanılmaktadır.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'İletişim Bilgileri',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Sorularınız için bizimle iletişime geçin: mobileprogramm536@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
