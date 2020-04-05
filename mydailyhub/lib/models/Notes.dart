
class Notes {
  int tag;
  String title;
  String content;

  Notes(this.tag, this.title, this.content);

  Notes.fromJson(Map<String, dynamic> json){
    tag = json["tag"];
    title = json["title"];
    content = json["content"];
  }
}