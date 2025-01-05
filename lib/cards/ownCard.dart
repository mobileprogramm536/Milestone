import 'package:flutter/material.dart';

class ReusableCard extends StatefulWidget {
  final String profileImageUrl; // Profil fotoğrafının URL'si
  String title; // Başlık
  String description; // Açıklama metni
  String location; // Konum
  int destinationCount; // Destination sayısı
  int likes; // Beğeni sayısı
  final VoidCallback onProfileTap; // Profil fotoğrafına tıklandığında çağrılacak fonksiyon
  final VoidCallback onLikeTap; // Beğeni ikonuna tıklandığında çağrılacak fonksiyon
  final VoidCallback onCardTap; // Kartın herhangi bir yerine tıklandığında çağrılacak fonksiyon

  ReusableCard({
    super.key,
    required this.profileImageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.destinationCount,
    required this.likes,
    required this.onProfileTap,
    required this.onLikeTap,
    required this.onCardTap, required IconButton editIcon,
  });

  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  // Düzenleme ekranını açan fonksiyon
  void _editCard(BuildContext context) {
    TextEditingController titleController =
    TextEditingController(text: widget.title);
    TextEditingController descriptionController =
    TextEditingController(text: widget.description);
    TextEditingController locationController =
    TextEditingController(text: widget.location);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kartı Düzenle",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Başlık
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Başlık",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Açıklama
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Açıklama",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Konum
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: "Konum",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Kaydet Butonu
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.title = titleController.text;
                      widget.description = descriptionController.text;
                      widget.location = locationController.text;
                    });
                    Navigator.pop(context); // Modalı kapat
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Kaydet",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardTap, // Kartın herhangi bir noktasına tıklandığında çalışacak
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.33,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              // Profil Fotoğrafı
              GestureDetector(
                onTap: widget.onProfileTap,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(widget.profileImageUrl),
                ),
              ),
              const SizedBox(width: 16),

              // Başlık ve Açıklama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Düzenleme İkonu
              GestureDetector(
                onTap: () => _editCard(context),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
