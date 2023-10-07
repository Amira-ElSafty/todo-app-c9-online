import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/firebase_utils.dart';
import 'package:flutter_app_todo_c9_online/model/task.dart';
import 'package:provider/provider.dart';

class ListProvider extends ChangeNotifier{

  List<Task> taskList = [];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore(String uId)async{
    QuerySnapshot<Task> querySnapshot = await FirebaseUtils.getTasksCollection(uId).get();
    /// List<QueryDocumentSnapshot<Task>> => List<Task>
    taskList = querySnapshot.docs.map((doc){
      return doc.data();
    }).toList();
    /// filter task (selected date)
    /// 26/9/2023 =>
    taskList = taskList.where((task) {
      if(task.dateTime?.day == selectedDate.day &&
      task.dateTime?.month == selectedDate.month &&
      task.dateTime?.year == selectedDate.year){
        return true ;
      }
      return false ;
    }).toList();

    /// sorting list
    taskList.sort(
        (Task task1 , Task task2){
          return task1.dateTime!.compareTo(task2.dateTime!) ;
        }
    );

    notifyListeners();
  }

  void setNewSelectedDate(DateTime newDate,String uId){
    selectedDate = newDate ;
    getAllTasksFromFireStore(uId);
  }





}