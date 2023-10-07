import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_todo_c9_online/model/my_user.dart';
import 'package:flutter_app_todo_c9_online/model/task.dart';

class FirebaseUtils{

  static CollectionReference<Task> getTasksCollection(String uId){
    return getUsersCollection().doc(uId).
    collection(Task.collectionName).
    withConverter<Task>(
        fromFirestore: ((snapshot, options) => Task.fromFireStore(snapshot.data()!)),
        toFirestore: (task,options) => task.toFireStore()
    );
  }

  static Future<void> addTaskToFirebase(Task task,String uId){
    var taskCollection = getTasksCollection(uId);  /// collection
    DocumentReference<Task> taskDocRef = taskCollection.doc();  /// document
    task.id = taskDocRef.id ;
   return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task,String uId){
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static CollectionReference<MyUser> getUsersCollection(){
    return FirebaseFirestore.instance.collection(MyUser.collectionName).
    withConverter<MyUser>(
        fromFirestore: (snapshot, options) => MyUser.fromFireStore(snapshot.data()),
        toFirestore: (user,options) => user.toFireStore()
    );
  }

  static Future<void> addUserToFireStore(MyUser myUser){
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId)async{
    var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }
}