import 'package:jiffy/jiffy.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:kanafeh_kings/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanafeh_kings/models/profit.dart';
import 'package:kanafeh_kings/models/weekly_income.dart';

class CloudFirestore {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('orders');

  Future<bool> addOrder(Order order, String month, DateTime dateTime) async {
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection(month)
        .doc(order.dateTime)
        .collection('orders')
        .doc()
        .set({
      "customerName": order.customerName,
      "address": order.address,
      "phoneNumber": order.phoneNumber,
      "timeOfDay": order.timeOfDay,
      "dateTime": order.dateTime,
      "orderPrice": order.orderPrice,
      "isPaid": order.isPaid,
      "orderComplete": order.orderComplete,
      "paymentType": order.paymentType,
      "orderDesc": order.orderDesc,
    });

    DocumentSnapshot documentSnapshot = await _collectionReference
        .doc("profit")
        .collection(month)
        .doc(order.dateTime)
        .get();

    if (!documentSnapshot.exists) {
      _collectionReference
          .doc("profit")
          .collection(month)
          .doc(order.dateTime)
          .set({"profit": order.orderPrice});
    } else {
      _collectionReference
          .doc("profit")
          .collection(month)
          .doc(order.dateTime)
          .update({"profit": FieldValue.increment(order.orderPrice)});
    }

    // Set weekly income
    documentSnapshot = await _collectionReference
        .doc("income")
        .collection('weeks')
        .doc(Jiffy([dateTime.year, dateTime.month, dateTime.day])
            .week
            .toString())
        .get();

    if (!documentSnapshot.exists) {
      print("Creating new income week");

      _collectionReference
          .doc("income")
          .collection('weeks')
          .doc(Jiffy([dateTime.year, dateTime.month, dateTime.day])
              .week
              .toString())
          .set({"income": order.orderPrice, "week" : Jiffy([dateTime.year, dateTime.month, dateTime.day]).week.toString()});
    } else {
      _collectionReference
          .doc("income")
          .collection('weeks')
          .doc(Jiffy([dateTime.year, dateTime.month, dateTime.day])
              .week
              .toString())
          .update({"income": FieldValue.increment(order.orderPrice)});
    }

    // Set monthly income
    documentSnapshot = await _collectionReference
        .doc("income")
        .collection('months')
        .doc(dateTime.month.toString())
        .get();

    if (!documentSnapshot.exists) {
      print("Creating new income month");

      _collectionReference
          .doc("income")
          .collection('months')
          .doc(dateTime.month.toString())
          .set({"income": order.orderPrice, "month" : dateTime.month});
    } else {
      _collectionReference
          .doc("income")
          .collection('months')
          .doc(dateTime.month.toString())
          .update({"income": FieldValue.increment(order.orderPrice)});
    }
  }

  Future<bool> deleteOrder(Order order, String month, DateTime dateTime) async {
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection(month)
        .doc(order.dateTime)
        .collection("orders")
        .doc(order.orderID)
        .delete();

    _collectionReference
        .doc("profit")
        .collection(month)
        .doc(order.dateTime)
        .update({"profit": FieldValue.increment(-order.orderPrice)});

    _collectionReference
        .doc("income")
        .collection('weeks')
        .doc(Jiffy([dateTime.year, dateTime.month, dateTime.day])
            .week
            .toString())
        .update({"income": FieldValue.increment(-order.orderPrice)});

    _collectionReference
        .doc("income")
        .collection('months')
        .doc(dateTime.month.toString())
        .update({"income": FieldValue.increment(-order.orderPrice)});
  }

  Stream<List<Order>> streamOrders(String day, String month) {
    var ref = _collectionReference
        .doc('N44vzFG33WQSYv6XR74W')
        .collection(month)
        .doc(day)
        .collection('orders');

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Order.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<Profit> streamProfit(String day, String month) {
    return _collectionReference
        .doc("profit")
        .collection(month)
        .doc(day)
        .snapshots()
        .map((snap) => Profit.fromMap(snap.data()));
  }

  Stream<WeeklyIncome> streamWeeklyIncome(String weekNumber) {
    return _collectionReference
        .doc("income")
        .collection("weeks")
        .doc(weekNumber)
        .snapshots()
        .map((snap) => WeeklyIncome.fromMap(snap.data()));
  }

  Stream<List<WeeklyIncome>> streamAllWeeks() {
    return _collectionReference
        .doc("income")
        .collection("weeks")
        .snapshots()
        .map((list) => list.docs
            .map((week) => WeeklyIncome.fromMap(week.data()))
            .toList());
  }

  Stream<MonthlyIncome> streamMonthlyIncome(String month) {
    return _collectionReference
        .doc("income")
        .collection("months")
        .doc(month)
        .snapshots()
        .map((snap) => MonthlyIncome.fromMap(snap.data()));
  }

  Stream<List<MonthlyIncome>> streamAllMonths() {
    return _collectionReference
        .doc("income")
        .collection("months")
        .snapshots()
        .map((list) => list.docs
            .map((week) => MonthlyIncome.fromMap(week.data()))
            .toList());
  }

  Future<void> setOrderDone(
      String id, String orderDay, bool value, String month) {
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection(month)
        .doc(orderDay)
        .collection("orders")
        .doc(id)
        .update({
      "orderComplete": value,
    });
  }

  Future<void> updateOrderTime(
      String id, String orderDay, String month, String time) {
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection(month)
        .doc(orderDay)
        .collection("orders")
        .doc(id)
        .update({
      "timeOfDay": time,
    });
  }

  Future<void> updateValue(
      String id, String orderDay, String month, String value, String field) {
    print(id);
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection(month)
        .doc(orderDay)
        .collection("orders")
        .doc(id)
        .update({
      field: value,
    });
  }
}
