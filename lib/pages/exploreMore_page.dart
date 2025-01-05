import 'package:flutter/material.dart';
import 'package:milestone/cards/exploreMore_page_card.dart';
import '../services/route_service.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import '../widgets/custom_navbar.dart';

class ExploreMorePage extends StatefulWidget {
  const ExploreMorePage({super.key});

  @override
  State<ExploreMorePage> createState() => _ExploreMorePageState();
}

class _ExploreMorePageState extends State<ExploreMorePage> {
  late final Future<List<String>> routes;

  static const int _defaultIndex = 1;
  int _selectedIndex = _defaultIndex;

  @override
  void initState() {
    super.initState();
    routes = RouteService().getExploreRoutes();
  }

  void _onNavBarItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkgrey1,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(gradient: appBackground),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            Flexible(
              child: FutureBuilder<List<String>>(
                future: routes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No routes available.'));
                  }

                  return _buildRoutesGrid(snapshot.data!, size);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(size.height),
    );
  }

  Widget _buildRoutesGrid(List<String> routeList, Size size) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(size.width * 0.02),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: size.height * 0.4,
              mainAxisSpacing: size.height * 0.02,
              crossAxisSpacing: size.width * 0.02,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ExploremorePageCard(
                routeId: routeList[index],
                imageUrl: '../assets/images/femaleavatar9.png',
                likes: 476,
              ),
              childCount: routeList.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBar(double height) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10.0),
      child: Container(
        height: height * 0.08,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
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
    );
  }
}
