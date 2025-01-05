import 'package:flutter/material.dart';
import '../services/route_service.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import '../widgets/save_route_dialog.dart'; // Kaydetme dialogu

class ExploreMorePage extends StatefulWidget {
  const ExploreMorePage({super.key});

  @override
  State<ExploreMorePage> createState() => _ExploreMorePageState();
}

class _ExploreMorePageState extends State<ExploreMorePage> {
  final RouteService routeService = RouteService();
  List<RouteCard> exploreMoreRoutes = []; // Firebase’den çekilecek rotalar
  bool isLoading = true; // Yüklenme durumu

  @override
  void initState() {
    super.initState();
    _fetchExploreMoreData(); // Firebase’den verileri yükle
  }

  // Firebase’den verileri çekme işlemi
  Future<void> _fetchExploreMoreData() async {
    try {
      // Route ID'leri al
      List<RouteCard> routeIds = await routeService.getExploreRoutes();

      // Her bir ID için RouteCard al ve listeye ekle
      List<RouteCard> routes = [];
      for (var routeId in routeIds) {
        RouteCard? route = await routeService.getRouteCard(routeId as String);
        if (route != null) {
          routes.add(route);
        }
      }

      setState(() {
        exploreMoreRoutes = routes; // Listeyi güncelle
        isLoading = false; // Yüklenme tamamlandı
      });
    } catch (e) {
      print("Veriler alınamadı: $e");
      setState(() {
        isLoading = false; // Hata durumunda yüklenmeyi tamamla
      });
    }
  }

  void _showSaveDialog(BuildContext context, String routeId) {
    showDialog(
      context: context,
      builder: (context) => SaveRouteDialog(routeId: routeId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkgrey1,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: appBackground,
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.05), // Üst boşluk
            const Text(
              "Keşfetmeye Devam Et",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16), // Başlık boşluğu

            // Rota Kartları (Firebase’den Çekilen Veriler)
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator()) // Yüklenme göstergesi
                  : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // İki sütunlu grid
                  childAspectRatio: 0.75, // Kart boyutu oranı
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: exploreMoreRoutes.length,
                itemBuilder: (context, index) {
                  final route = exploreMoreRoutes[index];
                  return GestureDetector(
                    onTap: () => _showSaveDialog(context, route.routeOwnerId!),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: AppColors.darkgrey2, // Kart arka plan rengi
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profil Fotoğrafı
                            CircleAvatar(
                              backgroundImage: route.pfpurl != null
                                  ? NetworkImage(route.pfpurl!)
                                  : null,
                              radius: 30,
                              child: route.pfpurl == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(height: 8),

                            // Başlık
                            Text(
                              route.title ?? "Rota Başlığı",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Açıklama
                            Text(
                              route.description ?? "Açıklama",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Destinasyon ve Beğeni Sayısı
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.flag, color: Colors.yellow, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${route.destinationcount} destinasyon",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${route.likecount}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
