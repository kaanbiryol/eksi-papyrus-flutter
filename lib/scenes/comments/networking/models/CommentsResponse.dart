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
  final String comment;
  final String date;
  final String ownerUsername;
  final String ownerProfileUrl;
  final String commentUrl;

  Comment(this.comment, this.date, this.ownerUsername, this.ownerProfileUrl,
      this.commentUrl);

  Comment.fromJson(Map<String, dynamic> json)
      : comment = json['comment'],
        date = json['date'],
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
