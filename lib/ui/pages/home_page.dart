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
  final _repoKeyController = TextEditingController();

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
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _repoLinkController,
                    decoration: const InputDecoration(
                      labelText: 'SSH Link',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _repoKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Branch',
                    ),
                  )
                ]),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para adicionar o repositório
                      Navigator.pop(context);
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
