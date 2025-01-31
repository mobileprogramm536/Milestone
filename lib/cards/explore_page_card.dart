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
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    
    // First get the route card data
    RouteService().getRouteCard(widget.routeId).then((element) {
      if (mounted) {
        setState(() {
          routeC = element;
          likes = routeC!.likecount!;
          imageUrl = routeC!.pfpurl!;
          
          // Check if the route is liked using isRouteLiked
          RouteService().isRouteLiked(widget.routeId).then((liked) {
            if (mounted) {
              setState(() {
                isLiked = liked;
              });
            }
          });
        });
      }
    });
  }

  void toggleLike() {
    // Before making the API call, we toggle the like state.
    setState(() {
      isLiked = !isLiked; // Toggle heart state
      likes = isLiked ? likes + 1 : likes - 1;
    });

    // Make the API call to update the like status on the backend
    RouteService().likeRoute(widget.routeId, isLiked).then((_) {
      // After updating the backend, fetch the updated route data (including like count)
      RouteService().getRouteCard(widget.routeId).then((updatedRouteCard) {
        // Ensure the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            routeC = updatedRouteCard;
            likes = routeC!
                .likecount!; // Update the UI with the correct like count from the backend
            imageUrl = routeC!.pfpurl!;
          });
        }
      }).catchError((e) {
        print("Error getting updated route card: $e");
      });
    }).catchError((e) {
      print("Error liking route: $e");
    });
  }

  Widget _buildUserAvatar() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.yellow1,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('$imageUrl'),
          radius: 30.0,
        ),
      ),
    );
  }

  Widget _buildRouteStats(double width) {
    return Row(
      children: [
        const Icon(Icons.pin_drop_outlined,
            color: AppColors.yellow1, size: 16.0),
        SizedBox(width: width * 0.08),
        _buildRotatedNavigationIcon(),
        const SizedBox(width: 4.0),
        Text(
          routeC?.destinationcount?.toString() ?? '0',
          style: const TextStyle(color: AppColors.white1, fontSize: 12.0),
        ),
      ],
    );
  }

  Widget _buildRotatedNavigationIcon() {
    return Transform.rotate(
      angle: 90 * 3.14159 / 180, // Rotate 90 degrees
      child: const Icon(
        Icons.navigation,
        color: AppColors.yellow1,
        size: 16.0,
      ),
    );
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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: AppColors.grey1, // Background color as in the design
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          child: Padding(
              padding: EdgeInsets.all(height * 0.018),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circular image on the left
                      _buildUserAvatar(),
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
                            Container(
                              height: height * 0.033,
                              child: Text(
                                routeC!.description!,
                                style: TextStyle(
                                    color: AppColors.white1,
                                    fontSize: height * 0.013,
                                    fontWeight: FontWeight.w100),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.01,
                        ),
                        _buildRouteStats(width),
                        SizedBox(width: width * 0.35),
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
