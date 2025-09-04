import 'package:flutter/material.dart';
import 'sqldb.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {

  SqlDb sqlDb = SqlDb();

  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController titleTxt = TextEditingController();
  TextEditingController noteTxt = TextEditingController();
  TextEditingController colorTxt = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    titleTxt.dispose();
    noteTxt.dispose();
    colorTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add Note"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleTxt,
                    decoration: InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: noteTxt,
                    decoration: InputDecoration(
                      hintText: "Note",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a note';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: colorTxt,
                    decoration: InputDecoration(
                      hintText: "Color (e.g., red, blue, green)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: isLoading ? null : () async {
                      if (formState.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          // Using the safer insertion method
                          int response = await sqlDb.insertNote(
                            note: noteTxt.text,
                            title: titleTxt.text,
                            color: colorTxt.text.isEmpty ? 'blue' : colorTxt.text,
                          );

                          if (response > 0) {
                            Navigator.of(context).pop(); // Go back to previous screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Note added successfully!')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error adding note: $e')),
                          );
                        }

                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Add Note"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
