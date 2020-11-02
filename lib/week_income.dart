import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/weekly_income.dart';

class WeekIncome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    WeeklyIncome weeklyIncome = Provider.of<WeeklyIncome>(context);
    var allWeeks = Provider.of<List<WeeklyIncome>>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
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
          SingleChildScrollView(
            child: Column(
                children: allWeeks
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
          )
        ],
      ),
    );
  }
}
