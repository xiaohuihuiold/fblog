import 'package:fblog/entity/post_entity.dart';
import 'package:flutter/material.dart';
import '../../router/router.dart';
import '../../http/http_client.dart';
import '../../provider/manifest_provider.dart';

class PostPage extends StatefulWidget {
  static const routerName = '/post';
  static final pageInfo = PageInfo(
    title: '文章',
    builder: (context, id, parameter, arguments) => PostPage(id: id),
  );

  static Future push(BuildContext context, int? id) {
    return Navigator.of(context).pushNamed('$routerName/$id');
  }

  final int? id;

  const PostPage({Key? key, this.id}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String? _data;

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      return;
    }
    ManifestProvider.read(context).openPostById(widget.id!).then((value) {
      setState(() {
        _data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(_data ?? ''),
    );
  }
}
