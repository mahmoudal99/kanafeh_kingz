import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:kanafeh_kings/models/weekly_income.dart';
import 'package:provider/provider.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  @override
  Widget build(BuildContext context) {
    WeeklyIncome weeklyIncome = Provider.of<WeeklyIncome>(context);
    MonthlyIncome monthlyIncome = Provider.of<MonthlyIncome>(context);
    var allWeeks = Provider.of<List<WeeklyIncome>>(context);
    var allMonths = Provider.of<List<WeeklyIncome>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Income',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Week Income",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "€" + weeklyIncome.profit,
                    style: TextStyle(color: Colors.green, fontSize: 26),
                  )
                ],
              ),
            ),
          ),
          _showAllWeeks(allWeeks)
        ],
      ),
    );
  }

  Widget _showAllWeeks(List<WeeklyIncome> weeklyIncome) {
    return SingleChildScrollView(
      child: Column(
          children: weeklyIncome
              .map(
                (week) =>
                    // Order information
                    Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    margin: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Week " + week.week,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            "€" + week.profit,
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        ],
                      ),
                    ) ,
                  ),
                ),
              )
              .toList()),
    );
  }
}
