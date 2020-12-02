import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanafeh_kings/create_order.dart';
import 'package:kanafeh_kings/income_screen.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:kanafeh_kings/models/profit.dart';
import 'package:kanafeh_kings/models/weekly_income.dart';
import 'package:kanafeh_kings/services/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'models/order.dart';

class OrderBoard extends StatefulWidget {
  DateTime dateTime;

  OrderBoard({
    Key key,
    this.dateTime,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  _OrderBoardState createState() => _OrderBoardState();
}

class _OrderBoardState extends State<OrderBoard> {
  CloudFirestore cloudFirestore = new CloudFirestore();
  String today = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();

  void _updateDay(String day, String mon) {
    setState(() {
      today = day;
      month = mon;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Order>>.value(
          value: cloudFirestore.streamOrders(
              widget.dateTime.day.toString(), widget.dateTime.month.toString()),
        ),
        StreamProvider<Profit>.value(
          value: cloudFirestore.streamProfit(
              widget.dateTime.day.toString(), widget.dateTime.month.toString()),
        ),
        StreamProvider<List<WeeklyIncome>>.value(
          value: cloudFirestore.streamAllWeeks(),
        ),
        StreamProvider<List<MonthlyIncome>>.value(
          value: cloudFirestore.streamAllMonths(),
        ),
        StreamProvider<WeeklyIncome>.value(
          value: cloudFirestore.streamWeeklyIncome(),
        ),
        StreamProvider<MonthlyIncome>.value(
          value: cloudFirestore
              .streamMonthlyIncome(),
        ),
      ],
      child: MaterialApp(
        title: 'Kanafeh Kingz',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: MyOrderBoard(
          title: 'Kanafeh Kingz',
          orderDate: widget.dateTime,
        ),
      ),
    );
  }
}

class MyOrderBoard extends StatefulWidget {
  DateTime orderDate;

  MyOrderBoard({Key key, this.title, this.orderDate}) : super(key: key);

  final String title;

  @override
  _MyOrderBoardState createState() => _MyOrderBoardState();
}

class _MyOrderBoardState extends State<MyOrderBoard> {
  List<Order> orders;

  TimeOfDay time;
  CloudFirestore cloudFirestore = new CloudFirestore();
  double titleSize = 16;
  int mainWidgetWidthScale = 50;
  double iconSize = 22;
  double checkBoxScale = 0.8;
  bool showOrderDesc = false;
  double textSize = 16;
  double orderTextSize = 16;
  double addressTextSize = 16;
  double orderCompleteText = 10;
  double paddingForOrderComplete = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = TimeOfDay.now();
  }

  _launchCaller(String phoneNumber) async {
    String url = "tel:" + phoneNumber;
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    orders = Provider.of<List<Order>>(context);
    Profit profit = Provider.of<Profit>(context);

    if (profit == null) {
      setState(() {
        profit = new Profit(profit: 0.toString());
      });
    }

    if (orders != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(
            'Order Board',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          elevation: 15,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                    "Total: " + profit.profit,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: RaisedButton(
                    color: Colors.orange,
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => IncomeScreen()));
                    },
                    child: Text(
                      "Income",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
        body: ResponsiveBuilder(builder: (context, info) {
          var screenType = info.deviceScreenType;
          switch (screenType) {
            case DeviceScreenType.tablet:
              {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    titleSize = 30;
                    showOrderDesc = true;
                    mainWidgetWidthScale = 200;
                    checkBoxScale = 1.2;
                    iconSize = 30.00;
                    textSize = 20;
                    addressTextSize = 17;
                    orderTextSize = 17;
                    paddingForOrderComplete = 30;
                    orderCompleteText = 15;
                  });
                  // Add Your Code here.
                });

                break;
              }
          }
          return _showOrders(profit, "phone");
        }),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateOrderScreen(
                      dateTime: widget.orderDate,
                    )));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      width: 0,
      height: 0,
    );
  }

  Widget _showOrders(Profit profit, String screenType) {
    return orders.length == 0
        ?
    // No orders widget
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  widget.orderDate.day.toString() +
                      "/" +
                      widget.orderDate.month.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green),
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Main(
                            date: widget.orderDate,
                          )));
                },
                color: Colors.white,
                elevation: 0,
                child: Icon(
                  Icons.home,
                  size: iconSize,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: RaisedButton(
                onPressed: () {
                  _pickDate();
                },
                color: Colors.white,
                elevation: 0,
                child: Icon(
                  Icons.calendar_today,
                  size: iconSize,
                  color: Colors.blueAccent,
                ),
              ),
            )
          ],
        ),
        Image.asset(
          "assets/delivery.png",
          height: 200,
          width: 200,
        ),
        Text(
          "No orders today!",
          style: TextStyle(fontSize: 20),
        ),
      ],
    )
        : SingleChildScrollView(
      // Orders column
      child: Column(
        children: [
          // Date & Calendar column
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.orderDate.day.toString() +
                        "/" +
                        widget.orderDate.month.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.green),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Main(
                              date: widget.orderDate,
                            )));
                  },
                  color: Colors.white,
                  elevation: 0,
                  child: Icon(
                    Icons.home,
                    size: iconSize,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: RaisedButton(
                  onPressed: () {
                    _pickDate();
                  },
                  color: Colors.white,
                  elevation: 0,
                  child: Icon(
                    Icons.calendar_today,
                    size: iconSize,
                    color: Colors.blueAccent,
                  ),
                ),
              )
            ],
          ),
          // Order Column
          Column(
              children: orders
                  .map(
                    (order) =>
                // Order information
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 20),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  // Name & Time
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _updateTime(order.orderID);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Align(
                                            alignment:
                                            Alignment.bottomCenter,
                                            child: Text(
                                              order.timeOfDay,
                                              style: TextStyle(
                                                  fontSize: textSize,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _updateValue(
                                              order,
                                              "customerName",
                                              "e.g. John Smith",
                                              "Update name");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Align(
                                            alignment:
                                            Alignment.bottomCenter,
                                            child: Text(
                                              order.customerName,
                                              style: TextStyle(
                                                  fontSize: textSize,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10, top: 10, bottom: 20),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  // Name & Time
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _updateValue(order, "orderDesc", "Order note", "Add note");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 20, bottom: 10, right: 20),
                                          child: Align(
                                            alignment:
                                            Alignment.bottomCenter,
                                            child: Text(
                                              order.orderDesc,
                                              style: TextStyle(
                                                  fontSize: textSize,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),




                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              )
                  .toList()),

        ],
      ),
    );
  }

  _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (dateTime != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OrderBoard(
                  dateTime: dateTime,
                )));
      });
    }
  }

  _updateTime(String id) async {
    TimeOfDay timeOfDay = await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      setState(() {
        print("New: " + timeOfDay.toString());
      });
      cloudFirestore.updateOrderTime(
          id,
          widget.orderDate.day.toString(),
          widget.orderDate.month.toString(),
          timeOfDay.hour.toString() + ":" + timeOfDay.minute.toString());
    }
  }

  _updateValue(Order order, String field, String hintText, String heading) async {
    TextEditingController textEditingController = new TextEditingController();

    await showDialog(
        context: context,
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: heading, hintText: hintText),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('UPDATE'),
                onPressed: () {

                  if(field.contains("orderDesc")){
                    cloudFirestore.updateValue(
                        order.orderID,
                        widget.orderDate.day.toString(),
                        widget.orderDate.month.toString(),
                        order.orderDesc + "\n" + textEditingController.text,
                        field);
                  }else {
                    cloudFirestore.updateValue(
                        order.orderID,
                        widget.orderDate.day.toString(),
                        widget.orderDate.month.toString(),
                        textEditingController.text,
                        field);
                  }


                })
          ],
        )
    );
  }
}
