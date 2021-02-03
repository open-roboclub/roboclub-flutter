class Event {
  String eventName;
  String details;
  String duration;
  String place;
  String posterURL;
  String time;
  String date;

  Event({
    this.eventName = "",
    this.details = "",
    this.place = "",
    this.time = "",
    this.date = "",
    this.posterURL = "",
    this.duration = "",
  });

  Map toMap(Event event) {
    var data = Map<String, dynamic>();
    data['eventName'] = event.eventName;
    data['details'] = event.details;
    data["place"] = event.place;
    data["time"] = event.time;
    data["date"] = event.date;
    data["posterURL"] = event.posterURL;
    data["duration"] = event.duration;

    return data;
  }

  // name constructor
  Event.fromMap(Map<String, dynamic> mapData) {
    this.eventName = mapData['eventName'];
    this.details = mapData['details'];
    this.place = mapData['place'];
    this.time = mapData['time'];
    this.date = mapData['date'];
    this.posterURL = mapData['posterURL'];
    this.duration = mapData['duration'];
  }
}
