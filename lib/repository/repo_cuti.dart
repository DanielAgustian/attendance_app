import 'package:AttendanceApp/model/model-cuti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CutiRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('cuti');

  Future<bool> addCutiPermission(CutiModel cuti) async {
    bool dec = false;
    await collection.add(cuti.toJson(cuti)).then((res) {
      dec = true;
    });
    return dec;
  }

  Future<List<CutiModel>> getEmployeeApplication(String idUser) async {
    List<CutiModel> applications = [];
    var res = await collection.where("idUser", isEqualTo: idUser).get();
    if (res.docs.length != 0) {
      res.docs.forEach((value) {
        CutiModel temp = CutiModel.fromSnapshot(value);
        applications.add(temp);
      });
    }

    return applications;
  }

  Future<List<CutiModel>> getAllEmployeeApplication() async {
    List<CutiModel> applications = [];
    var res = await collection.get();
    if (res.docs.length != 0) {
      res.docs.forEach((value) {
        CutiModel temp = CutiModel.fromSnapshot(value);
        applications.add(temp);
      });
    }

    return applications;
  }

  bool hasFilteredContent(
      CutiModel data, String filterStart, String filterEnd) {
    var start = DateFormat('yyyy-MM-dd').parse(data.getMulai);
    var end = DateFormat('yyyy-MM-dd').parse(data.getSelesai);
    var fStart = DateFormat('yyyy-MM-dd').parse(filterStart);
    var fEnd = DateFormat('yyyy-MM-dd').parse(filterEnd);

    return fStart.isAfter(start) && fStart.isBefore(end) ||
        fEnd.isBefore(end) && fEnd.isAfter(start);
  }

  //  Stream for realtime all data flow
  Stream<List<CutiModel>> loadAllCuti({String query1, String query2}) {
    if (query1 == null || query2 == null || query1 == "" || query2 == "") {
      return collection.snapshots().map((value) {
        return value.docs.map((data) => CutiModel.fromSnapshot(data)).toList();
      });
    } else {
      return collection.snapshots().map((value) {
        return value.docs
            .map((data) => CutiModel.fromSnapshot(data))
            .where((x) => hasFilteredContent(x, query1, query2))
            .toList();
      });
    }
  }

  //  Stream for realtime all data user flow
  Stream<List<CutiModel>> loadAllUserCuti(
      {String query1, String query2, String id}) {
    if (query1 == null || query2 == null || query1 == "" || query2 == "") {
      return collection.where("idUser", isEqualTo: id).snapshots().map((value) {
        return value.docs.map((data) => CutiModel.fromSnapshot(data)).toList();
      });
    } else {
      return collection.where("idUser", isEqualTo: id).snapshots().map((value) {
        return value.docs
            .map((data) => CutiModel.fromSnapshot(data))
            .where((x) => hasFilteredContent(x, query1, query2))
            .toList();
      });
    }
  }

  Future<int> countCutiEmployee() async {
    DateFormat dateFormatHari = DateFormat("yyyy-MM-dd");
    String hari = dateFormatHari.format(DateTime.now());
    List<CutiModel> cutis = [];
    var snapshots = await collection.get();
    snapshots.docs.forEach((val) {
      cutis.add(CutiModel.fromSnapshot(val));
    });

    print(cutis.length);
    return cutis.where((x) => hasFilteredNowadays(x, hari)).toList().length;
  }

  bool hasFilteredNowadays(CutiModel data, String filterNow) {
    var start = DateFormat('yyyy-MM-dd').parse(data.getMulai);
    var end = DateFormat('yyyy-MM-dd').parse(data.getSelesai);
    var now = DateFormat('yyyy-MM-dd').parse(filterNow);

    return ((now.isAfter(start) && now.isBefore(end)) ||
            now.isAtSameMomentAs(start) ||
            now.isAtSameMomentAs(end)) &&
        data.getStatus == "diterima";
  }

  Future<bool> updateCuti(CutiModel cuti) async {
    bool success = false;
    await collection
        .doc(cuti.getID)
        .update(cuti.toJson(cuti))
        .then((value) => success = true)
        .catchError((onError) => success = false);

    return success;
  }
}
