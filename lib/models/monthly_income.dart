class MonthlyIncome {
  String profit;
  String month;

  MonthlyIncome({this.profit, this.month});

  factory MonthlyIncome.fromMap(Map data) {
    print('---->' +  data.toString());
    return MonthlyIncome(profit: data['income'].toString(), month: data['month'].toString());
  }
}
