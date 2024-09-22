class Reel {
  int id;
  String name;
  String url;
  int likes;
  int comment;
  String userId;
  bool isLiked;

  
  Reel({
    required this.id,
    required this.name,
    required this.url,
    required this.likes,
    required this.comment,
    required this.userId,
    required this.isLiked,
  });
  
  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      name: json['title'].toString(),
      id: json['id'],
      url: json["url"].toString(),
      likes: json["likes"],
      userId: json["user_id"].toString(),
      comment: json["comment"],
      isLiked: json["isLiked"],
    );
  }
}
