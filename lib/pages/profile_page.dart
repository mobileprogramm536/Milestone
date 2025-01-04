import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  String? profileImageUrl;
  String username = "";
  int followers = 0;
  int routes = 0;

  // Avatar listeleri
  final List<String> femaleAvatars = [
    'assets/images/femaleavatar1.png',
    'assets/images/femaleavatar2.png',
    'assets/images/femaleavatar3.png',
    'assets/images/femaleavatar4.png',
    'assets/images/femaleavatar5.png',
    'assets/images/femaleavatar6.png',
    'assets/images/femaleavatar7.png',
    'assets/images/femaleavatar8.png',
    'assets/images/femaleavatar9.png',
    'assets/images/femaleavatar10.png',
    'assets/images/femaleavatar11.png',
    'assets/images/femaleavatar12.png',
    'assets/images/femaleavatar13.png',
    'assets/images/femaleavatar14.png',
    'assets/images/femaleavatar15.png',
    'assets/images/femaleavatar16.png',
    'assets/images/femaleavatar17.png',
    'assets/images/femaleavatar18.png',
  ];

  final List<String> maleAvatars = [
    'assets/images/maleavatar1.png',
    'assets/images/maleavatar2.png',
    'assets/images/maleavatar3.png',
    'assets/images/maleavatar4.png',
    'assets/images/maleavatar5.png',
    'assets/images/maleavatar6.png',
    'assets/images/maleavatar7.png',
    'assets/images/maleavatar8.png',
    'assets/images/maleavatar9.png',
    'assets/images/maleavatar10.png',
    'assets/images/maleavatar11.png',
    'assets/images/maleavatar12.png',
    'assets/images/maleavatar13.png',
    'assets/images/maleavatar14.png',
    'assets/images/maleavatar15.png',
    'assets/images/maleavatar16.png',
    'assets/images/maleavatar17.png',
    'assets/images/maleavatar18.png',
    'assets/images/maleavatar19.png',
    'assets/images/maleavatar20.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (user == null) {
      _showErrorMessage("Lütfen giriş yapın!");
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          username = data['name'] ?? "Kullanıcı";
          followers = data['followers'] ?? 0;
          routes = data['routes'] ?? 0;
          profileImageUrl = data['profileImage'] ?? femaleAvatars[0];
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
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        title: const Text("Profile (My Routes)"),
        centerTitle: true,
      ),
      body: profileImageUrl == null && username.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showAvatarSelection,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage(profileImageUrl ?? femaleAvatars[0]),
                        ),
                      ),
                      const SizedBox(width: 16),
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
                            "${followers} takipçi",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                          Text(
                            "${routes} rota",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
