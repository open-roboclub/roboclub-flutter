class Event {
  String eventName;
  String details;
  String endTime;
  String place;
  String posterURL;
  String startTime;
  String date;
  String regFormLink;
  bool isFeatured;

  Event({
    this.eventName,
    this.details,
    this.place,
    this.startTime,
    this.date,
    this.posterURL,
    this.endTime,
    this.regFormLink,
    this.isFeatured,
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
    data['regFormLink'] = event.regFormLink;
    data['isFeatured'] = event.isFeatured;

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
    this.regFormLink = mapData['regFormLink'];
    this.isFeatured = mapData['isFeatured'];
  }
}
