import 'package:flutter/material.dart';
import '../services/route_service.dart';
import '../theme/colors.dart';

class ExploremorePageCard extends StatefulWidget {
  final String routeId;
  final String imageUrl;
  final int likes;

  const ExploremorePageCard({
    Key? key,
    required this.routeId,
    required this.imageUrl,
    required this.likes,
  }) : super(key: key);

  @override
  State<ExploremorePageCard> createState() => _ExploremorePageCardState();
}

class _ExploremorePageCardState extends State<ExploremorePageCard> {
  RouteCard? routeC = null;
  int likes = 0; // To track the number of likes
  late bool isLiked; // To toggle like state
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    isLiked = false; // Default state: unliked
    RouteService().getRouteCard(widget.routeId).then((element) {
      setState(() {
        routeC = element;
        likes = routeC?.likecount ?? 0; // If null, default to 0
        imageUrl = routeC?.pfpurl ?? "../assets/images/femaleavatar9.png";
      });
    });
  }

  void fetchRouteCard() {
    RouteService().getRouteCard(widget.routeId).then((element) {
      if (mounted) {
        setState(() {
          routeC = element;
          likes = routeC!.likecount!;
          isLiked = routeC!.liked!;
        });
      }
    }).catchError((e) {
      print("Error fetching route card: $e");
    });
  }

  void toggleLike() {
    // Update UI optimistically
    setState(() {
      isLiked = !isLiked; // Toggle heart state
      likes = isLiked ? likes + 1 : likes - 1;
    });

    // Make the API call to update the like status on the backend
    RouteService().likeRoute(widget.routeId, isLiked).then((_) {
      if (mounted) {
        fetchRouteCard(); // Fetch the updated data after API call
      }
    }).catchError((e) {
      print("Error liking route: $e");

      // Revert the UI changes in case of an error
      if (mounted) {
        setState(() {
          isLiked = !isLiked;
          likes = isLiked ? likes + 1 : likes - 1;
        });
      }
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
          margin: const EdgeInsets.all(10),
          color: AppColors.grey1,
          height: height * 0.1,
          width: height * 0.1,
        ),
      );
    }

    return SizedBox(
      height: height * 0.21,
      width: width * 0.47,
      child: Stack(
        children: [
          Positioned(
            top: height * 0.032,
            child: Container(
              height: height * 0.18,
              width: width * 0.46,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: AppColors.grey1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.003),
                      Text(
                        routeC?.title ?? 'Title not available',
                        style: TextStyle(
                          color: AppColors.white1,
                          fontSize: height * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        routeC?.description ?? 'Description not available',
                        style: TextStyle(
                          color: AppColors.white1,
                          fontSize: height * 0.01,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        children: [
                          const Icon(
                            Icons.pin_drop_outlined,
                            color: AppColors.yellow1,
                            size: 16.0,
                          ),
                          const SizedBox(width: 2.0),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.navigation_outlined,
                            color: AppColors.yellow1,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            routeC?.destinationcount?.toString() ?? '0',
                            style: const TextStyle(
                              color: AppColors.white1,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                width: width * 0.47,
                height: height * 0.06,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: AppColors.grey1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(width: width * 0.12),
                        Expanded(
                          child: Text(
                            routeC?.username ?? 'Username not available',
                            style: TextStyle(
                              color: AppColors.white1,
                              fontSize: height * 0.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text(
                          likes.toString(),
                          style: const TextStyle(
                            color: AppColors.white1,
                            fontSize: 10.0,
                          ),
                        ),
                        IconButton(
                          onPressed: toggleLike, // Action to toggle like
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? AppColors.red1 : AppColors.white1,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(3.0),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/femaleavatar9.png'),
                    radius: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
