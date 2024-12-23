import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milestone/theme/colors.dart';

class PlaceItem extends StatefulWidget {
  final int index;
  final TextEditingController controller;
  final TextEditingController noteController; // Not controller
  final bool isVisible;
  final Function(String, String)
      onChanged; // Yer adı ve notu birlikte göndermek için
  final VoidCallback onDelete;
  final bool isLastItem;
  final int totalItems;
  final Function(LatLng?) onSaveLocation;

  const PlaceItem({
    super.key,
    required this.index,
    required this.controller,
    required this.noteController, // Not controller
    required this.isVisible,
    required this.onChanged,
    required this.onDelete,
    required this.isLastItem,
    required this.totalItems,
    required this.onSaveLocation,
  });

  @override
  State<PlaceItem> createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {
  bool _showBorder = true; // Kenarlık durumunu takip eder

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Tüm TextField'lardan odağı kaldırır
      },
      child: widget.isVisible
          ? Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.yellow1, AppColors.yellow2],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.grey1,
                  child: Text(
                    "${widget.index}",
                    style: const TextStyle(
                        color: AppColors.white1, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Column(
                  children: [
                    TextField(
                      cursorColor: AppColors.white1,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkgrey1,
                        fontWeight: FontWeight.normal,
                      ),
                      controller: widget.controller,
                      onChanged: (value) {
                        setState(() {
                          _showBorder = true; // Yazılırken kenarlık göster
                        });
                        widget.onChanged(value, widget.noteController.text);
                      },
                      onEditingComplete: () {
                        setState(() {
                          // Yazı tamamlandıysa ve boş değilse kenarlık kalkar
                          if (widget.controller.text.isNotEmpty) {
                            _showBorder = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Yerin adı...",
                        border: _showBorder
                            ? const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white1, width: 1),
                              )
                            : InputBorder.none, // Kenarlık kaldırma
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white1, width: 1.5),
                        ),
                        hintStyle: const TextStyle(
                            color: AppColors.grey1,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                subtitle: Column(
                  children: [
                    TextField(
                      cursorColor: AppColors.white1,
                      style: const TextStyle(
                        color: AppColors.darkgrey1,
                        fontSize: 12,
                      ),
                      controller: widget.noteController,
                      onChanged: (value) {
                        widget.onChanged(widget.controller.text, value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Not ekle...",
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white1, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white1, width: 1.5),
                        ),
                        hintStyle: TextStyle(color: AppColors.grey1),
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  children: [
                    SizedBox(
                      width: 20, // Genişliği ayarlayabilirsiniz
                      height: 20, // Yüksekliği ayarlayabilirsiniz
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_location,
                          color: AppColors.green1,
                          size: 25, // Simge boyutu küçültüldü
                        ),
                        onPressed: () {
                          widget.onSaveLocation(null);
                        },
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(), // Boyut sınırlarını sıfırlar
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 20, // Genişliği ayarlayabilirsiniz
                      height: 15, // Yüksekliği ayarlayabilirsiniz
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.red1,
                          size: 25, // Simge boyutu küçültüldü
                        ),
                        onPressed: widget.isLastItem && widget.totalItems == 1
                            ? null // Eğer sadece bir öğe varsa silme butonu devre dışı bırakılır
                            : widget.onDelete,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(), // Boyut sınırlarını sıfırlar
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
