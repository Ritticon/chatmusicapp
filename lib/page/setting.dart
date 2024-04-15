// import 'package:chatmusic/pages/home_page.dart';
// import 'package:chatmusic/pages/profile.dart';
// import 'package:chatmusic/themes/theme_provider.dart';
import 'package:chatmusicapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';

class settingPage extends StatelessWidget {
  const settingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "S E T T I N G",
          style: TextStyle(
            color: Color(0xFFFF6B00),
            fontFamily: 'atma',
            fontSize: 33,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pushReplacement('/');
          },
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              "Mode",
              style: TextStyle(
                color: Color(0xFFFF6B00),
                fontFamily: 'atma',
                fontSize: 33,
              ),
            ),
            CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}
