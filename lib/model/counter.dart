class Counter {
  final int id;
  final String name;
  final String price;
  final String points;

  Counter(
      {required this.name,
      required this.points,
      required this.price,
      required this.id});

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      id: json["id"],
      name: json['name'].toString(),
      points: json['points'].toString(),
      price: json['price'].toString(),
    );
  }
}
