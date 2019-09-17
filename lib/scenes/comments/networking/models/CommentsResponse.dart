import 'package:hive/hive.dart';
part 'CommentsResponse.g.dart';

class CommentsResponse {
  final List<Comment> comments;
  final String page;
  final String pageCount;

  CommentsResponse(this.comments, this.page, this.pageCount);

  factory CommentsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['comments'] as List;
    List<Comment> commentList = list.map((i) => Comment.fromJson(i)).toList();
    var page = json['page'].toString();
    var pageCount = json['pageCount'].toString();
    return CommentsResponse(commentList, page, pageCount);
  }

  Map<String, dynamic> toJson() => {
        'comments': comments,
      };
}

@HiveType()
class Comment {
  @HiveField(0)
  String id;
  @HiveField(1)
  String comment;
  @HiveField(2)
  String likeCount;
  @HiveField(3)
  String date;
  @HiveField(4)
  String ownerUsername;
  @HiveField(5)
  String ownerProfileUrl;
  @HiveField(6)
  String commentUrl;

  Comment(this.id, this.comment, this.likeCount, this.date, this.ownerUsername,
      this.ownerProfileUrl, this.commentUrl);

  Comment.empty();

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        comment = json['comment'],
        date = json['date'],
        likeCount = json['likeCount'],
        ownerUsername = json["ownerUsername"],
        ownerProfileUrl = json["ownerProfileUrl"],
        commentUrl = json["commentUrl"];

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'date': date,
        'ownerUsername': ownerUsername,
        'ownerProfileUrl': ownerProfileUrl,
        'commentUrl': ownerUsername,
      };
}
