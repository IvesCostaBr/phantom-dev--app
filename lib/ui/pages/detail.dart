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
  String _filter = '';
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
            var filteredItems = _filter.isEmpty
                ? snapshot.data!["tree_dir"]
                : snapshot.data!["tree_dir"]
                    .where((item) => item.toString().contains(_filter));
            return Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Pesquise o arquivo',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _filter = value;
                            });
                          },
                        ),
                      ),
                      for (var item in filteredItems)
                        ListTile(
                          trailing: const Icon(Icons.arrow_circle_right),
                          focusColor: Colors.amber,
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            "$item",
                            style: const TextStyle(
                                color: Colors.green, fontSize: 12),
                          ),
                          onTap: () => editFile(item),
                        ),
                    ],
                  );
                },
              ),
            );
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
                      final result = await commitRepo(widget.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: result ? Colors.green : Colors.red,
                          content: Text(result
                              ? 'Alterações Enviadas'
                              : 'Erro ao subir alterações'),
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
                    onPressed: () async {
                      final result = await revertChanges(widget.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: result ? Colors.green : Colors.red,
                          content: Text(result
                              ? 'Alterações Revertidas'
                              : 'Erro ao reverter alterações'),
                          duration: Duration(seconds: 2),
                        ),
                      );
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
