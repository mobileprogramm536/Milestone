import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color(0xFF1C1C1E),
        iconTheme: const IconThemeData(color: Colors.white), // Geri butonu rengi beyaz
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Biz Kimiz?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Font rengi beyaz
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Milestone, seyahat severlerin keşiflerini daha keyifli ve planlı hale '
                    'getirmek için geliştirilmiş bir mobil uygulamadır. Amacımız, kullanıcılarımıza '
                    'en iyi rota planlama ve paylaşma deneyimini sunarak dünyayı keşfetmelerini '
                    'kolaylaştırmaktır.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Font rengi beyaz
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Misyonumuz',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Font rengi beyaz
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kullanıcılarımızın hem kendi oluşturdukları rotalarla hem de diğer '
                    'gezginlerin önerilerini değerlendirerek eşsiz seyahat deneyimleri '
                    'yaşamalarını sağlamak.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Font rengi beyaz
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Vizyonumuz',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Font rengi beyaz
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Seyahat planlamasında lider bir platform olmak ve kullanıcılarımızın '
                    'dünya üzerindeki her köşeyi keşfetmelerine ilham vermek. Sunduğumuz '
                    'teknolojilerle insanların seyahat deneyimlerini daha kolay, keyifli ve '
                    'güvenilir hale getirmek.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Font rengi beyaz
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


