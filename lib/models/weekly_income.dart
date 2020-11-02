class WeeklyIncome {
  String profit;
  String week;

  WeeklyIncome({this.profit, this.week});

  factory WeeklyIncome.fromMap(Map data) {
    data = data ?? {"income" : 0};
    return WeeklyIncome(profit: data['income'].toString(), week: data['week']);
  }
}
