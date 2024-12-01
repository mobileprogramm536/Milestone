import 'package:flutter/material.dart';
import 'package:milestone/widgets/custom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onNavBarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation or actions here
    print('Selected Index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: SafeArea(
        child: Center(
          child: Text(
            'Selected Tab: $_selectedIndex',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        onItemSelected: _onNavBarItemSelected,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
