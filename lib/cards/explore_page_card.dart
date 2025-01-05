import 'package:flutter/material.dart';
import 'package:milestone/pages/route_detail_page.dart';
import 'package:milestone/services/route_service.dart';
import '../theme/colors.dart';

class ExploreCard extends StatefulWidget {
  final String routeId;

  const ExploreCard({
    Key? key,
    required this.routeId,
  }) : super(key: key);

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  RouteCard? routeC;
  int likes = 0;
  bool isLiked = false;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    // Get initial route data
    RouteService().getRouteCard(widget.routeId).then((element) {
      setState(() {
        routeC = element;
        likes = routeC!.likecount!;
        isLiked = routeC!.liked!;
        imageUrl = routeC!.pfpurl!;
      });
    }).catchError((e) {
      print("Error fetching route card: $e");
    });
  }

  void toggleLike() {
    // Call backend to update like status
    RouteService().likeRoute(widget.routeId, isLiked).then((_) {
      // Fetch updated route data after liking
      RouteService().getRouteCard(widget.routeId).then((updatedRouteCard) {
        if (mounted) {
          setState(() {
            routeC = updatedRouteCard;
            likes = routeC!.likecount!;
          });
        }
      }).catchError((e) {
        print("Error fetching updated route card: $e");
      });
    }).catchError((e) {
      print("Error liking route: $e");
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Any necessary cleanup, cancel timers, etc.
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
          color: AppColors.grey1,
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
                          color: Colors.yellow, // Yellow background
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: () => {},
                          child: CircleAvatar(
                            backgroundImage: AssetImage(imageUrl),
                            radius: 30.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.005),
                          Text(
                            routeC!.title!,
                            style: TextStyle(
                              color: AppColors.white1,
                              fontSize: height * 0.023,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.001),
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
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.01),
                      const Icon(
                        Icons.pin_drop_outlined,
                        color: AppColors.yellow1,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      SizedBox(width: width * 0.08),
                      Transform.rotate(
                        angle: 90 * 3.1415927 / 180,
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
                      SizedBox(width: width * 0.35),
                      Row(
                        children: [
                          Text(
                            likes.toString(),
                            style: const TextStyle(
                              color: AppColors.white1,
                              fontSize: 12.0,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleLike,
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color:
                                  isLiked ? AppColors.red1 : AppColors.white1,
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
