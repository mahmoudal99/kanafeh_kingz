class MonthlyIncome {
  String profit;

  MonthlyIncome({this.profit});

  factory MonthlyIncome.fromMap(Map data) {
    data = data ?? {"profit" : 0};
    return MonthlyIncome(profit: data['income'].toString());
  }
}
