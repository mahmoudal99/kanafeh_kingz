import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanafeh_kings/main.dart';
import 'package:kanafeh_kings/models/order.dart';
import 'package:kanafeh_kings/services/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

class CreateOrderScreen extends StatefulWidget {

  DateTime dateTime;

  CreateOrderScreen({this.dateTime});

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  CloudFirestore cloudFirestore = new CloudFirestore();

  DateTime pickedDate;
  TimeOfDay time;
  var _isPaidIndex = 1;
  bool isPaid = true;
  var _paymentIndex = 1;
  int _largeCount = 0;
  int _smallCount = 0;
  int _individualCount = 0;
  int _deliveryCount = 0;
  int _orderTotal = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  void _updateOrderTotal(String orderType) {
    if (orderType.contains('large')) {
      setState(() {
        _orderTotal += 35;
      });
    } else if (orderType.contains('small')) {
      setState(() {
        _orderTotal += 25;
      });
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
    } else {
      _orderTotal -= 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: null,
          backgroundColor: Colors.green,
          label: Text(
            'Total: ' + _orderTotal.toString(),
            style: TextStyle(color: Colors.white),
          )),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Customer Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (val) => val.isEmpty ? "Enter a name" : null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.group,
                              size: 20,
                              color: Colors.orange,
                            ),
                            border: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: 'Name',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Address",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _addressController,
                        validator: (val) =>
                            val.isEmpty ? "Enter an address" : null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.place,
                              size: 20,
                              color: Colors.orange,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: 'Street Address',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Phone",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        validator: (val) =>
                        val.isEmpty ? "+353" : null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.phone,
                              size: 20,
                              color: Colors.orange,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: '+353',
                            hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
                                          setState(() => _individualCount--);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            child: Text('Order Time'),
                            color: Colors.white,
                            elevation: 10,
                            onPressed: () {
                              _pickTime();
                            },
                          ),
                          RaisedButton(
                            child: Text('Order Day'),
                            color: Colors.white,
                            elevation: 10,
                            onPressed: () {
                              _pickDate();
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Payment Type",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.bold),
                              ),
                              DropdownButton(
                                value: _paymentIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _paymentIndex = value;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Card'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Cash'),
                                    value: 2,
                                  )
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Did Customer Pay?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.bold),
                              ),
                              DropdownButton(
                                value: _isPaidIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _isPaidIndex = value;
                                    value == 1 ? isPaid = true : isPaid = false;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Yes'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('No'),
                                    value: 2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 50, top: 20),
                          child: Container(
                            height: 40,
                            width: 120,
                            child: RaisedButton(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Text("Add Order"),
                              textColor: Colors.white,
                              color: Colors.orange,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  dynamic result = await cloudFirestore
                                      .addOrder(new Order(
                                        customerName:
                                            _nameController.text.toString(),
                                        address:
                                            _addressController.text.toString(),
                                        phoneNumber: _phoneController.text.toString(),
                                        timeOfDay: time.hour.toString() +
                                            ":" +
                                            time.minute.toString(),
                                        dateTime: widget.dateTime.day.toString(),
                                        isPaid: isPaid,
                                        orderPrice: _orderTotal,
                                        paymentType: _paymentIndex == 1
                                            ? "Card"
                                            : "Cash",
                                        orderComplete:  false,
                                        orderDesc: "Large Kanafehs: " +
                                            _largeCount.toString() +
                                            "\nSmall Kanafehs: " +
                                            _smallCount.toString() +
                                            "\nIndividual Kanafehs: " +
                                            _individualCount.toString(),
                                      ), widget.dateTime.month.toString())
                                      .whenComplete(() => {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: MyApp(dateTime: widget.dateTime,),
                                                    inheritTheme: false,
                                                    duration: Duration(
                                                        milliseconds: 450),
                                                    ctx: context))
                                          });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: widget.dateTime,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (dateTime != null) {
      setState(() {
        widget.dateTime = dateTime;
      });
    }
  }

  _pickTime() async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      setState(() {
        time = timeOfDay;
      });
    }
  }
}
