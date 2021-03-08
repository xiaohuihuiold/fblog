import 'dart:html';

class LocalStorage {
  static _ThemeStorage theme = _ThemeStorage();

  static Storage _storage = window.localStorage;

  static void putString(String key, String? value) {
    if (value == null) {
      removeString(key);
      return;
    }
    _storage['string_$key'] = value;
  }

  static String? getString(String key) {
    return _storage['string_$key'];
  }

  static void removeString(String key) {
    _storage.remove('string_$key');
  }

  static void putBool(String key, bool? value) {
    if (value == null) {
      removeBool(key);
      return;
    }
    _storage['bool_$key'] = '$value';
  }

  static bool? getBool(String key) {
    String? value = _storage['bool_$key'];
    if (value == null) {
      return null;
    }
    return value == 'true';
  }

  static void removeBool(String key) {
    _storage.remove('bool_$key');
  }

  static void putInt(String key, int? value) {
    if (value == null) {
      removeInt(key);
      return;
    }
    _storage['int_$key'] = '$value';
  }

  static int? getInt(String key) {
    String? value = _storage['int_$key'];
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  static void removeInt(String key) {
    _storage.remove('int_$key');
  }

  static void putDouble(String key, double? value) {
    if (value == null) {
      removeDouble(key);
      return;
    }
    _storage['double_$key'] = '$value';
  }

  static double? getDouble(String key) {
    String? value = _storage['double_$key'];
    if (value == null) {
      return null;
    }
    return double.tryParse(value);
  }

  static void removeDouble(String key) {
    _storage.remove('double_$key');
  }
}

class _ThemeStorage {
  bool? get isDark => LocalStorage.getBool('is_dark');

  set isDark(bool? value) => LocalStorage.putBool('is_dark', value);
}
