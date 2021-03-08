import 'package:flutter/material.dart';
import '../../router/router.dart';

import '../../provider/screen_provider.dart';
import '../../http/http_client.dart';
import '../../entity/manifest_entity.dart';

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
    HttpClient.get<ManifestEntity>('/data/manifest.json').then((value) {
      print(value.entity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
