class WeeklyIncome {
  String profit;

  WeeklyIncome({this.profit});

  factory WeeklyIncome.fromMap(Map data) {
    data = data ?? {"profit" : 0};
    return WeeklyIncome(profit: data['income'].toString());
  }
}
