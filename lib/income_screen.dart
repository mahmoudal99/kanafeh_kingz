import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:kanafeh_kings/models/weekly_income.dart';
import 'package:kanafeh_kings/week_income.dart';
import 'package:provider/provider.dart';

import 'month_income.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    WeekIncome(),
    MonthIncome(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Income',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        selectedFontSize: 12.0,
        currentIndex: _currentIndex,
        elevation: 10.0,
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.attach_money, size: 20.0), title: Text("Week Income"),),
          new BottomNavigationBarItem(icon: Icon(Icons.attach_money, size: 20.0), title: Text("Month Income"),)
        ],
      ),
      body: _children[_currentIndex],
    );
  }

}
