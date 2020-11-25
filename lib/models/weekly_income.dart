class WeeklyIncome {
  String profit;
  String week;
  String mon = "0";
  String tue = "0";
  String wed = "0";
  String thur = "0";
  String fri = "0";
  String sat = "0";
  String sun = "0";

  WeeklyIncome({this.profit, this.week, this.mon, this.tue, this.wed, this.thur, this.fri, this.sat, this.sun});

  factory WeeklyIncome.fromMap(Map data) {
    data = data ?? {"income": 0};
    return WeeklyIncome(
      profit: data['income'].toString(),
      week: data['week'],
      mon: data['1'] != null ? data['1'].toString() : "0",
      tue: data['2'] != null ? data['2'].toString() : "0",
      wed: data['3'] != null ? data['3'].toString() : "0",
      thur: data['4'] != null ? data['4'].toString() : "0",
      fri: data['5'] != null ? data['5'].toString() : "0",
      sat: data['6'] != null ? data['6'].toString() : "0",
      sun: data['7'] != null ? data['7'].toString() : "0",
    );
  }
}
