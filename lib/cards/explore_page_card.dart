import 'package:flutter/material.dart';

import '../theme/colors.dart';

class ExploreCard extends StatefulWidget {
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final int destinations;
  final String duration;
  final int likes;

  const ExploreCard({
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
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ()=>{},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: AppColors.darkgrey2, // Background color as in the design
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular image on the left
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onTap: ()=>{},
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.imageUrl),
                        radius: 30.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height*0.005,
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: AppColors.white1,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: height * 0.001),
                        // Description
                        Text(
                          widget.description,
                          style: const TextStyle(
                            color: AppColors.white1,
                            fontSize: 8.0,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.pin_drop_outlined,
                      color: AppColors.yellow1,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(width: width*0.03),
                    const Icon(
                      Icons.navigation_outlined ,
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
                    ),
                    SizedBox(width: width*0.04),
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
                          onPressed: toggleLike, // Action to toggle like
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? AppColors.red1 : AppColors.white1,
                            size: 24.0,
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}