import 'Comment.dart';

class Comments {
  final List<Comment> comments;

  Comments(this.comments);

  factory Comments.fromJson(Map<String, dynamic> json) {
    var list = json['comments'] as List;
    List<Comment> commentList = list.map((i) => Comment.fromJson(i)).toList();
    return Comments(commentList);
  }

  Map<String, dynamic> toJson() => {
        'comments': comments,
      };
}
