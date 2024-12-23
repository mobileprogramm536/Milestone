import 'package:flutter/material.dart';
import 'package:milestone/pages/exploreMore_page.dart';
import 'package:milestone/pages/singIn_page.dart';

import '../buttons/signIn_button.dart';
import '../cards/explore_page_card.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
                Container(
                  width: width * 0.975,
                  height: height * 0.7,
                  child: ListView(children: [
                    ExploreCard(
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
                    ExploreCard(
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
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
