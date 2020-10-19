import 'package:kanafeh_kings/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanafeh_kings/models/profit.dart';

class CloudFirestore {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('orders');

  Future<bool> addOrder(Order order, String month) async {
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection("orders")
        .doc(order.dateTime)
        .collection('orders')
        .doc(order.customerName)
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

    DocumentSnapshot documentSnapshot = await _collectionReference.doc("profit").collection(month).doc(order.dateTime).get();

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

  Future<bool> deleteOrder(Order order, String month) async {
    _collectionReference.doc("N44vzFG33WQSYv6XR74W").collection("orders").doc(order.dateTime).collection("orders").doc(order.customerName).delete();

    DocumentSnapshot documentSnapshot = await _collectionReference.doc("profit").collection(month).doc(order.dateTime).get();
    _collectionReference
        .doc("profit")
        .collection(month)
        .doc(order.dateTime)
        .update({"profit": FieldValue.increment(-order.orderPrice)});

  }

  Stream<List<Order>> streamOrders(String day) {
    var ref = _collectionReference
        .doc('N44vzFG33WQSYv6XR74W')
        .collection('orders')
        .doc(day)
        .collection('orders');

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Order.fromMap(doc.data())).toList());
  }

  Stream<Profit> streamProfit(String day, String month) {
    return _collectionReference
        .doc("profit")
        .collection(month)
        .doc(day)
        .snapshots()
        .map((snap) => Profit.fromMap(snap.data()));
  }

  Future<void> setOrderDone(String name, String orderDay, bool value) {
    _collectionReference
        .doc("N44vzFG33WQSYv6XR74W")
        .collection("orders")
        .doc(orderDay)
        .collection("orders")
        .doc(name)
        .update({
      "orderComplete": value,
    });
  }
}
