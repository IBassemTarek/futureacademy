import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsModel {
  final String address;
  final int age;
  final List attHistory;

  final int currentMonthAtt;
  final int evaluation;
  final String group;

  final String id;
  final String mobileNumber;
  final String name;
  final List notes;

  StudentsModel({
    required this.address,
    required this.id,
    required this.age,
    required this.attHistory,
    required this.currentMonthAtt,
    required this.evaluation,
    required this.group,
    required this.mobileNumber,
    required this.name,
    required this.notes,
  });
}

class StudentsPayment {
  final int amount;
  final Timestamp date;
  StudentsPayment({
    required this.amount,
    required this.date,
  });
}
