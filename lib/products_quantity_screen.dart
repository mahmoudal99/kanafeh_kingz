import 'package:flutter/material.dart';
import 'package:kanafeh_kings/models/quantity.dart';
import 'package:provider/provider.dart';

class QuantityScreen extends StatefulWidget {
  @override
  _QuantityScreenState createState() => _QuantityScreenState();
}

class _QuantityScreenState extends State<QuantityScreen> {
  @override
  Widget build(BuildContext context) {
    Quantity quantity = Provider.of<Quantity>(context);
    if(quantity != null) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _box(quantity.baklava500g, "500g boxes"),
                _box(quantity.baklava1kg, "1kg Boxes"),
                _box(quantity.Small, "Small boxes"),
                _box(quantity.Large, "Large Boxes"),
                _box(quantity.Ind, "Individual boxes"),
                _box(quantity.cheesePortion, "Cheese Portions"),
                _box(quantity.dough + "g", "Dough"),
                _box(quantity.nabulsiDough + "g", "Nabulsi Dough"),
              ],
            ),
          ),
        ),
      );
    }else {
      return Container();
    }

  }


  Widget _box(String quantity, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 10,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      quantity,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
