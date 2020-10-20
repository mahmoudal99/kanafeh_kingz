import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanafeh_kings/create_order.dart';
import 'package:kanafeh_kings/models/profit.dart';
import 'package:kanafeh_kings/services/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/order.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CloudFirestore cloudFirestore = new CloudFirestore();
  String today = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();

  void _updateDay(String day, String month) {
    setState(() {
      today = day;
      month = month;
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
          value: cloudFirestore.streamOrders(today),
        ),
        StreamProvider<Profit>.value(
          value: cloudFirestore.streamProfit(today, month),
        )
      ],
      child: MaterialApp(
        title: 'Kanafeh Kings',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(
          title: 'Kanafeh Kingz',
          function: _updateDay,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Function function;

  MyHomePage({Key key, this.title, this.function}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Order> orders;
  DateTime pickedDate;
  TimeOfDay time;
  CloudFirestore cloudFirestore = new CloudFirestore();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = DateTime.now();
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
      return ScreenTypeLayout(
        tablet: Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            title: Text(
              'Kanafeh Kings',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            elevation: 15,
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                  "Total: " + profit.profit,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
              )
            ],
          ),
          body: orders.length == 0
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
                              pickedDate.day.toString() +
                                  "/" +
                                  pickedDate.month.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green),
                            )),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              _pickDate();
                            },
                            child: Icon(
                              Icons.calendar_today,
                              size: 35,
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
                                pickedDate.day.toString() +
                                    "/" +
                                    pickedDate.month.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 15, right: 15),
                            child: InkWell(
                              onTap: () {
                                _pickDate();
                              },
                              child: Icon(
                                Icons.calendar_today,
                                size: 30,
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
                                    Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          200,
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _showDialog(order.orderID);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10, left: 20),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Text(
                                                          order.customerName,
                                                          style: TextStyle(
                                                              fontSize: 23,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _updateTime(
                                                          order.orderID);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              right: 10),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Text(
                                                          order.timeOfDay,
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                right: 10,
                                                                left: 20),
                                                        child: InkWell(
                                                          onTap: () {
                                                            cloudFirestore
                                                                .deleteOrder(
                                                                    order,
                                                                    pickedDate
                                                                        .month
                                                                        .toString());
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Location & Payment Type
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child:
                                                                SelectableText(
                                                              order.address,
                                                              style: TextStyle(
                                                                  fontSize: 22),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: SelectableText(
                                                      order.orderDesc,
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20,
                                                            top: 20,
                                                            right: 10),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: order.paymentType
                                                                .contains(
                                                                    "Cash")
                                                            ? Image.asset(
                                                                "assets/cash.png",
                                                                height: 35,
                                                                width: 35,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .credit_card,
                                                                color: Colors
                                                                    .black,
                                                                size: 35,
                                                              )),
                                                  ),
                                                ],
                                              ),
                                              // Number & Order Total
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons.phone,
                                                              color: Colors
                                                                  .blueAccent,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  _launchCaller(
                                                                      order
                                                                          .phoneNumber);
                                                                },
                                                                child: Text(
                                                                  order
                                                                      .phoneNumber,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22),
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
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5,
                                                                top: 10,
                                                                right: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            "Order Total",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 20,
                                                                right: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            "€" +
                                                                order.orderPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            child: Column(
                                              children: [
                                                Transform.scale(
                                                  scale: 1.2,
                                                  child: Checkbox(
                                                    value: order.orderComplete,
                                                    onChanged: (val) {
                                                      cloudFirestore
                                                          .setOrderDone(
                                                              order
                                                                  .customerName,
                                                              pickedDate.day
                                                                  .toString(),
                                                              val);
                                                      order.orderComplete = val;
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  "Order \nComplete",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                          order.isPaid
                                              ? Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                  size: 35,
                                                )
                                              : Icon(
                                                  Icons.do_not_disturb_alt,
                                                  color: Colors.red,
                                                  size: 35,
                                                )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                              .toList()),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateOrderScreen()));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
        mobile: Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            title: Text(
              'Kanafeh Kings',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            elevation: 15,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "Total: " + profit.profit,
                  style: TextStyle(color: Colors.white),
                )),
              )
            ],
          ),
          body: orders.length == 0
              ?
              // No orders widget
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              pickedDate.day.toString() +
                                  "/" +
                                  pickedDate.month.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green),
                            )),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              _pickDate();
                            },
                            child: Icon(
                              Icons.calendar_today,
                              size: 25,
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
                  child: Column(
                    children: [
                      // Date & Calendar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                pickedDate.day.toString() +
                                    "/" +
                                    pickedDate.month.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                _pickDate();
                              },
                              child: Icon(
                                Icons.calendar_today,
                                size: 25,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      // Orders column
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: orders
                              .map(
                                (order) => Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          50,
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, left: 20),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Text(
                                                        order.customerName,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, right: 10),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Text(
                                                        order.timeOfDay,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            cloudFirestore
                                                                .deleteOrder(
                                                                    order,
                                                                    pickedDate
                                                                        .month
                                                                        .toString());
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // Location & Payment Type
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child:
                                                                SelectableText(
                                                              order.address,
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20,
                                                            top: 20,
                                                            right: 10),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: order.paymentType
                                                                .contains(
                                                                    "Cash")
                                                            ? Image.asset(
                                                                "assets/cash.png",
                                                                height: 25,
                                                                width: 25,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .credit_card,
                                                                color: Colors
                                                                    .black,
                                                                size: 24,
                                                              )),
                                                  ),
                                                ],
                                              ),
                                              // Number & Order Total
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons.phone,
                                                              color: Colors
                                                                  .blueAccent,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  _launchCaller(
                                                                      order
                                                                          .phoneNumber);
                                                                },
                                                                child: Text(
                                                                  order
                                                                      .phoneNumber,
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
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5,
                                                                top: 10,
                                                                right: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            "Order Total",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 20,
                                                                right: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            "€" +
                                                                order.orderPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
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
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            children: [
                                              Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: order.orderComplete,
                                                  onChanged: (val) {
                                                    cloudFirestore.setOrderDone(
                                                        order.customerName,
                                                        pickedDate.day
                                                            .toString(),
                                                        val);
                                                    order.orderComplete = val;
                                                  },
                                                ),
                                              ),
                                              Text(
                                                "Order \nComplete",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                        order.isPaid
                                            ? Icon(
                                                Icons.done,
                                                color: Colors.green,
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.do_not_disturb_alt,
                                                color: Colors.red,
                                                size: 30,
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              )
                              .toList()),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateOrderScreen()));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      );
    }

    return Container(
      width: 0,
      height: 0,
    );
  }

  _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (dateTime != null) {
      setState(() {
        pickedDate = dateTime;
      });
      widget.function(pickedDate.day.toString(), pickedDate.month.toString());
    }
  }

  _updateTime(String id) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      setState(() {
        print("New: " + timeOfDay.toString());
      });
      cloudFirestore.updateOrderTime(id, pickedDate.day.toString(),
          timeOfDay.hour.toString() + ":" + timeOfDay.minute.toString());
    }
  }

  _showDialog(String id, ) async {

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
                      labelText: 'Update Name', hintText: 'eg. John Smith'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('UPDATE'),
                onPressed: () {
                  cloudFirestore.updateOrderName(id, pickedDate.day.toString(), textEditingController.text);
                  Navigator.pop(context);
                })
          ],
        ));
  }
}
