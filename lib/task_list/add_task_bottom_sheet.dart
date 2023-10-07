import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/dialog_utils.dart';
import 'package:flutter_app_todo_c9_online/firebase_utils.dart';
import 'package:flutter_app_todo_c9_online/model/task.dart';
import 'package:flutter_app_todo_c9_online/providers/auth_provider.dart';
import 'package:flutter_app_todo_c9_online/providers/list_provider.dart';
import 'package:provider/provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider ;
  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text('Add new Task',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Form(
            key: formKey,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (text){
                    title = text ;
                  },
                  validator: (text){
                    if(text == null || text.isEmpty){
                      return 'Please enter task title';
                    }
                    return null ;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Task Title'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (text){
                    description = text ;
                  },
                  validator: (text){
                    if(text == null || text.isEmpty){
                      return 'Please enter task description';
                    }
                    return null ;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Task Description',
                  ),
                  maxLines: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select Date',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              InkWell(
                onTap: (){
                  /// show calendar
                  showCalendar();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${selectedDate.day}/${selectedDate.month}/'
                      '${selectedDate.year}',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    /// add task to firebase
                    addTask();
                  },
                  child: Text('Add',
                  style: Theme.of(context).textTheme.titleLarge,))

            ],
          )),
        ],
      ),
    );
  }

  void showCalendar() async{
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if(chosenDate != null){
      selectedDate = chosenDate  ;
      setState(() {

      });
    }
  }

  void addTask() async{
    if(formKey.currentState?.validate()==true){
      /// add task to firebase
      Task task = Task(
          title: title,
          description: description,
          dateTime: selectedDate
      );
      var authProvider = Provider.of<AuthProvider>(context,listen: false);
      DialogUtils.showLoading(context, 'Loading...');
      await FirebaseUtils.addTaskToFirebase(task,authProvider.currentUser!.id!)
      .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Todo Added Succuessfully',posActionName: 'Ok',
        isDismissable: true);

      })
          .timeout(Duration(milliseconds: 500), onTimeout: (){
          print('todo added successfully');
          listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
          Navigator.pop(context);
      }
      );
    }
  }
}
