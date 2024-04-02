import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidden_gems_sg/models/invitation.dart';

class InboxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Invitation>> getConfirmedInvitations(String uid) async {
    List<Invitation> invites = [];
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('invites')
        .get()
        .then((value) {
      if (value.size != 0) {
        for (var n in value.docs) {
          Invitation invitation = Invitation.fromSnapshot(n);
          invites.add(invitation);
        }
      }
    });
    return invites;
  }
}
