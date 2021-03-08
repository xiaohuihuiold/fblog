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

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.watch(context);
    WebProvider webProvider = WebProvider.watch(context);
    _routerDelegate.pages = {
      HomePage.routerName: PageInfo(
        title: '首页',
        builder: (context, id, parameter, arguments) => HomePage(),
      ),
      TestPage.routerName: PageInfo(
        title: '测试',
        builder: (context, id, parameter, arguments) =>
            TestPage(id: id, parameter: parameter, arguments: arguments),
      ),
    };
    return MaterialApp.router(
      title: webProvider.title,
      darkTheme: themeProvider.darkTheme,
      theme: themeProvider.theme,
      routerDelegate: _routerDelegate,
      routeInformationParser: BlogRouteInformationParser(),
    );
  }
}
