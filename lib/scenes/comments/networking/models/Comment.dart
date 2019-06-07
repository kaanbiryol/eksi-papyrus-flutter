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
