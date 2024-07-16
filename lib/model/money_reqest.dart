class MoneyReqest {
  String? id;
  String? userId;
  String? name;
  String? cost;
  String? note;
  String? state;
  String? cardNumber;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  MoneyReqest({
    this.id,
    this.userId,
    this.name,
    this.cost,
    this.note,
    this.state,
    this.cardNumber,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory MoneyReqest.fromJson(Map<String, dynamic> json) => MoneyReqest(
        id: json["id"].toString(),
        userId: json["user_id"].toString(),
        name: json["name"].toString(),
        cost: json["cost"].toString(),
        note: json["note"].toString(),
        state: json["state"].toString(),
        cardNumber: json["card_number"].toString(),
        type: json["type"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "cost": cost,
        "note": note,
        "state": state,
        "card_number": cardNumber,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
