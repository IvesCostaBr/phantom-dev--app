import 'package:code_edit/api.dart';
import 'package:code_edit/dtos/repository.dart';
import 'package:code_edit/ui/pages/detail.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repoLinkController = TextEditingController();
  final _repoNamekController = TextEditingController();
  final _repoBranchController = TextEditingController();
  final _personalTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  getDetailReposotiory(String repositoryName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DetailRepositoryPage(name: repositoryName)));
  }

  showSnackBar(String text, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.green : Colors.red,
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<String> transformSSHKeyToArray(String sshKey) {
    List<String> lines = sshKey.split("\n");
    List<String> formattedLines = [];
    for (String line in lines) {
      formattedLines.add(line);
    }
    return formattedLines;
  }

  showFormCreateRepo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Repositório'),
          content: Column(children: [
            TextField(
              controller: _repoNamekController,
              decoration: const InputDecoration(
                labelText: 'Nome do Repositório',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _repoLinkController,
              decoration: const InputDecoration(
                labelText: 'SSH url',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _personalTokenController,
              decoration: const InputDecoration(
                labelText: 'SSH Private Key',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _repoBranchController,
              decoration: const InputDecoration(
                labelText: 'Branch',
              ),
            )
          ]),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final result = await createRepo(
                    _repoNamekController.text,
                    _repoLinkController.text,
                    _repoBranchController.text,
                    transformSSHKeyToArray(_personalTokenController.text));
                final message = result
                    ? "Repositório Adicionado"
                    : "Erro ao adicionar o repositório";
                showSnackBar(message, result);
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositórios"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Repository>?>(
        future: getRepos(),
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
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () =>
                              getDetailReposotiory(snapshot.data![index].name),
                          child: Text(snapshot.data![index].name)),
                    ],
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text("Não foi encontrado nenhum repositório registrado."),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormCreateRepo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
