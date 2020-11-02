class MonthlyIncome {
  String profit;
  String month;

  MonthlyIncome({this.profit, this.month});

  factory MonthlyIncome.fromMap(Map data) {
    data = data ?? {"profit" : 0};
    return MonthlyIncome(profit: data['income'].toString(), month: data['month']);
  }
}
