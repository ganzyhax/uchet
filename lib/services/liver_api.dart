import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/models/LiverOffline.dart';
import 'package:uchet/resources/api_constants.dart';

class LiverService {
  static final firebase = FirebaseFirestore.instance;

  static Stream<List<Liver>> fetchAllLivers(String uchetId) {
    return firebase
        .collection('livers')
        .where('uchetId', isEqualTo: uchetId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Liver.fromMap(doc.data())).toList());
  }

  static Stream<List<Liver>> searchLivers(String uchetId,
      {required String value}) {
    return firebase
        .collection('livers')
        .where('searchKeyword', arrayContains: value)
        .where('uchetId', isEqualTo: uchetId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Liver.fromMap(doc.data())).toList());
  }

  Stream<List<Liver>> fetchSingleLiver(String id) {
    return firebase
        .collection(ApiConstants.livers)
        .where("id", isEqualTo: id)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Liver.fromMap(doc.data()),
              )
              .toList(),
        );
  }

  Future<void> addLiver(Map<String, dynamic> book, id) async {
    await firebase
        .collection(ApiConstants.livers)
        .doc(id)
        .set(book)
        .then((value) {})
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteLiver(String bookId) {
    return firebase.collection(ApiConstants.livers).doc(bookId).delete();
  }

  Future<void> updateLiver(Map<String, dynamic> book, String id) async {
    await firebase
        .collection(ApiConstants.livers)
        .doc(id)
        .set(book)
        .then((value) {})
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateLiverOffline(
      Map<String, dynamic> book, String id, Person liverId) async {
    firebase
        .collection(ApiConstants.livers)
        .doc(id)
        .update(book)
        .then((value) {})
        .catchError((e) {
      print(e.toString());
    });

    print('DD');
    updateHiveLiverOffline(liverId);
  }

  Future<void> updateHiveLiverOffline(Person liverId) async {
    List<Person> liverList = [];
    Box<Person> allLiverBox = await Hive.openBox<Person>('OfflineLiver');
    //allLiverBox.clear();
    for (int i = 0; i < allLiverBox.length; i++) {
      liverList.add(allLiverBox.getAt(i) ?? Person());
    }
    for (Person items in liverList) {
      print(items.fullName);
    }
    if (liverList.contains(liverId)) {
      print('contains');
    }

    ///to do remove
    print(allLiverBox.length);
    // allLiverBox.add(liverId);

    ///to do remove
  }

  Stream giveFullUser(String uchetId) {
    return firebase
        .collection(ApiConstants.livers)
        .where("uchetId", isEqualTo: uchetId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => doc['uchetId'],
              )
              .toList(),
        );
  }
}
