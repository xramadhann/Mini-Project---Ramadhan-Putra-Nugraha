import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      width: 360,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.orange,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: const Duration(milliseconds: 800),
                tabBackgroundColor: Colors.orangeAccent,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                  ),
                  GButton(
                    icon: Icons.event,
                  ),
                  GButton(
                    icon: Icons.qr_code,
                  ),
                  GButton(
                    icon: Icons.history,
                  ),
                  GButton(
                    icon: Icons.person,
                  ),
                ],
                selectedIndex: widget.currentIndex,
                onTabChange: (index) {
                  widget.onTabTapped(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
