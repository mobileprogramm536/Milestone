import 'package:flutter/material.dart';

class EditRoutePage extends StatefulWidget {
  final Map<String, dynamic> routeData; // Düzenlenecek rota verisi
  final Function(Map<String, dynamic>) onSave; // Kaydetme işlemi

  const EditRoutePage({super.key, required this.routeData, required this.onSave});

  @override
  _EditRoutePageState createState() => _EditRoutePageState();
}

class _EditRoutePageState extends State<EditRoutePage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.routeData['title']);
    descriptionController = TextEditingController(text: widget.routeData['description']);
    locationController = TextEditingController(text: widget.routeData['location']);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotayı Düzenle'),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Başlık",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Başlık girin",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Açıklama",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Açıklama girin",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Konum",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Konum girin",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              ),
              onPressed: () {
                final updatedRoute = {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'location': locationController.text,
                };
                widget.onSave(updatedRoute); // Güncellenmiş veriyi geri döndür
                Navigator.pop(context); // Sayfayı kapat
              },
              child: const Text(
                "Kaydet",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
