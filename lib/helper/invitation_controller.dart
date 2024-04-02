import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hidden_gems_sg/helper/auth_controller.dart';
import 'package:hidden_gems_sg/models/invitation.dart';
import 'package:hidden_gems_sg/models/user.dart';

class InvitationController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController _authController = AuthController();

  Future addToExplore(String place, String date, String time) async {
    List<UserModel> users = [];
    var user = _authController.getCurrentUser();

    await _authController.getUserFromId(user!.uid).then((value) {
      UserModel user = UserModel.fromSnapshot(value);
      users.add(user);
    });
    var sender =
        _firestore.collection('users').doc(user.uid).collection('toExplore');
    String key = sender.doc().id;
    Invitation invitation = Invitation(key, place, date, time, users, false);
    await sender.doc(key).set(invitation.toJson());
  }

  Future<String?> sendInvitationToUser(List<String> to, String from,
      String place, String date, String time) async {
    List<UserModel> users = [];
    List<UserModel> unconfirmed = [];
    List<String> uids = [];
    var batch = _firestore.batch();

    await _authController.getUserFromId(from).then((value) {
      UserModel user = UserModel.fromSnapshot(value);
      users.add(user);
    });

    for (String username in to) {
      var uid = await _authController.getUidfromUsername(username);
      uids.add(uid);
    }

    if (uids.length == to.length) {
      await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: uids)
          .get()
          .then((value) {
        if (value.size != 0) {
          for (var i in value.docs) {
            UserModel user = UserModel.fromSnapshot(i);
            unconfirmed.add(user);
          }
        } else {
          return 'unable to send invitation';
        }
      });
      var sender =
          _firestore.collection('users').doc(from).collection('toExplore');
      String key = sender.doc().id;
      Invitation invitation = Invitation(key, place, date, time, users, false);
      await sender.doc(key).set(invitation.toJson());

      for (UserModel u in unconfirmed) {
        batch.set(
            _firestore
                .collection('users')
                .doc(u.id)
                .collection('invites')
                .doc(key),
            invitation.toJson());
      }
      batch.commit();
      return null;
    } else {
      return 'unable to send invitation';
    }
  }
}
