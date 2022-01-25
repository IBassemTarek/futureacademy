import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futureacademy/Models/feedback_model.dart';

class FeedbackDataBaseServices {
  final CollectionReference feedbackCard =
      FirebaseFirestore.instance.collection('feedback');

  Future<bool> checkIfEmpty() async {
    final snapshot = feedbackCard.snapshots();
    bool x = await snapshot.isEmpty;
    if (x) {
      return true;
    } else {
      return false;
    }
  }

  //convert snapshot to list
  List<FeedbackModel> _feedbacksModelListSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FeedbackModel(
        msg: doc.get("msg"),
        studentID: doc.get("studentID"),
      );
    }).toList();
  }

  // define a stream of data that give response when user login or logout
  Stream<List<FeedbackModel>> get feedbacksCardsData {
    return feedbackCard.snapshots().map(_feedbacksModelListSnapShot);
  }
}
