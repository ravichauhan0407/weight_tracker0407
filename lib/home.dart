import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_pro/weight.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper helper = DatabaseHelper();
  Weight weightObj = Weight(0, '');
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Weight> weightList;
  int count = 0;
  int currentweight = 0;
  int change = 0;
  int weekchange = 0;
  int monthchange = 0;

  @override
  Widget build(BuildContext context) {
    if (weightList == null) {
      weightList = List<Weight>();
      updateListView();
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: ListTile(
                    title: Text('Update Profile'), leading: CircleAvatar()),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.help),
                  title: Text(
                    'Help',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Weight Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                color: Colors.black54,
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'Actual',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '$currentweight Kg',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                Text('Change',
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                  '$change Kg',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                Text('This Week',
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                  '$weekchange Kg',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                Text('This Month',
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                  '$monthchange Kg',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Icon(Icons.add),
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: addWeight,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  TextEditingController weightController = TextEditingController();
  void addWeight() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 350.0,
              color: Colors.black,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Add a record',
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.black45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: weightController,
                            onChanged: (value) {
                              updateWeight();
                            },
                            decoration:
                                InputDecoration(hintText: '  Weight(in kg)'),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: save,
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void updateWeight() {
    weightObj.weight = int.parse(weightController.text);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) {
          return alertDialog;
        });
  }

  void save() async {
    moveToLastScreen();
    int result;
    weightObj.date = DateFormat.yMMMd().format(DateTime.now());
    result = await helper.insertWeight(weightObj);
    if (result != 0) {
      _showAlertDialog('Status', 'Note saved Succesfully');
    } else {
      _showAlertDialog('Status', 'Problem saving Note');
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Weight>> weightListView = databaseHelper.getWeightList();
      weightListView.then((value) {
        setState(() {
          this.weightList = value;
          this.count = value.length;
          if (count > 0) {
            updateCurrentWeight();
          }
        });
      });
    });
  }

  void updateCurrentWeight() {
    setState(() {
      int x = 0;
      int first = weightList[count - 1].weight;
      int end = 0;
      for (int i = count - 2; i >= 0 && x <= 7; i--) {
        end = weightList[i].weight;
        x++;
      }
      var k = end - first;
      this.weekchange = k.abs();
      x = 0;
      for (int i = count - 2; i >= 0 && x <= 30; i--) {
        end = weightList[i].weight;
        x++;
      }
      var d = end - first;
      this.monthchange = d.abs();
      this.currentweight = first;
      if (count > 1) {
        this.change = weightList[count - 1].weight - weightList[count - 2].weight;
        this.change.abs();
      } else {
        this.change = 0;
      }
    });
  }
}
