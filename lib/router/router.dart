import 'dart:html';

import 'package:flutter/material.dart';

import '../provider/web_provider.dart';
import '../provider/screen_provider.dart';

class BlogRouterPath {
  final String path;
  final int? id;
  final Map<String, String>? parameter;
  final Object? arguments;

  String get originPath => id == null ? path : '$path/$id';

  factory BlogRouterPath.fromUrl(String url) {
    Uri uri = Uri.parse(url);
    return BlogRouterPath.fromPath(uri.path, parameter: uri.queryParameters);
  }

  factory BlogRouterPath.fromRouteSettings(RouteSettings setting) {
    String path = setting.name ?? '/';
    Map<String, String>? parameter;
    Object? arguments;
    if (setting.arguments is Map<String, String>?) {
      parameter = setting.arguments as Map<String, String>?;
    } else {
      arguments = setting.arguments;
    }
    return BlogRouterPath.fromPath(path,
        parameter: parameter, arguments: arguments);
  }

  factory BlogRouterPath.fromPath(
    String path, {
    Map<String, String>? parameter,
    Object? arguments,
  }) {
    Uri uri = Uri.parse(path);
    int? id;
    if (uri.pathSegments.isNotEmpty) {
      id = int.tryParse(uri.pathSegments.last);
    }
    if (id != null) {
      path = Uri(
        pathSegments: List.from(uri.pathSegments)..removeLast(),
      ).toString();
    }
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return BlogRouterPath(
      path,
      id: id,
      parameter: parameter,
      arguments: arguments,
    );
  }

  BlogRouterPath(
    this.path, {
    this.id,
    this.parameter,
    this.arguments,
  });

  BlogRouterPath.home()
      : path = '/',
        id = null,
        parameter = null,
        arguments = null;

  Uri toUri() {
    return Uri(
      path: originPath,
      queryParameters: parameter,
    );
  }

  @override
  String toString() {
    String str = toUri().toString();
    if (str.endsWith('?')) {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }
}

typedef PageBuilder = Widget Function(
  BuildContext context,
  int? id,
  Map<String, String>? parameter,
  Object? arguments,
);

class PageInfo {
  final String title;
  final PageBuilder builder;

  PageInfo({
    required this.title,
    required this.builder,
  });
}

class BlogRouterDelegate extends RouterDelegate<BlogRouterPath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<BlogRouterPath>,
        NavigatorObserver {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  BlogRouterPath _blogRouterPath = BlogRouterPath.home();

  @override
  BlogRouterPath? get currentConfiguration => _blogRouterPath;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => key;

  Map<String, PageInfo> pages = {};

  BlogRouterDelegate() {
    window.addEventListener('popstate', (event) {
      key.currentState?.maybePop();
    });
  }

  void _setRouteState(RouteSettings setting) {
    PageInfo? pageInfo = pages[BlogRouterPath.fromRouteSettings(setting).path];
    String title = '404';
    if (pageInfo != null) {
      title = pageInfo.title;
    }
    if (key.currentContext != null) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        WebProvider.read(key.currentContext!).title = title;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenProvider.read(context).isHorizontal = size.width > size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Navigator(
        key: key,
        observers: [this],
        onUnknownRoute: (setting) {
          return MaterialPageRoute(
            settings: setting,
            builder: (_) {
              return UnknownPage(setting: setting);
            },
          );
        },
        restorationScopeId: 'Navigator Scope',
        onGenerateRoute: (setting) {
          String old = _blogRouterPath.toString();
          _blogRouterPath = BlogRouterPath.fromRouteSettings(setting);
          if (old != _blogRouterPath.toString()) {
            notifyListeners();
          }
          PageInfo? pageInfo = pages[_blogRouterPath.path];
          if (pageInfo != null) {
            return MaterialPageRoute(
              builder: (context) {
                return pageInfo.builder(
                  context,
                  _blogRouterPath.id,
                  _blogRouterPath.parameter,
                  _blogRouterPath.arguments,
                );
              },
              settings: setting,
            );
          }
          return null;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(BlogRouterPath configuration) async {
    _blogRouterPath = configuration;
    if (configuration.path != '/') {
      key.currentState?.pushNamed(
        _blogRouterPath.originPath,
        arguments: _blogRouterPath.parameter,
      );
    }
    notifyListeners();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _setRouteState(route.settings);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      _setRouteState(previousRoute.settings);
      _blogRouterPath =
          BlogRouterPath.fromRouteSettings(previousRoute.settings);
      notifyListeners();
    }
  }
}

class BlogRouteInformationParser
    extends RouteInformationParser<BlogRouterPath> {
  @override
  Future<BlogRouterPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location != null) {
      return BlogRouterPath.fromUrl(routeInformation.location!);
    }
    return BlogRouterPath.home();
  }

  @override
  RouteInformation? restoreRouteInformation(BlogRouterPath configuration) {
    return RouteInformation(location: configuration.toString());
  }
}

class UnknownPage extends StatefulWidget {
  final RouteSettings setting;

  const UnknownPage({
    Key? key,
    required this.setting,
  }) : super(key: key);

  @override
  _UnknownPageState createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '404',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text('path: ${widget.setting.name ?? '???'}'),
          ],
        ),
      ),
    );
  }
}
