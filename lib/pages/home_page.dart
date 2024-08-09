import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habittracker_app/components/habit_tile.dart';
import 'package:habittracker_app/components/month_summary.dart';
import 'package:habittracker_app/components/my_drawer.dart';

import 'package:habittracker_app/components/my_fab.dart';
import 'package:habittracker_app/components/new_habit_box.dart';
import 'package:habittracker_app/data/habit_database.dart';

import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();

  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return NewHabitBox(
            controller: _newHabitNameController,
            hintText: "Enter Habit Name..",
            onSave: saveNewHabit,
            onCancel: cancelDialogBox,
          );
        });
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();

    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return NewHabitBox(
            controller: _newHabitNameController,
            hintText: db.todaysHabitList[index][0],
            onCancel: cancelDialogBox,
            onSave: () => saveExistingHabit(index),
          );
        });
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: MyDrawer(),
        backgroundColor: Colors.grey[300],
        floatingActionButton: MyFloatingActionButton(
          onpressed: createNewHabit,
        ),
        body: ListView(
          children: [
            MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE"),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todaysHabitList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitCompleted: db.todaysHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index),
                  settingsTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                );
              },
            ),
          ],
        ));
  }
}
