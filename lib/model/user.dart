class User {
  String? id;
  String? name;
  String? deviceId;
  String? accountId;
  String? apiToken;
  String? photoUrl;
  String? codeInvite;
  // int? isLimited;
  // int? isSeller;
  String? counterAmount;
  DateTime? lastActive;
  DateTime? lastTransction;
  String? balance;
  int? islimited;
  // DateTime? createdAt;
  // DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.deviceId,
    this.accountId,
    this.apiToken,
    this.photoUrl,
    this.codeInvite,
    this.counterAmount,
    this.lastActive,
    this.lastTransction,
    this.balance,
    this.islimited,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString(),
        name: json["name"].toString(),
        deviceId: json["device_id"].toString(),
        accountId: json["account_id"].toString(),
        apiToken: json["api_token"].toString(),
        photoUrl: json["photo_url"].toString(),
        codeInvite: json["code_invite"].toString(),
        islimited: json["is_limited"],
        // isLimited: json["is_limited"],
        // isSeller: json["is_seller"],
        counterAmount: json["counter_amount"].toString(),
        lastActive: json["last_active"] == null
            ? null
            : DateTime.parse(json["last_active"].toString()),
        lastTransction: json["last_transction"] == null
            ? null
            : DateTime.parse(json["last_transction"].toString()),
        balance: json["balance"].toString(),
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "device_id": deviceId,
        "account_id": accountId,
        "api_token": apiToken,
        "photo_url": photoUrl,
        "code_invite": codeInvite,
        // "is_limited": isLimited,
        // "is_seller": isSeller,
        "counter_amount": counterAmount,
        "last_active": lastActive?.toIso8601String(),
        "last_transction": lastTransction?.toIso8601String(),
        "balance": balance,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt?.toIso8601String(),
      };
}
