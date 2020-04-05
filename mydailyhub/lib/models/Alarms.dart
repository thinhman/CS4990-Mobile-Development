
class Alarms {
  String id;
  String time;
  List<dynamic> days;
  bool active;

  Alarms(this.id, this.time, this.days, this.active);

  Alarms.fromJson(Map<String, dynamic> json){
    id = json["id"];
    time = json["time"];
    days = json["days"];
    active = json["active"];
  }
}