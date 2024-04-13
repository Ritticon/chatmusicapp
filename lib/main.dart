
import 'dart:io';

// import 'package:chatmusic/firebase_options.dart';
// import 'package:chatmusic/models/playlist_provider.dart';
// import 'package:chatmusic/page/chatOnline.dart';
// import 'package:chatmusic/page/favoriteSong.dart';
// import 'package:chatmusic/page/home_page.dart';
// import 'package:chatmusic/page/login.dart';
// import 'package:chatmusic/page/popupSongPage.dart';
// import 'package:chatmusic/page/profile.dart';
// import 'package:chatmusic/page/register.dart';
// import 'package:chatmusic/page/searchMusic.dart';
// import 'package:chatmusic/page/setting.dart';

// import 'package:chatmusic/page/streaming.dart';

// import 'package:chatmusic/themes/theme_provider.dart';
import 'package:chatmusicapp/firebase_options.dart';
import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:chatmusicapp/page/chatOnline.dart';
import 'package:chatmusicapp/page/favoriteSong.dart';
import 'package:chatmusicapp/page/home_page.dart';
import 'package:chatmusicapp/page/login.dart';
import 'package:chatmusicapp/page/popupSongPage.dart';
import 'package:chatmusicapp/page/profile.dart';
import 'package:chatmusicapp/page/register.dart';
import 'package:chatmusicapp/page/searchMusic.dart';
import 'package:chatmusicapp/page/setting.dart';
import 'package:chatmusicapp/page/streaming.dart';
import 'package:chatmusicapp/theme/theme_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> ThemeProvider()),
      ChangeNotifierProvider(create: (context)=> PlaylistProvider()),
    ],
    child: const MyApp(),)
  );
  
}
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
  // routes: <RouteBase>[
  //   GoRoute(
  //     path: '/',
  //     builder: (BuildContext context, GoRouterState state) {
  //       return Home();
  //     },
  //     routes: <RouteBase>[
  //       GoRoute(
  //         path: 'streaming',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const StreamingPage();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'chat',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const ChatOnlinePage();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'search',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const searchMusic();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'favsong',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const FavoriteSong();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'profile',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const MyProfile();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'popupsong',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const PopupSong();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'login',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const Login();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'register',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const Register();
  //         },
  //         routes: <RouteBase>[
  //       GoRoute(
  //         path: 'setting',
  //         builder: (BuildContext context, GoRouterState state) {
  //           return const settingPage();
  //         },
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //       ),
  //     ],
  //   ),
  // ],
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,

      // routes: {
      //   '/streaming':(context) => const StreamingPage(),
      //   '/chat':(context) => const ChatOnlinePage(),
      //   'search':(context) => const searchMusic(),
      //   'favsong':(context) => const FavoriteSong(),
      //   '/profile':(context) => const MyProfile(),
      //   'popupsong':(context) => const PopupSong(),
      //   '/login':(context) => const Login(),
      //   '/register':(context) => const Register(),
      //   '/setting':(context) => const settingPage(),
      // },
      theme: Provider.of<ThemeProvider>(context).themeData,
      
    );
  }
}

    // late final GoRouter _router = GoRouter(
    // routes: <GoRoute>[
    //   GoRoute(
    //     path: '/',
    //     builder: (BuildContext context, GoRouterState state) => const StreamingPage(),
    //   ),
    //   GoRoute(
    //     path: '/login',
    //     builder: (BuildContext context, GoRouterState state) => const Login(),
    //   ),
    // ],
    //     // redirect to the login page if the user is not logged in
    // redirect: (BuildContext context, GoRouterState state) {
    //   // final bool loggedIn = _loginInfo.loggedIn;
    //   final bool loggingIn = state.matchedLocation == '/login';
    //   if (!loggingIn) {
    //     return '/login';
    //   }
    //   if (loggingIn) {
    //     return '/';
    //   }
    //   return null;
    // },
    // // changes on the listenable will cause the router to refresh its route
    // refreshListenable: _loginInfo,
    // ),