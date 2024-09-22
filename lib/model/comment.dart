import 'package:tigercashiraq/model/user.dart';

class Comment {
  int? id;
  String? reelId;
  
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? idu;
  String? name;
  String? photoUrl;
  Comment({
    this.id,
    this.reelId,
    this.idu,
    this.photoUrl,
    this.name,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        reelId: json["reel_id"].toString(),
        photoUrl: (json["photo_url"]).toString(),
        name: (json["name_user"]).toString(),
        idu: (json["idu"]),
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
        "photoUrl": photoUrl,
        "name":name,
        "idu":idu,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
