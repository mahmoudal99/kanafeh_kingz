class Quantity {

  String baklava1kg;
  String baklava500g;
  String Small;
  String Ind;
  String Large;
  String cheesePortion;
  String dough;
  String nabulsiDough;

  Quantity(
      {this.baklava1kg, this.baklava500g, this.Ind, this.Large, this.Small, this.cheesePortion, this.dough, this.nabulsiDough});

  factory Quantity.fromMap(Map data) {
    return Quantity(
      baklava1kg: data['1kg'].toString(),
      baklava500g: data['500g'].toString(),
      Small: data['Small'].toString(),
      Ind: data['Ind'].toString() ,
      Large: data['Large'].toString(),
      cheesePortion: data['cheesePortion'].toString(),
      dough: data['dough'].toString(),
      nabulsiDough: data['nabulsiDough'].toString()
    );
  }
}
