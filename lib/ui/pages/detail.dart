import 'package:code_edit/ui/pages/edit.dart';
import 'package:flutter/material.dart';
import 'package:code_edit/api.dart';

class DetailRepositoryPage extends StatefulWidget {
  String name;
  DetailRepositoryPage({super.key, required this.name});

  @override
  State<DetailRepositoryPage> createState() => _DetailRepositoryPageState();
}

class _DetailRepositoryPageState extends State<DetailRepositoryPage> {
  editFile(String fileDir) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditFilePage(fileDir: fileDir, name: widget.name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getRepoTree(widget.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amberAccent,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"),
            );
          } else {
            return Container(
                color: Colors.black,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        for (var item in snapshot.data!["tree_dir"])
                          ElevatedButton(
                            child: Text(
                              "$item ->",
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () => editFile(item),
                          ),
                        const SizedBox(height: 5),
                        const Divider(),
                      ],
                    );
                  },
                ));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amberAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_tree_rounded),
                    onPressed: () async {
                      commitRepo(widget.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Alterações Enviadas'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.undo),
                    onPressed: () {
                      // Lógica para reverter
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
