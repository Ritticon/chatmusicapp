
import 'package:chatmusicapp/page/chatOnline.dart';
import 'package:chatmusicapp/page/favoriteSong.dart';
import 'package:chatmusicapp/page/login.dart';
import 'package:chatmusicapp/page/profile.dart';
import 'package:chatmusicapp/page/register.dart';
import 'package:chatmusicapp/page/searchMusic.dart';
import 'package:chatmusicapp/page/streaming.dart';
import 'package:flutter/material.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageControlller = PageController();

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Scaffold(
        body: PageView(
          controller: _pageControlller,
          children: const <Widget>[
            StreamingPage(),
            // ChatOnlinePage(),
            MyProfile(),
            searchMusic(),
            Login(),
            // Register(),
            FavoriteSong()
        
            // ProfilePage(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: RollingBottomBar(
          // backgroundColor: Theme.of(context).colorScheme.background,
          color: Theme.of(context).colorScheme.secondary,
          controller: _pageControlller,
          flat: true,
          useActiveColorByDefault: false,
          items: const [
            RollingBottomBarItem(Icons.home,
                label: '', activeColor: Colors.redAccent),
            RollingBottomBarItem(Icons.camera,
                label: '', activeColor: Colors.blueAccent),
            RollingBottomBarItem(Icons.person,
                label: '', activeColor: Colors.green),
            RollingBottomBarItem(Icons.home,
                label: '', activeColor: Colors.redAccent),
            RollingBottomBarItem(Icons.home,
                label: '', activeColor: Colors.redAccent)
          ],
          // enableIconRotation: true,
          onTap: (index) {
            _pageControlller.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          },
        ),
      ),
    );
  }
}
