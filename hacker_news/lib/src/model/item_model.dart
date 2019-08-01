class ItemModel {
  final String by;
  final int descendants;
  final int id;
  final List<int> kids;
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
      : by = parsedJson['by'],
        descendants = parsedJson['descendants'],
        id = parsedJson['id'],
        kids = parsedJson['kids'].cast<int>(),
        score = parsedJson['score'],
        time = parsedJson['time'],
        title = parsedJson['title'],
        type = parsedJson['type'],
        url = parsedJson['url'],
        deleted = parsedJson['deleted'],
        dead = parsedJson['dead'],
        parent = parsedJson['parent'],
        text = parsedJson['text'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = this.by;
    data['descendants'] = this.descendants;
    data['id'] = this.id;
    data['kids'] = this.kids;
    data['score'] = this.score;
    data['time'] = this.time;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    data['deleted'] = this.deleted;
    data['dead'] = this.dead;
    data['parent'] = this.parent;
    data['text'] = this.text;
    return data;
  }
}
