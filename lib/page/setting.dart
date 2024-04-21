import 'package:chatmusicapp/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
              value: Provider.of<ThemeProvider>(context)
                  .isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context,
                      listen:
                          false)
                  .toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}
