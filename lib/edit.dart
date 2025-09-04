import 'package:flutter/material.dart';
import 'sqldb.dart';

class EditNotePage extends StatefulWidget {
  final id;
  final title;
  final note;
  final color;

  const EditNotePage({super.key, this.id, this.title, this.note, this.color});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
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
  void initState() {
    super.initState();
    titleTxt.text = widget.title ?? '';
    noteTxt.text = widget.note ?? '';
    colorTxt.text = widget.color ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Edit Note"),
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
                          // Method 1: Fixed SQL (removed extra comma)
                          /*
                          int response = await sqlDb.updateData(
                              """
                              UPDATE notes SET
                              note="${noteTxt.text}",
                              title="${titleTxt.text}",
                              color="${colorTxt.text}"
                              WHERE id = ${widget.id}
                          """
                          );
                          */

                          // Method 2: Better approach - using safe parameterized update
                          int response = await sqlDb.updateNote(
                            id: int.parse(widget.id.toString()),
                            note: noteTxt.text,
                            title: titleTxt.text,
                            color: colorTxt.text.isEmpty ? 'blue' : colorTxt.text,
                          );

                          if (response > 0) {
                            Navigator.of(context).pop(true); // Return true to indicate success
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Note updated successfully!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No changes were made')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error updating note: $e')),
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
                        : Text("Update Note"),
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

