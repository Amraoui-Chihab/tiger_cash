class Product {
  final String? name;
  final String? price;
  final String? image;
  final String? description;
  final String? type;
  final String? id;
  final String? quntity;
    final String? month;



  Product({
    this.name,
    this.price,
    this.image,
    this.description,
    this.type,
    this.id,
    this.quntity,
    this.month
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toString(),
      image: json['photo_url'].toString(),
      description: json['description'].toString(),
      type: json['type'].toString(),
      id: json['id'].toString(),
      quntity: json['quntity'].toString(),
      month: json['month'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'name': name,
      // 'price': price,
      // 'image': image,
    };
  }
}
