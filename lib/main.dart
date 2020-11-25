import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanafeh_kings/create_order.dart';
import 'package:kanafeh_kings/income_screen.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:kanafeh_kings/models/profit.dart';
import 'package:kanafeh_kings/models/quantity.dart';
import 'package:kanafeh_kings/models/weekly_income.dart';
import 'package:kanafeh_kings/order_board.dart';
import 'package:kanafeh_kings/products_quantity_screen.dart';
import 'package:kanafeh_kings/services/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/order.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DateTime dateTime = DateTime.now();
  runApp(MyApp(
    dateTime: dateTime,
  ));
}

class MyApp extends StatefulWidget {
  DateTime dateTime;

  MyApp({
    Key key,
    this.dateTime,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          value: cloudFirestore.streamMonthlyIncome(),
        ),
        StreamProvider<Quantity>.value(
          value: cloudFirestore
              .streamDayQuantity(widget.dateTime.month.toString(), widget.dateTime.day.toString(), ),
        ),
      ],
      child: MaterialApp(
        title: 'Kanafeh Kingz',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: 'Kanafeh Kingz',
          orderDate: widget.dateTime,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  DateTime orderDate;

  MyHomePage({Key key, this.title, this.orderDate}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Order> orders;

  TimeOfDay time;
  double titleSize = 16;
  int mainWidgetWidthScale = 50;
  double iconSize = 26;
  double checkBoxScale = 0.8;
  bool showOrderDesc = false;
  double textSize = 16;
  double orderTextSize = 16;
  double addressTextSize = 16;
  double orderCompleteText = 10;
  double paddingForOrderComplete = 1;

  int _currentIndex = 0;
  List<Widget> _children = [];


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      ShowOrder(orderDate: widget.orderDate,),
      QuantityScreen(),
    ];
    time = TimeOfDay.now();
  }



  @override
  Widget build(BuildContext context) {
    Profit profit = Provider.of<Profit>(context);
    final orders = Provider.of<List<Order>>(context);

    if (profit == null) {
      setState(() {
        profit = new Profit(profit: 0.toString());
      });
    }

      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(
            'Kanafeh Kings',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          elevation: 15,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        orders != null ? orders.length.toString() : "0",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )),
            ),
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
        body: _children[_currentIndex],
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
            new BottomNavigationBarItem(icon: Icon(Icons.group, size: 20.0), title: Text("Orders"),),
            new BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart, size: 20.0), title: Text("Quantity"),)
          ],
        ),
      );


  }

}

class ShowOrder extends StatefulWidget {


  DateTime orderDate;

  ShowOrder({Key key, this.orderDate}) : super(key: key);

  @override
  _ShowOrderState createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {

  CloudFirestore cloudFirestore = new CloudFirestore();
  _launchCaller(String phoneNumber) async {
    String url = "tel:" + phoneNumber;
    await launch(url);
  }
  TimeOfDay time;
  double titleSize = 16;
  int mainWidgetWidthScale = 50;
  double iconSize = 26;
  double checkBoxScale = 0.8;
  bool showOrderDesc = false;
  double textSize = 16;
  double orderTextSize = 16;
  double addressTextSize = 16;
  double orderCompleteText = 10;
  double paddingForOrderComplete = 1;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Order>>(context);
    if(orders != null) {
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
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => OrderBoard(dateTime: widget.orderDate,)
                    ));
                  },
                  color: Colors.white,
                  elevation: 0,
                  child: Icon(
                    Icons.developer_board,
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
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => OrderBoard(dateTime: widget.orderDate,)
                      ));
                    },
                    color: Colors.white,
                    elevation: 0,
                    child: Icon(
                      Icons.developer_board,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                  children: orders
                      .map(
                        (order) =>
                    // Order information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width -
                              mainWidgetWidthScale,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 20),
                            child: InkWell(
                              onTap: () {
                                showDialog(context: context, child:
                                new AlertDialog(
                                  title: new Text("Order"),
                                  content: new Text(order.orderDesc),
                                )
                                );
                              },
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    // Name & Time
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
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
                                                top: 10, left: 20),
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
                                        InkWell(
                                          onTap: () {
                                            _updateTime(order.orderID, order.timeOfDay);
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
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, right: 10, left: 20),
                                          child: InkWell(
                                            onTap: () {
                                              cloudFirestore.deleteOrder(
                                                  order,
                                                  widget.orderDate.month
                                                      .toString(), widget.orderDate);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: iconSize,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Location & Payment Type
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.teal,
                                                    size: iconSize,
                                                  ),
                                                ),
                                                Container(
                                                  width: 200,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                                    child: SelectableText(
                                                      order.address,
                                                      maxLines: 2,
                                                      onTap: () {
                                                        _updateValue(
                                                            order,
                                                            "address",
                                                            "e.g. Dublin 24",
                                                            "Update Address");
                                                      },
                                                      style: TextStyle(
                                                          fontSize: addressTextSize),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: showOrderDesc,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20),
                                            child: SelectableText(
                                              order.orderDesc,
                                              style: TextStyle(
                                                  fontSize: orderTextSize
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20,
                                              top: 20,
                                              right: 10),
                                          child: Align(
                                              alignment:
                                              Alignment.bottomCenter,
                                              child: order.paymentType
                                                  .contains("Cash")
                                                  ? GestureDetector(
                                                onDoubleTap: () {
                                                  cloudFirestore.togglePaymentMethod(order.orderID, widget.orderDate.day.toString(), widget.orderDate.month.toString(),  order.paymentType);
                                                },
                                                child: Image.asset(
                                                  "assets/cash.png",
                                                  height: 35,
                                                  width: 35,
                                                ),
                                              )
                                                  : GestureDetector(
                                                onDoubleTap: () {
                                                  cloudFirestore.togglePaymentMethod(order.orderID, widget.orderDate.day.toString(), widget.orderDate.month.toString(),  order.paymentType);

                                                },
                                                child: Icon(
                                                  Icons.credit_card,
                                                  color: Colors.black,
                                                  size: iconSize,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                    // Number & Order Total
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _launchCaller(
                                                        order.phoneNumber);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        left: 10),
                                                    child: Icon(
                                                      Icons.phone,
                                                      color:
                                                      Colors.blueAccent,
                                                      size: iconSize,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 10),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        _updateValue(
                                                            order,
                                                            "phoneNumber",
                                                            "e.g. 089 494 5632",
                                                            "Update Number");
                                                      },
                                                      child: Text(
                                                        order.phoneNumber,
                                                        style: TextStyle(
                                                            fontSize:
                                                            textSize),
                                                      )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  bottom: 5,
                                                  top: 10,
                                                  right: 10),
                                              child: Align(
                                                alignment:
                                                Alignment.bottomCenter,
                                                child: Text(
                                                  "Order Total",
                                                  style: TextStyle(
                                                      fontSize:
                                                      textSize - 2,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  bottom: 20,
                                                  right: 10),
                                              child: Align(
                                                alignment:
                                                Alignment.bottomCenter,
                                                child: Text(
                                                  "€" +
                                                      order.orderPrice
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: textSize,
                                                      fontWeight: FontWeight
                                                          .normal),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                  "assets/writing.png",
                                  height: 25,
                                  width: 25,
                                ),
                                onTap: () {
                                  _updateValue(order, "orderDesc", "Order note", "Add note");
                                },
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 15),
                                child: Column(
                                  children: [
                                    Transform.scale(
                                      scale: checkBoxScale,
                                      child: Checkbox(
                                        value: order.orderComplete,
                                        onChanged: (val) {
                                          cloudFirestore.setOrderDone(
                                              order.orderID,
                                              widget.orderDate.day
                                                  .toString(),
                                              val,
                                              widget.orderDate.month
                                                  .toString());
                                          order.orderComplete = val;
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Order \nComplete",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: orderCompleteText),
                                    )
                                  ],
                                ),
                              ),
                              order.isPaid
                                  ? GestureDetector(
                                onDoubleTap: () {
                                  cloudFirestore.toggleIsPaid(order.orderID, widget.orderDate.day.toString(), widget.orderDate.month.toString(), order.isPaid);
                                },
                                child: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: iconSize,
                                ),
                              )
                                  : GestureDetector(
                                onDoubleTap: () {
                                  cloudFirestore.toggleIsPaid(order.orderID, widget.orderDate.day.toString(), widget.orderDate.month.toString(), order.isPaid);

                                },
                                child: Icon(
                                  Icons.do_not_disturb_alt,
                                  color: Colors.red,
                                  size: iconSize,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                      .toList()),
            ),
          ],
        ),
      );
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

  _updateTime(String id, String time) async {
    TimeOfDay timeOfDay = await showTimePicker(context: context, initialTime: new TimeOfDay.now());

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
                builder: (context) => MyApp(
                  dateTime: dateTime,
                )));
      });
    }
  }
}

