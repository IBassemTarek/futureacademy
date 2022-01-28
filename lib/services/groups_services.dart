import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/group_model.dart';

class GroupsDataBaseServices {
  final CollectionReference groupsCard =
      FirebaseFirestore.instance.collection('groupsCard');

  Future deletegroupsCard({required String uid}) {
    return groupsCard.doc(uid).delete();
  }

  Future<bool> checkIfEmpty() async {
    final snapshot = groupsCard.snapshots();
    bool x = await snapshot.isEmpty;
    print(x);
    if (x) {
      return true;
    } else {
      return false;
    }
  }

  //convert snapshot to list
  List<GroupsModel> _groupsModelListSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return GroupsModel(
        captainName: doc.get("captainName"),
        captainNumber: doc.get("captainNumber"),
        dates: doc.get("dates"),
        groupName: doc.get("groupName"),
        id: doc.get("id"),
        department: doc.get("department"),
        studentsID: doc.get("StudentsID"),
      );
    }).toList();
  }

  // define a stream of data that give response when user login or logout
  Stream<List<GroupsModel>> get groupsCardsData {
    return groupsCard.snapshots().map(_groupsModelListSnapShot);
  }

  Future updategroupInfo(
      {required String captainName,
      required String captainNumber,
      required List dates,
      required int department,
      required String groupName,
      required String id,
      required BuildContext context}) async {
    return await groupsCard.doc(id).update({
      'captainName': captainName,
      'captainNumber': captainNumber,
      'department': department,
      'groupName': groupName,
      'dates': dates,
      'id': id,
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

  Future addNewStudent(
      {required List studentsID,
      required String id,
      required BuildContext context}) async {
    return await groupsCard.doc(id).update({
      'StudentsID': studentsID,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("تم إضافة مستخدم إلي المجموعة"),
      ));
      // ignore: invalid_return_type_for_catch_error, avoid_print
    }).catchError((error) => print("Failed to add groups: $error"));
  }

  Future addNewgroupsData(
      {required String groupName,
      required List studentsID,
      required int department}) async {
    return await groupsCard
        .doc(groupName + department.toString())
        .set({
          'groupName': groupName,
          'id': groupName + department.toString(),
          'department': department,
          'StudentsID': [],
          "captainName": '',
          "captainNumber": '',
          "dates": [],
        })
        // ignore: avoid_print
        .then((value) => print("groups added"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to add groups: $error"));
  }

  Future startNewMonth({
    required String groupid,
  }) async {
    return await groupsCard
        .doc(groupid)
        .update({
          "dates": [],
        })
        // ignore: avoid_print
        .then((value) => print("groups dates resets"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to reset groups dates: $error"));
  }

  Future<void> deletegroups(String id) {
    return groupsCard
        .doc(id)
        .delete()
        // ignore: avoid_print
        .then((value) => print("groups Deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete groups: $error"));
  }
}
