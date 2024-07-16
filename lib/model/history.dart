import 'package:tigercashiraq/model/gift.dart';

class History {
  final String? id;
  final String? ownerId;
  final String? userId;
  final String? note;
  final String? amount;
  final Gift? gift;
  final String? createdAt;

  History(
      {this.id,
      this.ownerId,
      this.userId,
      this.note,
      this.amount,
      this.gift,
      this.createdAt});

  factory History.fromDocumentSnapshot(Map<String, dynamic> doc) {
    return History(
      id: doc["id"].toString(),
      ownerId: doc["owner_id"].toString(),
      userId: doc["user_id"].toString(),
      note: doc["note"].toString(),
      amount: doc["amount"].toString(),
      gift: doc["gift"] == null ? null : Gift.fromJson(doc["gift"]),
      createdAt: doc["created_at"].toString(),
    );
  }
}
