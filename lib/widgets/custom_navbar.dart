import 'package:flutter/material.dart';
import 'package:milestone/theme/colors.dart';

class CustomNavBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const CustomNavBar({
    Key? key,
    required this.onItemSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
              bottomRight: Radius.circular(100),
              bottomLeft: Radius.circular(100),
            ),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavBarIcon(
                  context: context,
                  icon: Icons.location_on_outlined,
                  index: 0,
                  route: '/createRoute',
                ),
                _buildNavBarIcon(
                  context: context,
                  icon: Icons.explore_outlined,
                  index: 1,
                  route: '/explorePage',
                ),
                const SizedBox(width: 60),
                _buildNavBarIcon(
                  context: context,
                  icon: Icons.star_border_rounded,
                  index: 2,
                  route: '/savedRoutesPage',
                ),
                _buildNavBarIcon(
                  context: context,
                  icon: Icons.person_outlined,
                  index: 3,
                  route: '/profilePage',
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          child: GestureDetector(
            onTap: () {
              onItemSelected(4);
              Navigator.pushNamed(context, '/mainPage');
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[900],
              radius: 40,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.green1,
                child: const Icon(
                  Icons.airplanemode_active,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBarIcon({
    required BuildContext context,
    required IconData icon,
    required int index,
    required String route,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        onItemSelected(index);
        Navigator.pushNamed(context, route);
      },
      child: Icon(
        icon,
        color: isSelected ? AppColors.green1 : Colors.white,
        size: 28,
      ),
    );
  }
}
