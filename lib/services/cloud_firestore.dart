import 'package:jiffy/jiffy.dart';
import 'package:kanafeh_kings/models/monthly_income.dart';
import 'package:kanafeh_kings/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanafeh_kings/models/profit.dart';
import 'package:kanafeh_kings/models/quantity.dart';
import 'package:kanafeh_kings/models/weekly_income.dart';

class CloudFirestore {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('orders');

  Map<String, String> months = {
    "1": "January",
    "2": "February",
    "3": "March",
    "4": "April",
    "5": "May",
    "6": "June",
    "7": "July",
    "8": "August",
    "9": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  Future<bool> addOrder(Order order, String month, DateTime dateTime,
      Map<String, int> descMap) async {
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
      "lrgQuantity": order.lrgQuantity,
      "indQuantity": order.indQuantity,
      "smallQuantity": order.smallQuantity,
      "nabulsiQuantity": order.nabulsiQuantity,
      "baklava500gQuantity": order.baklava500gQuantity,
      "baklava1kgQuantity": order.baklava1kgQuantity
    });

    _updateQuantity(month, order, descMap);
    _updateProfit(month, order);
    _updateIncome(month, order, dateTime);
  }

  void _updateQuantity(
      String month, Order order, Map<String, int> descMap) async {
    DocumentSnapshot quantitySnapshot = await _collectionReference
        .doc("quantity")
        .collection(month)
        .doc(order.dateTime)
        .get();

    if (!quantitySnapshot.exists) {
      _collectionReference
          .doc("quantity")
          .collection(month)
          .doc(order.dateTime)
          .set({
        "Large": FieldValue.increment(descMap["Large"]),
        "Small": FieldValue.increment(descMap["Small"]),
        "Ind": FieldValue.increment((descMap["Ind"] + descMap["nabulsi"])),
        "500g": FieldValue.increment(descMap["500g"]),
        "1kg": FieldValue.increment(descMap["1kg"]),
        "cheesePortion": FieldValue.increment(
            (1 * (descMap["Ind"] + descMap["nabulsi"])) +
                (descMap["Small"] * 6) +
                (9 * descMap["Large"])),
        "dough": FieldValue.increment((60 * descMap["Ind"]) +
            (descMap["Small"] * 280) +
            (380 * descMap["Large"])),
        "nabulsiDough": FieldValue.increment((100 * descMap['nabulsi']))
      });
    } else {
      _collectionReference
          .doc("quantity")
          .collection(month)
          .doc(order.dateTime)
          .update({
        "Large": FieldValue.increment(descMap["Large"]),
        "Small": FieldValue.increment(descMap["Small"]),
        "Ind": FieldValue.increment((descMap["Ind"] + descMap["nabulsi"])),
        "500g": FieldValue.increment(descMap["500g"]),
        "1kg": FieldValue.increment(descMap["1kg"]),
        "cheesePortion": FieldValue.increment(
            (1 * (descMap["Ind"] + descMap["nabulsi"])) +
                (descMap["Small"] * 6) +
                (9 * descMap["Large"])),
        "dough": FieldValue.increment((60 * descMap["Ind"]) +
            (descMap["Small"] * 280) +
            (380 * descMap["Large"])),
        "nabulsiDough": FieldValue.increment((100 * descMap['nabulsi']))
      });
    }
  }

  void _updateProfit(String month, Order order) async {
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
  }

  void _updateIncome(
    String month,
    Order order,
    DateTime dateTime,
  ) async {
    // Set weekly income
    DocumentSnapshot documentSnapshot = await _collectionReference
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
          .set({
        "income": order.orderPrice,
        "week": Jiffy([dateTime.year, dateTime.month, dateTime.day])
                .week
                .toString() +
            ": " +
            dateTime.day.toString() +
            "/" +
            dateTime.month.toString(),
        dateTime.weekday.toString(): order.orderPrice
      });
    } else {
      if(dateTime.weekday.toString().contains("7")){
        int week = Jiffy([dateTime.year, dateTime.month, dateTime.day])
            .week - 1;
        _collectionReference
            .doc("income")
            .collection('weeks')
            .doc(week.toString())
            .update({
          "income": FieldValue.increment(order.orderPrice),
          dateTime.weekday.toString(): FieldValue.increment(order.orderPrice)
        });
      }else {
        _collectionReference
            .doc("income")
            .collection('weeks')
            .doc(Jiffy([dateTime.year, dateTime.month, dateTime.day])
            .week
            .toString())
            .update({
          "income": FieldValue.increment(order.orderPrice),
          dateTime.weekday.toString(): FieldValue.increment(order.orderPrice)
        });
      }

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
          .set({
        "income": order.orderPrice,
        "month": months[dateTime.month.toString()]
      });
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

    if(dateTime.weekday.toString().contains("7")){
      int week = Jiffy([dateTime.year, dateTime.month, dateTime.day])
          .week - 1;
      _collectionReference
          .doc("income")
          .collection('weeks')
          .doc(week.toString())
          .update({
        "income": FieldValue.increment(-order.orderPrice),
        dateTime.weekday.toString(): FieldValue.increment(-order.orderPrice)
      });
    }else {
      _collectionReference
          .doc("income")
          .collection('weeks')
          .doc(Jiffy([dateTime.year, dateTime.month, dateTime.day])
          .week
          .toString())
          .update({
        "income": FieldValue.increment(-order.orderPrice),
        dateTime.weekday.toString(): FieldValue.increment(-order.orderPrice)
      });
    }


    _collectionReference
        .doc("income")
        .collection('months')
        .doc(dateTime.month.toString())
        .update({
      "income": FieldValue.increment(-order.orderPrice),
    });

    _collectionReference
        .doc("quantity")
        .collection(month)
        .doc(order.dateTime)
        .update({
      "Large": FieldValue.increment(-order.lrgQuantity),
      "Small": FieldValue.increment(-order.smallQuantity),
      "Ind": FieldValue.increment(-order.indQuantity),
      "500g": FieldValue.increment(-order.baklava500gQuantity),
      "1kg": FieldValue.increment(-order.baklava1kgQuantity),
      "cheesePortion": FieldValue.increment(-((1 * order.indQuantity) +
          (order.smallQuantity * 6) +
          (9 * order.lrgQuantity))),
      "dough": FieldValue.increment(
          -((60 * (order.indQuantity - order.nabulsiQuantity)) +
              (order.smallQuantity * 280) +
              (380 * order.lrgQuantity))),
      "nabulsidough": FieldValue.increment(-(100 * order.nabulsiQuantity))
    });
  }

  Stream<List<Order>> streamOrders(String day, String month) {
    var ref = _collectionReference
        .doc('N44vzFG33WQSYv6XR74W')
        .collection(month)
        .doc(day)
        .collection('orders')
        .orderBy("timeOfDay");

    return ref.snapshots().map((list) =>
        list.docs.map((doc) => Order.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<Order> streamOrder(String day, String month, String orderId) {
    var ref = _collectionReference
        .doc('N44vzFG33WQSYv6XR74W')
        .collection(month)
        .doc(day)
        .collection('orders')
        .doc(orderId);

    return ref
        .snapshots()
        .map((order) => Order.fromMap(order.data(), order.id));
  }

  Stream<Profit> streamProfit(String day, String month) {
    return _collectionReference
        .doc("profit")
        .collection(month)
        .doc(day)
        .snapshots()
        .map((snap) => Profit.fromMap(snap.data()));
  }

  Stream<WeeklyIncome> streamWeeklyIncome() {
    DateTime _dateTime = DateTime.now();
    return _collectionReference
        .doc("income")
        .collection("weeks")
        .doc(Jiffy([_dateTime.year, _dateTime.month, _dateTime.day])
            .week
            .toString())
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

  Stream<MonthlyIncome> streamMonthlyIncome() {
    DateTime _dateTime = DateTime.now();
    return _collectionReference
        .doc("income")
        .collection("months")
        .doc(_dateTime.month.toString())
        .snapshots()
        .map((snap) => MonthlyIncome.fromMap(snap.data()));
  }

  Stream<Quantity> streamDayQuantity(String month, String day) {
    return _collectionReference
        .doc("quantity")
        .collection(month)
        .doc(day)
        .snapshots()
        .map((snap) => Quantity.fromMap(snap.data()));
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

  Future<void> toggleIsPaid(
      String id, String orderDay, String month, bool isPaid) {
    print(id);
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection(month)
        .doc(orderDay)
        .collection("orders")
        .doc(id)
        .update({
      "isPaid": !isPaid,
    });
  }

  Future<void> togglePaymentMethod(
      String id, String orderDay, String month, String paymentMethod) {
    if (paymentMethod.contains("Cash")) {
      _collectionReference
          .doc("N44vzFG33WQSYv6XR74W")
          .collection(month)
          .doc(orderDay)
          .collection("orders")
          .doc(id)
          .update({
        "paymentType": "Card",
      });
    } else if (paymentMethod.contains("Card")) {
      _collectionReference
          .doc("N44vzFG33WQSYv6XR74W")
          .collection(month)
          .doc(orderDay)
          .collection("orders")
          .doc(id)
          .update({
        "paymentType": "Cash",
      });
    }
  }
}
