class Notifications {
  String title;
  String msg;
  String link;
  String date;

  Notifications({
    this.title,
    this.msg,
    this.link,
    this.date,
  });

  Map toMap(Notifications notification) {
    var data = Map<String, dynamic>();
    data['title'] = notification.title;
    data['msg'] = notification.msg;
    data['link'] = notification.link;
    data['date'] = notification.date;
    return data;
  }

  // Named constructor
  Notifications.fromMap(Map<String, dynamic> mapData) {
    this.title = mapData['title'];
    this.msg = mapData['msg'];
    this.link = mapData['link'];
    this.date = mapData['date'];
  }
}
