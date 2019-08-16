class SearchQueryResponse {
  final List<String> titles;

  SearchQueryResponse(this.titles);

  factory SearchQueryResponse.fromJson(Map<String, dynamic> json) {
    var list = json['titles'] as List;
    List<String> searchResults = list.map((i) => i.toString()).toList();
    return SearchQueryResponse(searchResults);
  }

  Map<String, dynamic> toJson() => {'titles': this.titles};
}
