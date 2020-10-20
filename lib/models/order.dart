import 'package:flutter/material.dart';

class Order {
  String orderID;
  String customerName;
  String phoneNumber;
  String address;
  String timeOfDay;
  String dateTime;
  int orderPrice;
  bool isPaid;
  bool orderComplete = false;
  String paymentType;
  String orderDesc;

  Order(
      {this.orderID,
      this.address,
      this.customerName,
      this.phoneNumber,
      this.timeOfDay,
      this.dateTime,
      this.orderPrice,
      this.isPaid,
      this.orderComplete,
      this.paymentType,
      this.orderDesc});

  factory Order.fromMap(Map data, String id) {
    data = data ?? {};
    return Order(
      orderID: id,
      customerName: data['customerName'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      timeOfDay: data['timeOfDay'],
      dateTime: data['dateTime'],
      orderPrice: data['orderPrice'],
      isPaid: data['isPaid'],
      orderComplete: data['orderComplete'],
      paymentType: data['paymentType'],
      orderDesc: data['orderDesc'],
    );
  }
}
