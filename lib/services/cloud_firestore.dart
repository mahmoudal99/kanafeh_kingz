import 'package:kanafeh_kings/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanafeh_kings/models/profit.dart';

class CloudFirestore {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('orders');


  Future<bool> addOrder(Order order, String month) async {
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
    _collectionReference.doc("N44vzFG33WQSYv6XR74W").collection(month).doc(order.dateTime).collection("orders").doc(order.orderID).delete();

    _collectionReference
        .doc("profit")
        .collection(month)
        .doc(order.dateTime)
        .update({"profit": FieldValue.increment(-order.orderPrice)});

  }

  Stream<List<Order>> streamOrders(String day, String month) {

    var ref = _collectionReference
        .doc('N44vzFG33WQSYv6XR74W')
        .collection(month)
        .doc(day)
        .collection('orders');

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Order.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<Profit> streamProfit(String day, String month) {
    return _collectionReference
        .doc("profit")
        .collection(month)
        .doc(day)
        .snapshots()
        .map((snap) => Profit.fromMap(snap.data()));
  }

  Future<void> setOrderDone(String id, String orderDay, bool value, String month) {
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

  Future<void> updateOrderTime(String id, String orderDay, String month, String time) {
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

  Future<void> updateValue(String id, String orderDay, String month, String value, String field) {
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
