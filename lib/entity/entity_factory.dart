import 'manifest_entity.dart';

typedef EntityBuilder = Object Function(Map json);

class EntityFactory {
  static Map<Type, EntityBuilder> _entities = {
    ManifestEntity: (json) => ManifestEntity.fromJson(json),
  };

  static T? create<T>(Map json) {
    Object? object;
    try {
      object = _entities[T]?.call(json);
    } catch (e) {}
    if (object is T) {
      return object;
    } else {
      return null;
    }
  }
}
