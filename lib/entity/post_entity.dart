import '../ext/map_ext.dart';

class PostEntity {
  int id;
  String type;
  String file;
  String title;
  String? cover;
  int createTime;
  int lastUpdateTime;
  String? category;
  List<String>? tags;

  PostEntity({
    required this.id,
    required this.type,
    required this.file,
    required this.title,
    this.cover,
    required this.createTime,
    required this.lastUpdateTime,
    this.category,
    this.tags,
  });

  factory PostEntity.fromJson(Map json) {
    dynamic value;
    return PostEntity(
      id: json.getInt('id'),
      type: json.getString('type'),
      file: json.getString('file'),
      title: json.getString('title'),
      cover: json.getStringOrNull('cover'),
      createTime: json.getInt('create_time'),
      lastUpdateTime: json.getInt('last_update_time'),
      category: json.getStringOrNull('category'),
      tags: json.getArrayOrNull('tags')?.cast<String>(),
    );
  }
}
