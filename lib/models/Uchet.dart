class Uchet {
  String? id;
  List<dynamic>? livers;
  List<dynamic>? searchKeyword;
  String? created;
  String? updated;

  Uchet({
    this.id,
    this.livers,
    this.searchKeyword,
    this.created,
    this.updated,
  });

  Uchet.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        livers = data['livers'],
        searchKeyword = data['searchKeyword'],
        created = data['created'],
        updated = data['updated'];
}
