
class Commute {
  String label;
  String time;
  String startLocation;
  String endLocation;

  Commute(this.label, this.time, this.startLocation, this.endLocation);

  Commute.fromJson(Map<String, dynamic> json){
    label = json["label"];
    time = json["time"];
    startLocation = json["startLocation"];
    endLocation = json["endLocation"];
  }
}