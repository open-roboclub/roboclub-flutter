class Event {
  String eventName;
  String details;
  String endTime;
  String place;
  String posterURL;
  String startTime;
  String date;

  Event({
    this.eventName,
    this.details,
    this.place,
    this.startTime,
    this.date,
    this.posterURL,
    this.endTime,
  });

  Map toMap(Event event) {
    var data = Map<String, dynamic>();
    data['eventName'] = event.eventName;
    data['details'] = event.details;
    data["place"] = event.place;
    data["startTime"] = event.startTime;
    data["date"] = event.date;
    data["posterURL"] = event.posterURL;
    data["endTime"] = event.endTime;

    return data;
  }

  // name constructor
  Event.fromMap(Map<String, dynamic> mapData) {
    this.eventName = mapData['eventName'];
    this.details = mapData['details'];
    this.place = mapData['place'];
    this.endTime = mapData['endTime'];
    this.date = mapData['date'];
    this.posterURL = mapData['posterURL'];
    this.startTime = mapData['startTime'];
  }
}
