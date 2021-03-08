import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class WebProvider extends ChangeNotifier {
  String _title = '';

  String get title => '灰灰のBLOG${_title.isEmpty?'':'-'}$_title';

  set title(String value) {
    if (_title != value) {
      _title = value;
      notifyListeners();
    }
  }

  static WebProvider read(BuildContext context) => context.read<WebProvider>();

  static WebProvider watch(BuildContext context) =>
      context.watch<WebProvider>();
}
