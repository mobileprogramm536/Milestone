import 'package:flutter/material.dart';
import 'package:milestone/pages/route_detail_page.dart';
import 'package:milestone/services/route_service.dart';

import '../theme/colors.dart';

class ExploreCard extends StatefulWidget {
  final String routeId;
  final String imageUrl;
  final int likes;

  const ExploreCard({
    Key? key,
    required this.routeId,
    required this.imageUrl,
    required this.likes,
  }) : super(key: key);

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  RouteCard? routeC = null;
  int likes = 0; // To track the number of likes
  late bool isLiked; // To toggle like state

  @override
  void initState() {
    super.initState(); // Initialize likes
    isLiked = false; // Default state: unliked
    RouteService().getRouteCard(widget.routeId).then((element) => {
          setState(() {
            routeC = element;
            likes = routeC!.likecount!;
          })
        });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked; // Toggle state
      likes += isLiked ? 1 : -1; // Increment or decrement the count
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (routeC == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.all(10),
          color: AppColors.grey1,
          height: height * 0.1,
          width: height * 0.1,
        ),
      );
    }

    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteDetailPage(routeId: widget.routeId),
          ),
        )
      },
      child: Container(
        width: width * 0.5,
        height: height * 0.21,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: AppColors.grey1, // Background color as in the design
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          child: Padding(
              padding: EdgeInsets.all(height * 0.018),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circular image on the left
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow, // Sarı arka plan rengi
                            shape: BoxShape.circle, // Yuvarlak şekil
                          ),
                          padding: EdgeInsets.all(
                              3.0), // Arka planın boyutunu büyütüyoruz
                          child: GestureDetector(
                            onTap: () => {},
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/femaleavatar9.png'),
                              radius: 30.0, // Avatarın boyutu
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.005,
                            ),
                            Text(
                              routeC!.title!,
                              style: TextStyle(
                                color: AppColors.white1,
                                fontSize: height * 0.023,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.001),
                            // Description
                            Text(
                              routeC!.description!,
                              style: TextStyle(
                                  color: AppColors.white1,
                                  fontSize: height * 0.013,
                                  fontWeight: FontWeight.w100),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.01,
                        ),
                        const Icon(
                          Icons.pin_drop_outlined,
                          color: AppColors.yellow1,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        SizedBox(width: width * 0.08),
                        Transform.rotate(
                          angle: 90 * 3.1415927 / 180, // 90 derece döndürme
                          child: const Icon(
                            Icons.navigation_outlined,
                            color: AppColors.yellow1,
                            size: 16.0,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          routeC!.destinationcount!.toString(),
                          style: const TextStyle(
                            color: AppColors.white1,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        Row(children: [
                          Text(
                            likes.toString(),
                            style: const TextStyle(
                              color: AppColors.white1,
                              fontSize: 12.0,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleLike, // Action to toggle like
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color:
                                  isLiked ? AppColors.red1 : AppColors.white1,
                              size: 24.0,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
