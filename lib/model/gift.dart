class Gift {
  int? id;
  String? name;
  String? photoUrl;
  int? cost;

  Gift({
    this.id,
    this.name,
    this.photoUrl,
    this.cost,
  });

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json['id'],
        name: json['name'].toString(),
        photoUrl: json['photo_url'].toString(),
        cost: json['cost'],
      );
}
