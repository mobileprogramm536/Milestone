import 'package:flutter/material.dart';

import '../theme/colors.dart';
class ExploremorePageCard extends StatefulWidget {
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final int destinations;
  final String duration;
  final int likes;

  const ExploremorePageCard({
    Key? key,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.destinations,
    required this.duration,
    required this.likes,
  }) : super(key: key);

  @override
  State<ExploremorePageCard> createState() => _ExploremorePageCardState();
}

class _ExploremorePageCardState extends State<ExploremorePageCard> {
  late int likes; // To track the number of likes
  late bool isLiked; // To toggle like state
  @override
  void initState() {
    super.initState();
    likes = widget.likes; // Initialize likes
    isLiked = false; // Default state: unliked
  }
  void toggleLike() {
    setState(() {
      isLiked = !isLiked; // Toggle state
      likes += isLiked ? 1 : -1; // Increment or decrement the count
    });
  }
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height*0.21,
      width: width*0.47,
      child: Stack(
        children: [
          Positioned(
            top: height*0.03,
            child: Container(
              height: height*0.18,
              width: width*0.46,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: AppColors.darkgrey2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: height*0.003
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppColors.white1,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        color: AppColors.white1,
                        fontSize: 6.0,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: height*0.01,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.yellow1,
                          size: 16.0,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          widget.location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          color: AppColors.yellow1,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${widget.destinations} destination',
                          style: const TextStyle(
                            color: AppColors.white1,
                            fontSize: 12.0,
                          ),
                        ),],
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
                width: width*0.47,
                height: height*0.06,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: AppColors.darkgrey2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width:width*0.12,
                        ),
                        Text("gexginpalyaco",
                          style: const TextStyle(
                            color: AppColors.white1,
                            fontSize: 5.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                            Text(
                            likes.toString(),
                            style: const TextStyle(
                              color: AppColors.white1,
                              fontSize: 8.0,
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
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  radius: 20.0,
                ),
              )
            ],
          ),
        ]
      ),
    );
  }
}
