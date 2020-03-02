import 'dart:convert';

class ItemModel {
  final String by;
  final int descendants;
  final int id;
  final List<dynamic> kids;
  final int score;
  final int time;
  final String title;
  final String type;
  final String url;
  final bool deleted;
  final String text;
  final bool dead;
  final int parent;

  ItemModel(
      {this.by,
      this.descendants,
      this.id,
      this.kids,
      this.score,
      this.time,
      this.title,
      this.type,
      this.url,
      this.dead,
      this.deleted,
      this.parent,
      this.text});

  ItemModel.fromJson(Map<String, dynamic> parsedJson) 
      : by = parsedJson['by'] ?? '',
        descendants = parsedJson['descendants'] ?? 0,
        id = parsedJson['id'],
        kids = parsedJson['kids'] ?? [],
        score = parsedJson['score'],
        time = parsedJson['time'],
        title = parsedJson['title'],
        type = parsedJson['type'],
        url = parsedJson['url'],
        deleted = parsedJson['deleted'] ?? false,
        dead = parsedJson['dead'] ?? false,
        parent = parsedJson['parent'],
        text = parsedJson['text'] ?? '';

    ItemModel.fromDB(Map<String, dynamic> parsedJson) 
      : by = parsedJson['by'],
        descendants = parsedJson['descendants'],
        id = parsedJson['id'],
        kids = jsonDecode(parsedJson['kids']),
        score = parsedJson['score'],
        time = parsedJson['time'],
        title = parsedJson['title'],
        type = parsedJson['type'],
        url = parsedJson['url'],
        deleted = parsedJson['deleted'] == 1,
        dead = parsedJson['dead'] == 1,
        parent = parsedJson['parent'],
        text = parsedJson['text'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['descendants'] = this.descendants;
    data['id'] = this.id;
    data['kids'] = jsonEncode(this.kids);
    data['score'] = this.score;
    data['time'] = this.time;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    data['deleted'] = this.deleted ? 1 : 0;
    data['dead'] = this.dead ? 1 : 0;
    data['parent'] = this.parent;
    data['text'] = this.text;
    return data;
  }
}
