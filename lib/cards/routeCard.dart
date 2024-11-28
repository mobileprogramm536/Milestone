import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final String profileImageUrl; // Profil fotoğrafının URL'si
  final String title; // Başlık
  final String description; // Açıklama metni
  final String location; // Konum
  final int destinationCount; // Destination sayısı
  final int likes; // Beğeni sayısı
  final VoidCallback onProfileTap; // Profil fotoğrafına tıklandığında çağrılacak fonksiyon
  final VoidCallback onLikeTap; // Beğeni ikonuna tıklandığında çağrılacak fonksiyon
  final VoidCallback onCardTap; // Kartın herhangi bir yerine tıklandığında çağrılacak fonksiyon

  const ReusableCard({
    super.key,
    required this.profileImageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.destinationCount,
    required this.likes,
    required this.onProfileTap,
    required this.onLikeTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap, // Kartın herhangi bir noktasına tıklandığında çalışacak
      child: FractionallySizedBox(
        widthFactor: 0.9, // Genişlik ekranın %90'ı
        heightFactor: 0.33, // Yükseklik ekranın üçte biri
        child: Container(
          padding: const EdgeInsets.all(16), // İçerik için kenar boşluğu
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D), // Gri arka plan rengi
            borderRadius: BorderRadius.circular(20), // Kenarları yuvarlatma
          ),
          child: Row(
            children: [
              // Profil Fotoğrafı (Buton)
              GestureDetector(
                onTap: onProfileTap, // Tıklama eylemi
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
              ),
              const SizedBox(width: 16), // Fotoğraf ve metin arasında boşluk

              // Başlık ve Açıklama Bölgesi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Başlık
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8), // Başlık ve açıklama arası boşluk

                    // Açıklama
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konum ve Destination Sayısı
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          "$destinationCount destination",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Beğeni Sayısı (Buton)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onLikeTap, // Tıklama eylemi
                    child: const Icon(Icons.favorite, color: Colors.red, size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    likes.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
