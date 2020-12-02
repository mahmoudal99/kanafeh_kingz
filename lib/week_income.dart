import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/weekly_income.dart';

class WeekIncome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    WeeklyIncome weeklyIncome = Provider.of<WeeklyIncome>(context);
    var allWeeks = Provider.of<List<WeeklyIncome>>(context);

    if(allWeeks != null) {
      return Container(
        color: Colors.white,
        child: SingleChildScrollView(
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
                        "Week Income",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        "€" + weeklyIncome.profit,
                        style: TextStyle(color: Colors.white, fontSize: 26),
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
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Week " + week.week,
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                    Text(
                                      "€" + week.profit,
                                      style: TextStyle(color: Colors.green, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    weekDay(week.mon != null ? week.mon : "0", "Mon"),
                                    weekDay(week.tue != null ? week.tue : "0", "Tue"),
                                    weekDay(week.wed != null ? week.wed : "0", "Wed"),
                                    weekDay(week.thur != null ? week.thur : "0", "Thur"),
                                    weekDay(week.fri != null ? week.fri : "0", "Fri"),
                                    weekDay(week.sat != null ? week.sat : "0", "Sat"),
                                    weekDay(week.sun != null ? week.sun : "0", "Sun"),
                                  ],
                                )
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
        ),
      );
    }else {
      return Container();
    }


  }

  Widget weekDay(String dayIncome, String day) {
    return Column(
      children: [
        Text(
          dayIncome != null ? dayIncome : "0"
        ),
        Text(
          day,
          style: TextStyle(
            color: Colors.grey
          ),
        )
      ],
    );
  }
}
