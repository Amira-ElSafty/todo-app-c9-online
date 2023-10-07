import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_online/login/login_screen.dart';
import 'package:flutter_app_todo_c9_online/my_theme.dart';
import 'package:flutter_app_todo_c9_online/providers/auth_provider.dart';
import 'package:flutter_app_todo_c9_online/providers/list_provider.dart';
import 'package:flutter_app_todo_c9_online/settings/settings.dart';
import 'package:flutter_app_todo_c9_online/task_list/add_task_bottom_sheet.dart';
import 'package:flutter_app_todo_c9_online/task_list/task_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0 ;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List ${authProvider.currentUser!.name}',
        style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(onPressed: (){
            listProvider.taskList = [];
            authProvider.currentUser = null ;
            Navigator.pushNamed(context,LoginScreen.routeName);
          }, icon: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index){
            selectedIndex = index ;
            setState(() {

            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Task-List'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings'
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(
            color: MyTheme.whiteColor,
            width: 6
          )
        ),
        onPressed: (){
          showAddTaskBottomSheet();
        },
        child: Icon(Icons.add,size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }
  List<Widget> tabs = [
    TaskListTab(),SettingsTab()
  ];

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => AddTaskBottomSheet()
    );
  }
}
