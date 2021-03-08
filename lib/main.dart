import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/screen_provider.dart';
import 'provider/theme_provider.dart';
import 'provider/web_provider.dart';
import 'router/router.dart';
import 'page/home/home_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: ThemeProvider()),
      ChangeNotifierProvider.value(value: WebProvider()),
      Provider.value(value: ScreenProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BlogRouterDelegate _routerDelegate = BlogRouterDelegate();

  Map<String, PageInfo> _pages = {
    HomePage.routerName: HomePage.pageInfo,
  };

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.watch(context);
    WebProvider webProvider = WebProvider.watch(context);
    _routerDelegate.pages = _pages;
    return MaterialApp.router(
      title: webProvider.title,
      darkTheme: themeProvider.darkTheme,
      theme: themeProvider.theme,
      routerDelegate: _routerDelegate,
      routeInformationParser: BlogRouteInformationParser(),
    );
  }
}
