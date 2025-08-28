import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/screens/experts_screen.dart';
import 'package:mindtech/screens/home_screen.dart' show HomeScreen;
import 'package:mindtech/screens/myaccount_screen.dart';
import 'package:mindtech/screens/timeline_screen.dart';

class BottomNav extends StatefulWidget {
  final int? index;

  const BottomNav({super.key, this.index});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool isOffline = false;
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
    print("init");
    _selectedIndex = widget.index ?? 0;
  }

  List<Widget> pages = [
    HomeScreen(),
    TimelineScreen(),
    ExpertsScreen(),
    MyaccountScreen(),
  ];

  //Bottom Navigation
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: SizedBox(
          height: 83,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColor.primary,
            currentIndex: _selectedIndex,
            enableFeedback: false,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: IconThemeData(
              color: AppColor.white,
            ),
            unselectedIconTheme: IconThemeData(
              color: AppColor.white,
            ),
            selectedFontSize: 0,
            iconSize: 0,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: bottomNavIcon(AppImage.ic_home,AppImage.ic_home_fill, 'Home', isActive: _selectedIndex == 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: bottomNavIcon(AppImage.ic_timeline,AppImage.ic_timeline_fill, 'Timeline', isActive: _selectedIndex == 1),
                label: 'Timeline',
              ),
              BottomNavigationBarItem(
                icon: bottomNavIcon(AppImage.ic_experts,AppImage.ic_experts_fill, 'Experts', isActive: _selectedIndex == 2),
                label: 'Experts',
              ),
              BottomNavigationBarItem(
                icon: bottomNavIcon(AppImage.ic_user,AppImage.ic_user_fill, 'My Account', isActive: _selectedIndex == 3),
                label: 'My Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomNavIcon(String iconName,String activeIconName, String label, {required bool isActive}) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: ImageIcon(
            AssetImage(isActive?activeIconName:iconName),
            color: isActive?AppColor.secondery:AppColor.grayBackground,
            size: isActive?_selectedIndex == 1?AppSize.s30:AppSize.s25:AppSize.s25,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color:  isActive?AppColor.secondery:AppColor.grayBackground,
            fontSize: isActive?13:12,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        )
      ],
    );
  }


}
