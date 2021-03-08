import 'dart:math';

import 'package:flutter/material.dart';

import '../../provider/screen_provider.dart';

class HomePage extends StatefulWidget {
  static const routerName = '/';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('jump'),
          onPressed: () {
            Navigator.of(context).pushNamed('/test', arguments: '测试');
          },
        ),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  static const routerName = '/test';

  final int? id;
  final Map<String, String>? parameter;
  final Object? arguments;

  const TestPage({
    Key? key,
    this.id,
    this.parameter,
    this.arguments,
  }) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'id:${widget.id}',
              style: TextStyle(
                fontSize: 52.0,
              ),
            ),
            Text(
              'arguments:${widget.arguments}',
              style: TextStyle(
                fontSize: 52.0,
              ),
            ),
            if (widget.parameter != null)
              for (MapEntry<String, String> kv in widget.parameter!.entries)
                Text(
                  'key:${kv.key},value:${kv.value}',
                  style: TextStyle(
                    fontSize: 52.0,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
