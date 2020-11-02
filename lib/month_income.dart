import 'package:flutter/material.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:provider/provider.dart';

import 'models/weekly_income.dart';

class MonthIncome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MonthlyIncome monthlyIncome = Provider.of<MonthlyIncome>(context);
    var allMonths = Provider.of<List<MonthlyIncome>>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Card(
              color: Colors.blue,
              margin: EdgeInsets.all(20),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Month Income",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    "€" + monthlyIncome.profit,
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
                children: allMonths
                    .map(
                      (month) =>
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
                              "Month " + month.month,
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              "€" + month.profit,
                              style: TextStyle(color: Colors.green, fontSize: 18),
                            ),
                          ],
                        ),
                      ) ,
                    ),
                  ),
                )
                    .toList()),
          )
        ],
      ),
    );
  }
}
