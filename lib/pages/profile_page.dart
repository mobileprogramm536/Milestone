import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:milestone/pages/settings_page.dart';

import '../widgets/custom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _deleteRoute(String routeId) async {
    // Onay diyaloğu
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Silme İşlemi"),
        content: const Text("Bu rotayı silmek istediğinizden emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // İptal
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Onay
            child: const Text("Evet"),
          ),
        ],
      ),
    );

    if (confirmDelete != true) return;

    // Firestore’dan silme işlemi
    try {
      await _firestore
          .collection('routes')
          .doc(routeId)
          .delete(); // Firestore’dan belgeyi sil
      setState(() {
        userRoutes.removeWhere(
            (route) => route['id'] == routeId); // Listeden de kaldır
      });
      _showSuccessMessage("Rota başarıyla silindi!");
    } catch (e) {
      _showErrorMessage("Rota silinemedi: $e");
    }
  }

  static List<String> _generateAvatarList(String gender, int count) {
    return List.generate(
        count, (index) => 'assets/images/${gender}avatar${index + 1}.png');
  }

  final List<String> femaleAvatars = _generateAvatarList('female', 18);
  final List<String> maleAvatars = _generateAvatarList('male', 20);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  String? profileImageUrl;
  String username = "";
  int followers = 0;
  int routes = 0;
  String badgeAsset = 'assets/rozets/caylak.png'; // Varsayılan rozet

  List<Map<String, dynamic>> userRoutes = []; // Kullanıcının rotaları
  bool isLoading = true; // Yüklenme durumu

  int _selectedIndex = 3;

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected Index: $index');
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserRoutes(); // Rotaları yükle
  }

  Future<void> _loadUserRoutes() async {
    if (user == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('routes')
          .where('routeUser',
              isEqualTo:
                  user!.uid) // Burada kontrol 'routeUser' üzerinden yapılır.
          .get();

      setState(() {
        userRoutes = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'routeName': doc['routeName'] ?? '', // Varsayılan olarak boş string
            'description':
                doc['description'] ?? '', // Varsayılan olarak boş string

            'place': (doc['locations'] != null &&
                    doc['locations'] is List &&
                    doc['locations'].isNotEmpty)
                ? doc['locations'][0]['place'] ?? ''
                : 'Konum belirtilmemiş',

            'likes': doc['likeCount'] ?? 0, // Beğeni sayısını ekle
            'destinationCount':
                doc['locations'] != null && doc['locations'] is List
                    ? (doc['locations'] as List).length
                    : 0, // Lokasyon sayısını kontrol et, null ise 0 yap
          };
        }).toList();

        isLoading = false; // Yüklenme tamamlandı
      });
    } catch (e) {
      _showErrorMessage("Rotalar yüklenemedi: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF2D2D2D), // Kart arka plan rengi
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kart Başlığı
              Text(
                route['routeName'], // Rota adı
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Açıklama
              Text(
                route['description'], // Açıklama
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Destination Sayısı
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.yellow, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${route['destinationCount']} destinasyon",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Beğeni ve Çöp İkonu
                  Row(
                    children: [
                      // Beğeni
                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${route['likes']} beğeni",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16), // Boşluk

                      // Çöp İkonu
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteRoute(
                            route['id']), // Silme fonksiyonunu çağır
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserProfile() async {
    String badgeAsset = 'assets/rozets/default.png'; // Varsayılan rozet

    if (user == null) {
      _showErrorMessage("Lütfen giriş yapın!");
      return;
    }

    try {
      // Firestore'dan kullanıcı verilerini al
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          int userLevel = data['userlevel'] ?? 0; // Seviyeyi al
          if (userLevel >= 6) {
            badgeAsset = 'assets/rozets/efsanevi.png';
          } else if (userLevel >= 5) {
            badgeAsset = 'assets/rozets/kasif.png';
          } else if (userLevel >= 4) {
            badgeAsset = 'assets/rozets/deneyimli.png';
          } else if (userLevel >= 3) {
            badgeAsset = 'assets/rozets/maceracı.png';
          } else if (userLevel >= 2) {
            badgeAsset = 'assets/rozets/meraklı.png';
          } else if (userLevel >= 1) {
            badgeAsset = 'assets/rozets/caylak.png';
          }

          // Firestore'dan gelen verileri güncelle
          username = data['name'] ?? "Kullanıcı";
          followers = data['followers'] ?? 0;
          routes = data['routes'] is int ? data['routes'] : 0;

          // Eğer profil resmi yoksa varsayılan avatarı ata
          profileImageUrl = data['profileImage']?.isNotEmpty == true
              ? data['profileImage']
              : femaleAvatars[0];
        });
      } else {
        _showErrorMessage("Kullanıcı verisi bulunamadı!");
      }
    } catch (e) {
      _showErrorMessage("Kullanıcı verisi yüklenirken hata oluştu: $e");
    }
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Kadın"),
                  Tab(text: "Erkek"),
                ],
              ),
              SizedBox(
                height: 300, // BottomSheet boyutunu sınırlandırmak için
                child: TabBarView(
                  children: [
                    _buildAvatarGrid(femaleAvatars),
                    _buildAvatarGrid(maleAvatars),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarGrid(List<String> avatars) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: avatars
              .map(
                (avatarPath) => GestureDetector(
                  onTap: () => _updateProfileImage(avatarPath),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatarPath),
                    radius: 30,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _updateProfileImage(String avatarPath) async {
    Navigator.of(context).pop();
    try {
      await _firestore.collection('users').doc(user!.uid).update({
        'profileImage': avatarPath,
      });
      setState(() {
        profileImageUrl = avatarPath;
      });
      _showSuccessMessage("Avatar başarıyla güncellendi!");
    } catch (e) {
      _showErrorMessage("Avatar güncellenemedi: $e");
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        title: const Text("Profile (My Routes)"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings,
                color: Colors.white), // Ayarlar ikonu
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SettingsPage()), // Ayarlar sayfasına git
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Yükleniyor göstergesi
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar ve Kullanıcı Bilgileri
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Bileşenleri en sola ve en sağa hizala
                      children: [
                        // Avatar ve Kullanıcı Bilgileri
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _showAvatarSelection,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                    profileImageUrl ?? femaleAvatars[0]),
                              ),
                            ),
                            const SizedBox(
                                width: 16), // Avatar ve yazılar arasında boşluk
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "$followers takipçi",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                Text(
                                  "$routes rota",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Rozet - Satırın sonuna (en sağa) yerleştirildi
                        CircleAvatar(
                          radius: 30, // Rozet boyutu ayarlanabilir
                          backgroundImage:
                              AssetImage(badgeAsset), // Rozet resmi
                        ),
                      ],
                    )),

                const SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Daha küçük boşluk
                  child: Divider(
                    color: Colors.white
                        .withOpacity(0.2), // Hafif daha şeffaf çizgi
                    thickness: 0.8, // İnceltilmiş çizgi
                    indent: 20, // Daha dar boşluk
                    endIndent: 20,
                  ),
                ),

                // Kullanıcının Rotası
                Expanded(
                    child: userRoutes.isEmpty
                        ? const Center(
                            child: Text(
                              "Henüz rota eklenmedi!",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            itemCount: userRoutes.length,
                            itemBuilder: (context, index) {
                              final route = userRoutes[index];
                              return _buildRouteCard(
                                  route); // Yeni fonksiyonu çağır
                            },
                          )),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10.0),
        child: Container(
          height: height * 0.08,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: CustomNavBar(
            onItemSelected: _onNavBarItemSelected,
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}
