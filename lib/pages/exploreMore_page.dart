import 'package:flutter/material.dart';
import 'package:milestone/cards/exploreMore_page_card.dart';
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

  @override
  Widget build(BuildContext context) {
    SearchController search = SearchController();
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
              Container(
                width: width * 0.975,
                height: height * 0.7,
                child: Center(
                  child: ListView(children: [
                    Row(
                      children: [
                        ExploremorePageCard(
                          title: 'Date Mekanları',
                          description:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi viverra nulla non magna ullamcorper, non.',
                          location: 'Rome, Italy',
                          imageUrl:
                              'https://via.placeholder.com/60', // Replace with actual image URL
                          destinations: 5,
                          duration: '3 hours',
                          likes: 476,
                        ),
                        ExploremorePageCard(
                          title: 'Date Mekanları',
                          description:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi viverra nulla non magna ullamcorper, non.',
                          location: 'Rome, Italy',
                          imageUrl:
                              'https://via.placeholder.com/60', // Replace with actual image URL
                          destinations: 5,
                          duration: '3 hours',
                          likes: 476,
                        ),
                      ],
                    )
                  ]),
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
            // Replace with AppColors if needed
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
