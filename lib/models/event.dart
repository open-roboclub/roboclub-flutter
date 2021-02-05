class Event {
  String eventName;
  String description;
  String date;
  String time;
  String eventImg;
  String hostImg;
  String hostedBy;
  String venue;

  Event({
    this.eventName,
    this.description,
    this.date,
    this.time,
    this.eventImg,
    this.hostImg,
    this.hostedBy,
    this.venue,
  });

  Map toMap(Event event) {
    var data = Map<String, dynamic>();
    data['eventName'] = event.eventName;
    data['description'] = event.description;
    data['date'] = event.date;
    data['time'] = event.time;
    data['eventImg'] = event.eventImg;
    data['hostImg'] = event.hostImg;
    data['hostedBy'] = event.hostedBy;
    data['venue'] = event.venue;

    return data;
  }

  // Named constructor
  Event.fromMap(Map<String, dynamic> mapData) {
    this.eventName = mapData['eventName'];
    this.description = mapData['description'];
    this.date = mapData['date'];
    this.time = mapData['time'];
    this.eventImg = mapData['eventImg'];
    this.hostImg = mapData['hostImg'];
    this.hostedBy = mapData['hostedBy'];
    this.venue = mapData['venue'];
  
  }
}

