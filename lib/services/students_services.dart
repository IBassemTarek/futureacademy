import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/student_model.dart';

class StudentsDataBaseServices {
  final CollectionReference studentsCard =
      FirebaseFirestore.instance.collection('studentsData');
  CollectionReference studentPayment({required String uid}) {
    return studentsCard.doc(uid).collection('payment');
  }

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
      // await studentPayment(uid:uid , )
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

  Future formateStudentDates(
      {required String uid, required BuildContext context}) async {
    return await studentsCard.doc(uid).update(
        {'id': uid, 'attHistory': [], "currentMonthAtt": 0}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("student updated"),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update student: $error"),
      ));
      // ignore: avoid_print
      print("Failed to update student: $error");
    });
  }

  Future updateStudentInfo(
      {required String address,
      required String uid,
      required String name,
      required String mobileNumber,
      required int age,
      required int evaluation,
      required String group,
      required BuildContext context}) async {
    return await studentsCard.doc(uid).update({
      'id': uid,
      'name': name,
      'address': address,
      'mobileNumber': mobileNumber,
      'age': age,
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

  Future studentsGroupNewMonth({
    required String groupId,
  }) async {
    await studentsCard
        .where('group', isEqualTo: groupId)
        .get()
        .then((snapshots) async => {
              for (var doc in snapshots.docs)
                {
                  await doc.reference.update({
                    'currentMonthAtt': 0,
                  })
                }
            });
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

  Future addStudentNote(
      {required String uid,
      required List notes,
      required BuildContext context}) async {
    return await studentsCard.doc(uid).update({
      'id': uid,
      'notes': notes,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("note added"),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to add note: $error"),
      ));
      // ignore: avoid_print
      print("Failed to add note: $error");
    });
  }

  Future addStudentPayment(
      {required String uid,
      required int cost,
      required Timestamp date,
      required BuildContext context}) async {
    return await studentPayment(uid: uid).add({
      'cost': cost,
      'date': date,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("note added"),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to add note: $error"),
      ));
      // ignore: avoid_print
      print("Failed to add note: $error");
    });
  }

  Future<List<StudentsPayment>> getStudentPayment(
      {required String uid, required BuildContext context}) async {
    return await studentPayment(uid: uid)
        .get()
        .then((query) => query.docs.map((doc) {
              return StudentsPayment(
                amount: doc.get("cost"),
                date: doc.get("date"),
              );
            }).toList())
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to read note: $error"),
      ));
      // ignore: avoid_print
      print("Failed to add note: $error");
    });
  }
}
