class Weight {
  int _id;
  int _weight;
  String _date;

  //Constructors
  Weight(this._weight, this._date);
  Weight.withId(this._id, this._weight, this._date);

  //All getters
  int get id => _id;
  int get weight => _weight;
  String get date => _date;

  //All setters
  set weight(int weight) {
    if (weight < 200 && weight > 0) {
      this._weight = weight;
    }
  }

  set date(String date) {
    this._date = date;
  }

  //convert Weight  object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['weight'] = _weight;
    map['date'] = _date;

    return map;
  }

  //convert map to Weight object
  Weight.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._weight = map['weight'];
    this._date = map['date'];
  }
}
