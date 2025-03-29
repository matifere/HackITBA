import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  String name;
  String? dir;
  setName(String name) {
    this.name = name;
  }

  setDir(String dir) {
    this.dir = dir;
  }

  String getName() {
    return name;
  }

  String? getDir() {
    return dir;
  }

  User(this.name, this.dir);

  sendToFirestore() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.add({
      'name': name,
      'dir': dir,
    });
  }
  Future<List<User>> getUsers() async {
    List<User> users = [];
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await usersCollection.get();
    for (var doc in querySnapshot.docs) {
      String name = doc['name'];
      String? dir = doc['dir'];
      users.add(User(name, dir));
    }
    return users;
  }
  Future<void> deleteUser(String username) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await users.where('name', isEqualTo: username).get();
    for (var doc in querySnapshot.docs) {
      await users.doc(doc.id).delete();
    }
  }
  
}
