class Liver {
  String? id;
  String? uchetId;
  int? ls;
  String? fullName;
  String? counter;
  String? firstIndication;
  String? lastIndication;
  List<dynamic>? searchKeyword;
  Map<String, dynamic>? pokazanie;
  String? created;
  String? updated;

  Liver({
    this.id,
    this.uchetId,
    this.ls,
    this.fullName,
    this.counter,
    this.pokazanie,
    this.firstIndication,
    this.lastIndication,
    this.searchKeyword,
    this.created,
    this.updated,
  });

  Liver.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        uchetId = data['uchetId'],
        ls = data['ls'],
        counter = data['counter'],
        fullName = data['fullName'],
        firstIndication = data['firstIndication'],
        lastIndication = data['lastIndication'],
        searchKeyword = data['searchKeyword'],
        created = data['created'],
        pokazanie = data['pokazanie'],
        updated = data['updated'];
}
