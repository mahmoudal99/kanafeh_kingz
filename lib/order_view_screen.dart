import 'package:flutter/material.dart';
import 'package:kanafeh_kings/services/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'models/order.dart';

class OrderViewScreen extends StatefulWidget {
  Order order;
  String month;
  String day;
  DateTime dateTime;

  OrderViewScreen({this.order, this.day, this.month, this.dateTime});

  @override
  _OrderViewScreenState createState() => _OrderViewScreenState();
}

class _OrderViewScreenState extends State<OrderViewScreen> {

  CloudFirestore cloudFirestore = new CloudFirestore();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Order>.value(
          value: cloudFirestore.streamOrder(widget.dateTime.day.toString(),
              widget.dateTime.month.toString(), widget.order.orderID),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: OrderWidget(day: widget.day, month: widget.month, dateTime: widget.dateTime,),
      ),
    );
  }


}

class OrderWidget extends StatefulWidget {

  String month;
  String day;
  DateTime dateTime;

  OrderWidget({this.day, this.month, this.dateTime});


  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {

  int _largeCount = 0;
  int _smallCount = 0;
  int _individualCount = 0;
  int _1kgCount = 0;
  int _500gCount = 0;
  int _nabulsiCount = 0;
  int _deliveryCount = 0;
  int _orderTotal = 0;
  CloudFirestore cloudFirestore = new CloudFirestore();
  Map<String, int> orderDescMap = new Map();

  void _updateOrderTotal(String orderType) {
    if (orderType.contains('large')) {
      setState(() {
        _orderTotal += 35;
      });
    } else if (orderType.contains('small')) {
      setState(() {
        _orderTotal += 25;
      });
    } else if (orderType.contains("baklava_1kg")) {
      _orderTotal += 28;
    } else if (orderType.contains("baklava_500g")) {
      _orderTotal += 15;
    } else if (orderType.contains("nabulsi")) {
      _orderTotal += 6;
    } else if (orderType.contains("delivery")) {
      _orderTotal += 3;
    } else {
      _orderTotal += 6;
    }
  }

  void _deductOrderTotal(String orderType) {
    if (orderType.contains('large')) {
      setState(() {
        _orderTotal -= 35;
      });
    } else if (orderType.contains('small')) {
      setState(() {
        _orderTotal -= 25;
      });
    } else if (orderType.contains("delivery")) {
      _orderTotal -= 3;
    } else if (orderType.contains("baklava_1kg")) {
      _orderTotal -= 28;
    } else if (orderType.contains("baklava_500g")) {
      _orderTotal -= 15;
    } else if (orderType.contains("nabulsi")) {
      _orderTotal -= 6;
    } else {
      _orderTotal -= 6;
    }
  }

  String constructOrderText() {
    String orderDesc = '';

    if (_largeCount > 0) {
      orderDesc = orderDesc + "Large Kanafeh: " + _largeCount.toString();
    }
    if (_smallCount > 0) {
      orderDesc = orderDesc + "\nSmall Kanafeh: " + _smallCount.toString();
    }
    if (_individualCount > 0) {
      orderDesc =
          orderDesc + "\nIndividual Kanafeh: " + _individualCount.toString();
    }
    if (_500gCount > 0) {
      orderDesc = orderDesc + "\nBaklawa 500g: " + _500gCount.toString();
    }
    if (_1kgCount > 0) {
      orderDesc = orderDesc + "\nBaklawa 1kg: " + _1kgCount.toString();
    }
    if (_nabulsiCount > 0) {
      orderDesc = orderDesc + "\nNabulsi Kanafeh: " + _nabulsiCount.toString();
    }

    return orderDesc;
  }

  Map<String, int> constructOrdermap() {
    if (_largeCount > 0) {
      setState(() {
        orderDescMap.addAll({"Large": _largeCount});
      });
    } else {
      setState(() {
        orderDescMap.addAll({"Large": 0});
      });
    }

    if (_smallCount > 0) {
      setState(() {
        orderDescMap.addAll({"Small": _smallCount});
      });
    } else {
      setState(() {
        orderDescMap.addAll({"Small": 0});
      });
    }

    if (_individualCount > 0) {
      setState(() {
        orderDescMap.addAll({"Ind": _individualCount});
      });
    } else {
      setState(() {
        orderDescMap.addAll({"Ind": 0});
      });
    }

    if (_500gCount > 0) {
      setState(() {
        orderDescMap.addAll({"500g": _500gCount});
      });
    } else {
      setState(() {
        orderDescMap.addAll({"500g": 0});
      });
    }

    if (_1kgCount > 0) {
      setState(() {
        orderDescMap.addAll({"1kg": _1kgCount});
      });
    } else {
      setState(() {
        orderDescMap.addAll({"1kg": 0});
      });
    }

    if (_nabulsiCount > 0) {
      setState(() {
        orderDescMap.addAll({"nabulsi": _nabulsiCount});
      });
    } else {
      setState(() {
        orderDescMap.addAll({"nabulsi": 0});
      });
    }

    return orderDescMap;
  }

  @override
  Widget build(BuildContext context) {
    return _showOrder();
  }

  _showOrder() {
    final order = Provider.of<Order>(context);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _updateValue(
                        order,
                        "customerName",
                        "e.g. John Smith",
                        "Update name",
                        widget.month,
                        widget.day,
                        widget.dateTime);
                  },
                  child: Text(
                    order.customerName
                        .substring(0, 1)
                        .toUpperCase() +
                        order.customerName
                            .substring(1, order.customerName.length),
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  order.phoneNumber,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Container(
                color: Colors.white,
                width: 100,
                height: 100,
                child: Card(
                  color: Colors.blue,
                  elevation: 10,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_sharp, color: Colors.white,),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          order.timeOfDay,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Delivering to:",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                        ),
                        onTap: () {
                          _updateValue(
                              order,
                              "address",
                              "New address",
                              "Address",
                              widget.month,
                              widget.day,
                              widget.dateTime);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: 250,
                  child: Text(
                    order.address,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.event_note,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Order Summary:",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: 250,
                  child: Text(
                    order.orderDesc,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payments,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Order Total:",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Text(
                    "ID. " + order.orderID.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total:",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "€" + order.orderPrice.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Payment Method:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                order.paymentType,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.edit,
                                  ),
                                  onTap: () {
                                    _updateValue(
                                        order,
                                        "paymentType",
                                        "Card/Cash",
                                        "Payment Type",
                                        widget.month,
                                        widget.day,
                                        widget.dateTime);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 15, right: 15, bottom: 60),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Orders",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Large Kanafeh"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _largeCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() => _largeCount--);
                                      _deductOrderTotal("large");
                                    })
                                    : new Container(),
                                new Text(_largeCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _largeCount++);
                                      _updateOrderTotal('large');
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Small Kanafeh"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _smallCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() => _smallCount--);
                                      _deductOrderTotal("small");
                                    })
                                    : new Container(),
                                new Text(_smallCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _smallCount++);
                                      _updateOrderTotal("small");
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Individual Kanafeh"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _individualCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(
                                              () => _individualCount--);
                                      _deductOrderTotal("ind");
                                    })
                                    : new Container(),
                                new Text(_individualCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _individualCount++);
                                      _updateOrderTotal("ind");
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Nabulsi Kanafeh"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _nabulsiCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() => _nabulsiCount--);
                                      _deductOrderTotal("nabulsi");
                                    })
                                    : new Container(),
                                new Text(_nabulsiCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _nabulsiCount++);
                                      _updateOrderTotal("nabulsi");
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Baklawa 1kg"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _1kgCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() => _1kgCount--);
                                      _deductOrderTotal("baklava_1kg");
                                    })
                                    : new Container(),
                                new Text(_1kgCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _1kgCount++);
                                      _updateOrderTotal("baklava_1kg");
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Baklawa 500g"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _500gCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() => _500gCount--);
                                      _deductOrderTotal("baklava_500g");
                                    })
                                    : new Container(),
                                new Text(_500gCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _500gCount++);
                                      _updateOrderTotal("baklava_500g");
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Delivery Charge"),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            child: Row(
                              children: [
                                _deliveryCount != 0
                                    ? new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() => _deliveryCount--);
                                      _deductOrderTotal("delivery");
                                    })
                                    : new Container(),
                                new Text(_deliveryCount.toString()),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() => _deliveryCount++);
                                      _updateOrderTotal("delivery");
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only( bottom: 10, left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: RaisedButton(
                              onPressed: () {
                                cloudFirestore.deleteOrder(order,
                                    widget.month.toString(), widget.dateTime);
                                cloudFirestore
                                    .addOrder(
                                    new Order(
                                        customerName: order.customerName,
                                        address: order.address,
                                        phoneNumber: order.phoneNumber,
                                        timeOfDay: order.timeOfDay,
                                        dateTime: order.dateTime,
                                        isPaid: order.isPaid,
                                        orderPrice: _orderTotal,
                                        paymentType: order.paymentType,
                                        orderComplete: false,
                                        orderDesc: constructOrderText(),
                                        indQuantity: constructOrdermap()["Ind"] +
                                            constructOrdermap()["nabulsi"],
                                        nabulsiQuantity:
                                        constructOrdermap()["nabulsi"],
                                        lrgQuantity: constructOrdermap()['Large'],
                                        smallQuantity: constructOrdermap()['Small'],
                                        baklava1kgQuantity:
                                        constructOrdermap()['1kg'],
                                        baklava500gQuantity:
                                        constructOrdermap()['500g']),
                                    widget.dateTime.month.toString(),
                                    widget.dateTime,
                                    constructOrdermap())
                                    .whenComplete(() => {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Main(
                                            date: widget.dateTime,
                                          ),
                                          inheritTheme: false,
                                          duration: Duration(milliseconds: 450),
                                          ctx: context))
                                });
                              },
                              color: Colors.orange,
                              child: Text(
                                "Update Order",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _updateValue(Order order, String field, String hintText, String heading,
      String month, String day, DateTime dateTime) async {
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
                  if (field.contains("orderDesc")) {
                    cloudFirestore.updateValue(
                        order.orderID,
                        widget.dateTime.day.toString(),
                        widget.dateTime.month.toString(),
                        order.orderDesc + "\n" + textEditingController.text,
                        field);
                  } else {
                    cloudFirestore.updateValue(
                        order.orderID,
                        widget.day.toString(),
                        widget.month.toString(),
                        textEditingController.text,
                        field);
                  }
                })
          ],
        ));
  }

  _updateTime(String id, String time) async {
    TimeOfDay timeOfDay = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());

    if (timeOfDay != null) {
      setState(() {
        print("New: " + timeOfDay.toString());
      });
      cloudFirestore.updateOrderTime(
          id,
          widget.day.toString(),
          widget.month.toString(),
          timeOfDay.hour.toString() + ":" + timeOfDay.minute.toString());
    }
  }
}

