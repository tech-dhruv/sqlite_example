import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_example/db_handler.dart';
import 'package:sqlite_example/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList =  dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQL Notes"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
               return ListView.builder(
                 shrinkWrap: true,
                  itemCount:  snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return snapshot.data?.length == 0 ? Container() : Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        title: Text(snapshot.data![index].title.toString()),
                        subtitle: Text(snapshot.data![index].email.toString()),
                        trailing: Text(snapshot.data![index].age.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(NotesModel(
                  title: 'First Note',
                  age: 22,
                  description: 'this is my first app',
                  email: 'dsenjaliya54@gmail.com'))
              .then((value) {
            print('data added');
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
