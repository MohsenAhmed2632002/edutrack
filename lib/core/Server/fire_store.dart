import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Models/graduation_project_model.dart';

class FireSoterUser {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection("Users");

     final CollectionReference _projectsCollection =
      FirebaseFirestore.instance.collection("GraduationProjects");

  Future<void> addUserToFireStore(UserModel userModel) async {
    await _usersCollection.doc(userModel.userId).set(userModel.toJson());
  }

  Future<void> updateUserInFireStore(UserModel userModel) async {
    await _usersCollection.doc(userModel.userId).update(userModel.toJson());
  }

  Future<DocumentSnapshot> getCurrentUser(String uid) async {
    return await _usersCollection.doc(uid).get();
  }

  Future<void> addGraduationProject(GraduationProjectModel projectModel) async {
    await _projectsCollection.add(projectModel.toJson());
  }

  Future<List<GraduationProjectModel>> getAllProjects() async {
    final querySnapshot = await _projectsCollection.orderBy('createdAt', descending: true).get();
    return querySnapshot.docs.map((doc) {
      return GraduationProjectModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
  }
