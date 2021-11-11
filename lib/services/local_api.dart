import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/resources/api_constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalService {
  addInfo(Map<String, String> data, String boxName) async {
    var box = Hive.box(boxName);
    box.putAll(data);
  }

  _getInfo() {
    // Get info from people box
  }

  _updateInfo() {
    // Update info of people box
  }

  _deleteInfo() {
    // Delete info from people box
  }
}
