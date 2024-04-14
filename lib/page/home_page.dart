
import 'package:chatmusicapp/page/chatOnline.dart';
import 'package:chatmusicapp/page/favoriteSong.dart';
import 'package:chatmusicapp/page/login.dart';
import 'package:chatmusicapp/page/popupSongPage.dart';
import 'package:chatmusicapp/page/profile.dart';
import 'package:chatmusicapp/page/register.dart';
import 'package:chatmusicapp/page/searchMusic.dart';
import 'package:chatmusicapp/page/setting.dart';
import 'package:chatmusicapp/page/streaming.dart';
import 'package:flutter/material.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
      routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>  Home(),
      ),
      GoRoute(
        path: '/streaming',
        builder: (BuildContext context, GoRouterState state) => const StreamingPage(),
      ),
      GoRoute(
        path: '/chat',
        builder: (BuildContext context, GoRouterState state) => const ChatOnlinePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) => const searchMusic(),
      ),
      GoRoute(
        path: '/favsong',
        builder: (BuildContext context, GoRouterState state) => const FavoriteSong(),
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) => const MyProfile(),
      ),
      GoRoute(
        path: '/popupsong',
        builder: (BuildContext context, GoRouterState state) => const PopupSong(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const Login(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) => const Register(),
      ),
      GoRoute(
        path: '/setting',
        builder: (BuildContext context, GoRouterState state) => const settingPage(),
      ),
    ],

);
class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pageControlller = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Scaffold(
        body: PageView(
          controller: _pageControlller,
          children: const <Widget>[
            StreamingPage(),
            ChatOnlinePage(),
            MyProfile(),
            searchMusic(),
            // Login(),
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
            setState(() => _selectedIndex = index);
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
