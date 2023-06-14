import 'package:feed/utils/helper.dart';

class PostModel {
  late int id;
  late String title;
  late String description;
  late String url;
  late String image;
  late String author;
  late int favorite;
  late int comment;
  late String created_at;

  PostModel(
    this.id,
    this.title,
    this.description,
    this.url,
    this.image,
    this.author,
    this.favorite,
    this.comment,
    this.created_at,
  );

  PostModel.fromJson(Map<String, dynamic> item) {
    id = Helper.parseToInt(item["id"]);
    title = item["title"] ?? "";
    description = item["description"] ?? "";
    url = item["url"] ?? "";
    image = item["image"] ?? "";
    author = item["author"] ?? "";
    favorite = Helper.parseToInt(item["favorite"]);
    comment = Helper.parseToInt(item["comment"]);
    created_at = item["created_at"] ?? "";
  }
}
