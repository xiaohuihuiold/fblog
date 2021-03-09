import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/router.dart';
import '../../provider/screen_provider.dart';
import '../../provider/manifest_provider.dart';
import '../../entity/post_entity.dart';
import '../../widget/three_view.dart';
import '../post/post_page.dart';

class HomePage extends StatefulWidget {
  static const routerName = '/';
  static final pageInfo = PageInfo(
    title: '首页',
    builder: (context, id, parameter, arguments) => HomePage(),
  );

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ManifestProvider.read(context).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ThreeView(),
    );
  }
}
