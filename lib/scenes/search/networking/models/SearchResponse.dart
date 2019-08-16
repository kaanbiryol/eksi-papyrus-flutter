class SearchResponse {
  final List<String> titles;

  SearchResponse(this.titles);

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    var list = json['titles'] as List;
    List<String> searchResults = list.map((i) => i.toString()).toList();
    return SearchResponse(searchResults);
  }

  Map<String, dynamic> toJson() => {'titles': this.titles};
}
