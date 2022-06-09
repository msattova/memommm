
import 'package:flutter/material.dart';
import '../memo_db.dart';

class EditView extends StatefulWidget {
  const EditView(this.id, this.cmd, this.title, this.content, {Key? key}) : super(key: key);
  final int id;
  final ControlMemoDatabase cmd;
  final String title;
  final String content;
  @override
  State<StatefulWidget> createState() => _EditView(id, cmd, title, content);
}


class _EditView extends State<EditView> {
  _EditView(this.id, this.cmd, this.title, this.content);
  final int id;
  final ControlMemoDatabase cmd;
  String title;
  String content;
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: title);
    contentController = TextEditingController(text: content);
  }

  Future<void> updateMemoMethod(Memo memo) async {
    await cmd.updateMemo(memo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memo'),
        actions: [
          DeleteButton(id, cmd),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Title',
              ),
              controller: titleController,
              autofocus: false,
            ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your Memo',
              ),
                controller: contentController,
              maxLines: 20,
            ),
            ),
          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          const snackBar = SnackBar(content: Text('Memo Saved!'));
          final memo = Memo(
            id: id,
            title: titleController.text,
            content: contentController.text,
          );
          updateMemoMethod(memo);
          print(titleController);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton(this.id, this.cmd, {Key? key}) : super(key: key);
  final int id;
  final ControlMemoDatabase cmd;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          child: const Icon(Icons.delete),
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) => deleteAlertDialog(context, id, cmd),
            );
          },
        ),
    );
  }
}

Widget deleteAlertDialog(BuildContext context, int id, ControlMemoDatabase cmd){
  return AlertDialog(
    title: const Text('Conform'),
    content: const Text('Would you like to delete this memo ?'),
    actions: <Widget>[
      TextButton(
          onPressed: () async {
            Navigator.pop(context);
            Navigator.pop(context);
            await cmd.deleteMemo(id);
            },
          child: const Text('Yes'),
          ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('No'),
      ),
    ]
  );
}
