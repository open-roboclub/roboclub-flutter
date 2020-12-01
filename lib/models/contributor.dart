class Contributor {
  String name;
  String description;
  String representativeImg;
  String amount;

  Contributor({
    this.description,
    this.name,
    this.representativeImg,
    this.amount,
  });

  Map toMap(Contributor contributor) {
    var data = Map<String, dynamic>();
    data['name'] = contributor.name;
    data['description'] = contributor.description;
    data['representativeImg'] = contributor.representativeImg;
    data['amount'] = contributor.amount;
    return data;
  }

  // Named constructor
  Contributor.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData['name'];
    this.description = mapData['description'];
    this.representativeImg = mapData['representativeImg'];
    this.amount = mapData['amount'];
  }
}
