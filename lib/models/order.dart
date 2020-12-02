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
  int indQuantity = 0;
  int nabulsiQuantity = 0;
  int lrgQuantity = 0;
  int smallQuantity = 0;
  int baklava500gQuantity = 0;
  int baklava1kgQuantity = 0;

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
      this.orderDesc,
      this.indQuantity,
      this.nabulsiQuantity,
      this.lrgQuantity,
      this.smallQuantity,
      this.baklava500gQuantity,
      this.baklava1kgQuantity});

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
      indQuantity: data['indQuantity'],
      nabulsiQuantity: data['nabulsiQuantity'],
      lrgQuantity: data['lrgQuantity'],
      smallQuantity: data['smallQuantity'],
      baklava500gQuantity: data['baklava500gQuantity'],
      baklava1kgQuantity: data['baklava1kgQuantity'],
    );
  }
}
