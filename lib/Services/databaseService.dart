import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rolling_dice/Models/Users.dart';

final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');

class DatabaseService {
  static String? uid;

  static Future<void> updateUserData(
    String email,
    String name,
  ) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'name': name,
    });
  }

  static List<UserProfile> _userListFromSnapshot(QuerySnapshot snapshot) {
    List<UserProfile> userList = snapshot.docs.map((doc) {
      return getProfile(doc);
    }).toList();
    userList.sort((a, b) => b.highestScore.compareTo(a.highestScore));
    return userList;
  }
  static UserProfile _userFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return UserProfile(
      name: data['name'] ?? '',
      email: data["email"] ?? "",
      highestScore: data["highestScore"] ?? 0,
    );
  }

  static UserProfile getProfile(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    print(snapshot.data());
    return UserProfile(
      name: data['name'] ?? '',
      email: data["email"] ?? "",
      highestScore: data["highestScore"] ?? 0,
    );
  }

  static Stream<List<UserProfile>> get allUserProfiles {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
  static Stream<UserProfile> get userProfile {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseService.uid = firebaseUser!.uid;
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  static Future<void> updateItem({
    required int highestScore,
  }) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseService.uid = firebaseUser!.uid;
    DocumentReference documentReferencer = userCollection.doc(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "highestScore": highestScore,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static String checkStringValue(dynamic value, String defaultValue) {
    return (value != null) ? value as String : defaultValue;
  }
}
