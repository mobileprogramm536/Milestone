import 'package:flutter/material.dart';
import 'package:milestone/cards/exploreMore_page_card.dart';
import 'package:milestone/pages/singIn_page.dart';

import '../buttons/signIn_button.dart';
import '../cards/explore_page_card.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';

class ExploreMorePage extends StatefulWidget {
  const ExploreMorePage({super.key});

  @override
  State<ExploreMorePage> createState() => _ExploreMorePageState();
}

class _ExploreMorePageState extends State<ExploreMorePage> {

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
                Flexible(
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(width*0.02),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: height*0.4,
                              mainAxisSpacing: height*0.0001,
                              crossAxisSpacing: width*0.002,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return ExploremorePageCard(
                                  title: 'Date Mekanları',
                                  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi viverra nulla non magna ullamcorper, non.',
                                  location: 'Rome, Italy',
                                  imageUrl: 'https://via.placeholder.com/60', // Replace with actual image URL
                                  destinations: 5,
                                  duration: '3 hours',
                                  likes: 476,
                                );
                              },
                              childCount: 20,
                            ),
                          )
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        )
    );
  }
}
