import 'package:flutter/material.dart';
import 'edit_view.dart';

import 'package:memommm/memo_db.dart';

class MyApp extends StatelessWidget {
  MyApp(this.cmd, {Key? key}) : super(key: key);
  ControlMemoDatabase cmd;

  static const String _title = 'Flutter Memo App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(cmd),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget(this.cmd, {Key? key}) : super(key: key);
  final ControlMemoDatabase cmd;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(cmd);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  _MyStatefulWidgetState(this.cmd);
  final ControlMemoDatabase cmd;
  bool isLoading = false;
  late List<Memo> memoList;
  late List<int> idList;

  Future getMemoList() async {
    setState(() => isLoading = true);
    memoList = await cmd.memos();
    setState(() => isLoading = false);
    print(memoList);
  }

  @override
  void initState() {
    super.initState();
    getMemoList();
  }

  Future<void> insertMemoMethod(Memo memo) async {
    await cmd.insertMemo(memo);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Memo'),
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      )
          : SizedBox(
            child:
            memoList.isNotEmpty
            ? ListView.builder(
              itemCount: memoList.length ,
              itemBuilder: (BuildContext context, int i){
                final memo = memoList[i];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black38, width: 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                      leading: const Icon(Icons.note),
                      title: Text(
                    memo.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                      subtitle: Text(
                      memo.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                  ),
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.red[700],
                      ),
                      child: const Icon(Icons.delete),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => deleteAlertDialogOnHomePage(context, memo.id, cmd),
                        );
                        getMemoList();
                      },
                    ),
                  onTap: () async {
                    await Navigator.push( //画面遷移 //メモを開く処理
                      context, MaterialPageRoute(
                        builder: (context) =>
                            EditView(memo.id, cmd, memo.title, memo.content)),
                    );
                    getMemoList();
                  },
                ),
                );
          },
        )
                : Center(
                  child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: const Text(
                      'No Memo!\nPlease Add new one!',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                    ),
                  )
            )
        ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 60.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {//メモを新規作成する処理にしておく
          final memo = Memo(
              id: memoList.isNotEmpty
                  ? memoList[memoList.length-1].id+1
                  : 0,
              title: '',
              content: '');
          insertMemoMethod(memo);
          await Navigator.push( //画面遷移
              context, MaterialPageRoute(
                builder: (context) =>
                    memoList.isNotEmpty
                        ? EditView(memoList.last.id+1, cmd, '', '')
                        : EditView(0, cmd, '', '')
          ),
          );
          getMemoList();
        },
        tooltip: 'Add New Memo',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white10,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('メモをすべてエクスポート'),
              onTap: () {
                //あとでなにかかく
              },
            ),
            ListTile(
              title: const Text('設定'),
              onTap: () {
                //あとでなにかかく
              },
            ),
          ]
      ),
    );
  }
}

Widget deleteAlertDialogOnHomePage(BuildContext context, int id, ControlMemoDatabase cmd){
  return AlertDialog(
      title: const Text('Conform'),
      content: const Text('Would you like to delete this memo ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
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

