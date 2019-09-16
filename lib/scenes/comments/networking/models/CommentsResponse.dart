import 'package:hive/hive.dart';

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

class Comment {
  String id;
  String comment;
  String likeCount;
  String date;
  String ownerUsername;
  String ownerProfileUrl;
  String commentUrl;

  Comment(this.id, this.comment, this.likeCount, this.date, this.ownerUsername,
      this.ownerProfileUrl, this.commentUrl);

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

class CommentHiveAdapter extends TypeAdapter<Comment> {
  @override
  Comment read(BinaryReader reader) {
    var commentObject = Comment();
    var numberOfFields = reader.readByte();
    for (var i = 0; i < numberOfFields; i++) {
      var value = reader.read();
      switch (reader.readByte()) {
        case 0:
          commentObject.id = value as String;
          break;
        case 1:
          commentObject.comment = value as String;
          break;
        case 2:
          commentObject.likeCount = value as String;
          break;
        case 3:
          commentObject.date = value as String;
          break;
        case 4:
          commentObject.ownerUsername = value as String;
          break;
        case 5:
          commentObject.ownerProfileUrl = value as String;
          break;
        case 6:
          commentObject.commentUrl = value as String;
          break;
      }
    }
    return commentObject;
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer.write(obj.id);
    writer.write(obj.comment);
    writer.write(obj.likeCount);
    writer.write(obj.date);
    writer.write(obj.ownerUsername);
    writer.write(obj.ownerProfileUrl);
    writer.write(obj.commentUrl);
  }
}
