import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/api_constants.dart';

class UchetService {
  static final firebase = FirebaseFirestore.instance;

  static Stream<List<Uchet>> fetchAllUchets() {
    return firebase
        .collection('uchet')
        .where('livers', isNotEqualTo: [])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Uchet.fromMap(doc.data())).toList());
  }

  static Stream<List<Uchet>> searchUchets({required String value}) {
    return firebase
        .collection(ApiConstants.uchet)
        .where('id', isEqualTo: value)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Uchet.fromMap(doc.data())).toList());
  }

  Future<void> addLiverToList(Map<String, dynamic> book, id) async {
    await firebase
        .collection(ApiConstants.uchet)
        .doc(id)
        .set(book)
        .then((value) {
    }).catchError((e) {
      print(e.toString());
    });
  }
}
