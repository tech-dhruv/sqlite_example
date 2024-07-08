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
    setState(() {
      notesList = dbHelper!.getNotesList();
    });
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading data'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data found'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          dbHelper!.updateNotes(NotesModel(
                            id: snapshot.data![index].id!,
                            title: 'Second Flutter note',
                            age: 11,
                            description: 'hello Now i am busy',
                            email: 'dhyan.de.54@gmail.com',
                          ));
                          setState(() {
                            notesList = dbHelper!.getNotesList();
                          });
                        },
                        child: Dismissible(

                          direction: DismissDirection.endToStart,

                          background: const Card(
                            color: Colors.redAccent,
                            child: Icon(Icons.delete_forever),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              dbHelper!.deleteNotes(snapshot.data![index].id!);
                              notesList = dbHelper!.getNotesList();
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          key: ValueKey(snapshot.data![index].id!),
                          child: Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                              title: Text(snapshot.data![index].title),
                              subtitle: Text(snapshot.data![index].email),
                              trailing:
                                  Text(snapshot.data![index].age.toString()),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(NotesModel(
            title: 'First Note',
            age: 22,
            description: 'This is my first app',
            email: 'dsenjaliya54@gmail.com',
          ))
              .then((value) {
            print('Data added');
            loadData();
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
