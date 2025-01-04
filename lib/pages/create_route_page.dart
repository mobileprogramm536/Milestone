import 'package:flutter/material.dart';
import 'package:milestone/textfields/route_text_field.dart';
import 'package:milestone/theme/colors.dart';
import '../place_item.dart';
import '../services/route_service.dart';
import '../theme/app_theme.dart';

class CreateRoutePage extends StatefulWidget {
  const CreateRoutePage({super.key});

  @override
  _CreateRoutePageState createState() => _CreateRoutePageState();
}

class _CreateRoutePageState extends State<CreateRoutePage> {
  final List<TextEditingController> _controllers = [];
  final List<TextEditingController> _noteControllers = [];
  final _routecontroller_name = TextEditingController();
  final _routecontroller_desc = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addPlace();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addPlace() {
    setState(() {
      _controllers.add(TextEditingController());
      _noteControllers.add(TextEditingController());

      // Yeni öğe eklendiğinde listeyi hafifçe kaydır
      Future.delayed(const Duration(milliseconds: 100), () {
        double targetPosition =
            _scrollController.position.maxScrollExtent + 2; // Biraz aşağı kayar
        _scrollController.animateTo(
          targetPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void createRoute() {
    final routeName = _routecontroller_name.text;
    final description = _routecontroller_desc.text;
    // Konumları dinamik olarak alalım
    List<Map<String, dynamic>> locations = [];
    for (int i = 0; i < _controllers.length - 1; i++) {
      locations.add({
        'name': _controllers[i].text,
        'note': _noteControllers[i].text, // Notu al
      });
    }

    // RouteService kullanarak veriyi kaydedelim
    RouteService().createRoute(
      routeName: routeName,
      routeDescription: description,
      locations: locations,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: appBackground,
          ),
          child: Stack(children: [
            Positioned(
                top: height * 0.08,
                left: width / 2 - 100,
                child: Container(
                  decoration: const BoxDecoration(color: AppColors.white1),
                  height: 200,
                  width: 200,
                )),
            Container(
              margin: EdgeInsets.only(top: height * 0.37, left: 20, right: 20),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.grey1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  RouteTextField(
                      controller: _routecontroller_name,
                      text: "Rotanızın adı..."),
                  const SizedBox(height: 8),
                  RouteTextField(
                      controller: _routecontroller_desc,
                      text: "Rotanızı tanıtın..."),
                  const SizedBox(height: 5),
                  // Dinamik Liste
                  Flexible(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _controllers.length,
                      itemBuilder: (context, index) {
                        // Tüm önceki öğelerin doluluğunu kontrol et
                        bool canShow = true;

                        for (int i = 0; i <= index; i++) {
                          if (_controllers[i].text.isEmpty) {
                            canShow = false;
                            break;
                          }
                        }

                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: canShow
                              ? 1.0
                              : 0.5, // Tüm önceki öğelere göre opacity kontrolü
                          child: PlaceItem(
                            isLastItem: index == _controllers.length - 1,
                            totalItems: _controllers.length,
                            onDelete: () {
                              setState(() {
                                _controllers.removeAt(index);
                              });
                            },
                            index: index + 1,
                            controller: _controllers[index],
                            noteController: _noteControllers[index],
                            onChanged: (value, note) {
                              setState(() {
                                // Eğer yazı eklenirse bir sonraki öğeyi ekle
                                if (value.isNotEmpty &&
                                    index == _controllers.length - 1) {
                                  _addPlace();
                                }
                                if (value.isEmpty &&
                                    index < _controllers.length - 1) {
                                  // Silinen öğeden sonra gelenleri bir önceki öğeye aktar
                                  for (int i = index;
                                      i < _controllers.length - 1;
                                      i++) {
                                    _controllers[i].text =
                                        _controllers[i + 1].text;
                                  }
                                  // Son öğeyi kaldır
                                  _controllers.removeLast();
                                }
                              });
                            },
                            isVisible: true,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Oluştur Butonu
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          createRoute();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green1,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("oluştur",
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.white1,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
