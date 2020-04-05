
class HomeData {
  bool calendar;
  bool note;
  bool alarm;
  bool map;

  HomeData(this.calendar, this.note, this.alarm, this.map);

  HomeData.fromJson(Map<String, dynamic> json){
    calendar = json["calendar"];
    note = json["note"];
    alarm = json["alarm"];
    map = json["map"];
  }
}