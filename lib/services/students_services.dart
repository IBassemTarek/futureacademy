import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/student_model.dart';

class StudentsDataBaseServices {
  final CollectionReference studentsCard =
      FirebaseFirestore.instance.collection('studentsData');

  Future deletestudentsCard({required String uid}) {
    return studentsCard.doc(uid).delete();
  }

  Future<bool> checkIfEmpty() async {
    final snapshot = studentsCard.snapshots();
    bool x = await snapshot.isEmpty;
    if (x) {
      return true;
    } else {
      return false;
    }
  }

  void initStudentInfo(
      {required String address,
      required int age,
      required List attHistory,
      required int currentMonthAtt,
      required int evaluation,
      required String group,
      required String mobileNumber,
      required String name,
      required List notes,
      required String uid,
      required BuildContext context}) async {
    var a = await studentsCard.doc(uid).get();
    if (a.exists) {
      await studentsCard.doc(uid).update({
        "id": uid,
        "mobileNumber": mobileNumber,
        "name": name,
        "notes": notes,
        "address": address,
        "age": age,
        "attHistory": attHistory,
        "currentMonthAtt": currentMonthAtt,
        "evaluation": evaluation,
        "group": group,
      });
    } else {
      final DocumentReference documentReference = studentsCard.doc(uid);
      return await documentReference.set({
        "id": uid,
        "mobileNumber": mobileNumber,
        "name": name,
        "notes": notes,
        "address": address,
        "age": age,
        "attHistory": attHistory,
        "currentMonthAtt": currentMonthAtt,
        "evaluation": evaluation,
        "group": group,
      });
    }
  }

  //convert snapshot to list
  List<StudentsModel> _studentsModelListSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return StudentsModel(
        address: doc.get("address"),
        id: doc.get("id"),
        age: doc.get("age"),
        attHistory: doc.get("attHistory"),
        currentMonthAtt: doc.get("currentMonthAtt"),
        evaluation: doc.get("evaluation"),
        group: doc.get("group"),
        mobileNumber: doc.get("mobileNumber"),
        name: doc.get("name"),
        notes: doc.get("notes"),
      );
    }).toList();
  }

  // define a stream of data that give response when user login or logout
  Stream<List<StudentsModel>> get studentsCardsData {
    return studentsCard.snapshots().map(_studentsModelListSnapShot);
  }

  Future updategroupInfo(
      {required String address,
      required int age,
      required List attHistory,
      required int currentMonthAtt,
      required int evaluation,
      required String group,
      required String mobileNumber,
      required String uid,
      required String name,
      required List notes,
      required BuildContext context}) async {
    return await studentsCard.doc(uid).update({
      'id': uid,
      'mobileNumber': mobileNumber,
      'name': name,
      'notes': notes,
      'address': address,
      'age': age,
      'attHistory': attHistory,
      'currentMonthAtt': currentMonthAtt,
      'evaluation': evaluation,
      'group': group,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("group updated"),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update group: $error"),
      ));
      // ignore: avoid_print
      print("Failed to update group: $error");
    });
  }

  Future addNewSession({
    required List attHistory,
    required int currentMonthAtt,
    required String uid,
    required BuildContext context,
  }) async {
    return await studentsCard.doc(uid).update({
      'attHistory': attHistory,
      'currentMonthAtt': currentMonthAtt,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("group updated"),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update user: $error"),
      ));
      // ignore: avoid_print
      print("Failed to update user: $error");
    });
  }

  Future<List<StudentsModel>> getStudentsGroup(
      {required String groupId}) async {
    List<StudentsModel> temp;

    temp = await studentsCard
        .where('group', isEqualTo: groupId)
        .get()
        .then((query) => query.docs.map((doc) {
              return StudentsModel(
                address: doc.get("address"),
                id: doc.get("id"),
                age: doc.get("age"),
                attHistory: doc.get("attHistory"),
                currentMonthAtt: doc.get("currentMonthAtt"),
                evaluation: doc.get("evaluation"),
                group: doc.get("group"),
                mobileNumber: doc.get("mobileNumber"),
                name: doc.get("name"),
                notes: doc.get("notes"),
              );
            }).toList());
    return temp;
  }

  Future<void> deleteUserData({required String uid}) {
    return studentsCard
        .doc(uid)
        .delete()
        // ignore: avoid_print
        .then((value) => print("groups Deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete groups: $error"));
  }
}
