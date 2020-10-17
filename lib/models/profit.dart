class Profit {
  String profit;

  Profit({this.profit});

  factory Profit.fromMap(Map data) {
    data = data ?? {"profit" : 0};
    return Profit(profit: data['profit'].toString());
  }
}
