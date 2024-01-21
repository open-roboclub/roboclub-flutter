class Event {
  late String eventName;
  late String details;
  late String endTime;
  late String place;
  late String posterURL;
  late String startTime;
  late String date;
  late String regFormLink;
  late bool isFeatured;

  Event({
    required this.eventName,
    required this.details,
    required this.place,
    required this.startTime,
    required this.date,
    required this.posterURL,
    required this.endTime,
    required this.regFormLink,
    required this.isFeatured,
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
