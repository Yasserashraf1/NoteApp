import 'package:flutter/material.dart';
import 'addNote.dart';
import 'sqldb.dart';
import 'edit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SqlDb sqlDb = SqlDb();
  bool hasInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    if (!hasInitialized) {
      try {
        await sqlDb.dataBase;
        hasInitialized = true;
        setState(() {});
      } catch (e) {
        print("Error initializing data: $e");
      }
    }
  }

  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM 'notes'");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("My Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNotePage()),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: readData(),
          builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_add, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("No notes yet!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text("Tap the + button to add your first note"),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                final note = snapshot.data![i];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColor(note['color'] ?? 'blue'),
                      child: Text(
                        "${note['id']}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text("${note['title'] ?? 'Untitled'}"),
                    subtitle: Text("${note['note']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditNotePage(
                                  color: note['color'],
                                  title: note['title'],
                                  note: note['note'],
                                  id: note['id'], // Pass as integer, not string
                                ),
                              ),
                            ).then((result) {
                              // Refresh the page when returning from EditNotePage
                              if (result == true) {
                                setState(() {});
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool? confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Note"),
                                content: Text("Are you sure you want to delete this note?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await sqlDb.deleteData("DELETE FROM 'notes' WHERE id = ${note['id']}");
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
