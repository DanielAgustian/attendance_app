import 'package:AttendanceApp/model/model-time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AbsensiRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('time');

  Future<List<TimeModel>> getEmployeeAbsence(String idUser) async {
    List<TimeModel> absences = [];
    var res = await collection.where("idUser", isEqualTo: idUser).get();
    if (res.docs.length == 0) {
    } else {
      res.docs.forEach((value) {
        TimeModel temp = TimeModel.fromSnapshot(value);
        absences.add(temp);
      });
    }

    return absences;
  }

  Future<List<TimeModel>> getAllEmployeeAbsence() async {
    List<TimeModel> absences = [];
    var res = await collection.get();
    if (res.docs.length == 0) {
    } else {
      res.docs.forEach((value) {
        TimeModel temp = TimeModel.fromSnapshot(value);
        absences.add(temp);
      });
    }

    return absences;
  }

  Future<List<TimeModel>> getEmployeeTime(String idUsaha) async {
    List<TimeModel> employeeTime = [];
    DateFormat dateFormatHari = DateFormat("yyyy-MM-dd");
    String hari = dateFormatHari.format(DateTime.now());
    var res = await collection.where("day", isEqualTo: hari).get();
    if (res.docs.length == 0) {
    } else {
      res.docs.forEach((value) {
        TimeModel temp = TimeModel.fromSnapshot(value);
        employeeTime.add(temp);
      });
    }
    return employeeTime;
  }

  Future countActiveEmployee() async {
    DateFormat dateFormatHari = DateFormat("yyyy-MM-dd");
    String hari = dateFormatHari.format(DateTime.now());
    var res = await collection.where("day", isEqualTo: hari).get();
    print(" banyak ${res.docs.length}");
    return res.docs.length;
  }

  Future updateTime(TimeModel time) async {
    bool success = false;
    await collection
        .doc(time.id)
        .update(time.toJson(time))
        .then((value) => success = true)
        .catchError((onError) => success = false);

    return success;
  }

  bool hasFilteredContent(
      TimeModel data, String filterStart, String filterEnd) {
    var day = DateFormat('yyyy-MM-dd').parse(data.getDay);

    if (filterStart == null || filterStart == "") {
      var filterE = DateFormat('yyyy-MM-dd').parse(filterEnd);
      return filterE.isBefore(day) || filterE.isAtSameMomentAs(day);
    } else if (filterEnd == null || filterEnd == "") {
      var filterS = DateFormat('yyyy-MM-dd').parse(filterStart);
      return filterS.isBefore(day) || filterS.isAtSameMomentAs(day);
    }

    var fStart = DateFormat('yyyy-MM-dd').parse(filterStart);
    var fEnd = DateFormat('yyyy-MM-dd').parse(filterEnd);

    return (fStart.isBefore(day) && fEnd.isAfter(day)) ||
        fStart.isAtSameMomentAs(day) ||
        fEnd.isAtSameMomentAs(day);
  }

  //  Stream for realtime data flow
  Stream<List<TimeModel>> loadAllAbsence(
      {String query1, String query2, String id}) {
    DateFormat dateFormatHari = DateFormat("yyyy-MM-dd");
    String hari = dateFormatHari.format(DateTime.now());
    String search1 = (query1 == "" || query1 == null) ? hari : query1;
    String search2 = (query2 == "" || query2 == null) ? "" : query2;

    if ((id != "" || id != null)) {
      return collection.where("idUser", isEqualTo: id).snapshots().map((value) {
        return value.docs
            .map((data) => TimeModel.fromSnapshot(data))
            .where((x) => hasFilteredContent(x, search1, search2))
            .toList();
      });
    } else {
      return collection.snapshots().map((value) {
        return value.docs
            .map((data) => TimeModel.fromSnapshot(data))
            .where((x) => hasFilteredContent(x, search1, search2))
            .toList();
      });
    }
    // }
  }
}
