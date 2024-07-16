import 'package:tigercashiraq/model/user.dart';

class Comment {
  int? id;
  String? reelId;
  User user;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    this.id,
    this.reelId,
    required this.user,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        reelId: json["reel_id"].toString(),
        user: User.fromJson(json["user"]),
        content: json["content"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reel_id": reelId,
        "user_id": user,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
