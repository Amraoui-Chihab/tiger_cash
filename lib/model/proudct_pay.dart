class ProudctPay {
  int? id;
  int? productId;
  String? name;
  String? phoneNumber;
  String? location;

  ProudctPay({
    this.id,
    this.productId,
    this.name,
    this.phoneNumber,
    this.location,
  });

  factory ProudctPay.fromJson(Map<String, dynamic> json) => ProudctPay(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        phoneNumber: json["phone_number"].toString(),
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "phone_number": phoneNumber,
        "location": location,
      };
}
