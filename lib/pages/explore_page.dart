import 'package:flutter/material.dart';
import 'package:milestone/pages/exploreMore_page.dart';

import 'package:milestone/pages/singIn_page.dart';

import '../buttons/signIn_button.dart';
import '../cards/explore_page_card.dart';
import '../services/auth_service.dart';

import '../services/route_service.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import '../widgets/custom_navbar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedIndex = 1;

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected Index: $index');
  }

  late Future<List<String>> routes; // Change routes to Future

  @override
  void initState() {
    super.initState();
    // Initialize the routes Future
    routes = RouteService().getExploreRoutes(); // Directly assign the future
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
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: height * 0.06,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ExploreMorePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green1,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical: height * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Explore More',
                              style: TextStyle(
                                  fontSize: height * 0.012,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white1),
                            ),
                            Icon(Icons.explore,
                                size: height * 0.02, color: AppColors.white1)
                          ],
                        )),
                  ),
                  SizedBox(width: width * 0.05),
                ],
              ),
              Flexible(
                child: FutureBuilder<List<String>>(
                  future: routes, // Pass the Future directly
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No routes available.'));
                    }

                    final routeList = snapshot.data!;
                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(width * 0.01),
                          sliver: SliverList.separated(
                            itemBuilder: (context, index) {
                              final route = routeList[index];
                              return ExploreCard(
                                routeId: route,
                                imageUrl: '../assets/images/femaleavatar9.png',
                                likes: 476, // Add dynamic likes if available
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: height * 0.005),
                            itemCount: routeList.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
