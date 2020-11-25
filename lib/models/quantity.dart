class Quantity {

  String baklava1kg;
  String baklava500g;
  String Small;
  String Ind;
  String Large;

  Quantity(
      {this.baklava1kg, this.baklava500g, this.Ind, this.Large, this.Small});

  factory Quantity.fromMap(Map data) {
    print(data.toString());
    return Quantity(
      baklava1kg: data['1kg'].toString(),
      baklava500g: data['500g'].toString(),
      Small: data['Small'].toString(),
      Ind: data['Ind'].toString() ,
      Large: data['Large'].toString(),
    );
  }
}
