import 'package:feed/utils/helper.dart';

class CommentModel {
  late int id;
  late int post_id;
  late String content;
  late String created_at;

  CommentModel(this.id, this.post_id, this.content, this.created_at);

  CommentModel.fromJson(Map<String, dynamic> item) {
    id = Helper.parseToInt(item["id"]);
    post_id = Helper.parseToInt(item["post_id"]);
    content = item["content"] ?? "";
    created_at = item["created_at"] ?? "";
  }
}
