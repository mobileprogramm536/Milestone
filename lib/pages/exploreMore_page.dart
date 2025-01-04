import 'package:flutter/material.dart';
import 'package:milestone/cards/exploreMore_page_card.dart';
import '../services/auth_service.dart';
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
                height: height * 0.05,
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
                          padding: EdgeInsets.all(width * 0.02),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: height * 0.4,
                              mainAxisSpacing: height * 0.02,
                              crossAxisSpacing: width * 0.02,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final route = routeList[index];
                                return ExploremorePageCard(
                                  routeId: route,
                                  imageUrl:
                                      '../assets/images/femaleavatar9.png', // Replace with actual image URL
                                  likes:
                                      476, // Replace with dynamic likes if available
                                );
                              },
                              childCount: routeList.length,
                            ),
                          ),
                        )
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
          height: height * 0.08, // Reduced height for a sleeker design
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                offset: Offset(0, 6), // Subtle shadow effect
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
