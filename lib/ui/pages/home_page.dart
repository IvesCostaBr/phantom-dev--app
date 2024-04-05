import 'package:code_edit/api.dart';
import 'package:code_edit/dtos/repository.dart';
import 'package:code_edit/ui/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChaveSshEditingController extends TextEditingController {
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repoLinkController = TextEditingController();
  final _repoNamekController = TextEditingController();
  final _repoBranchController = TextEditingController();
  var _publicKey = '';

  @override
  void initState() {
    super.initState();
    initializePublicKey();
  }

  getDetailReposotiory(String repositoryName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DetailRepositoryPage(name: repositoryName)));
  }

  initializePublicKey() async {
    _publicKey = await getPublicKey();
    setState(() {}); // Atualiza a UI com a chave pública obtida
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
          content: SingleChildScrollView(
            child: Column(children: [
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
                controller: _repoBranchController,
                decoration: const InputDecoration(
                  labelText: 'Branch',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "Adicione essa chave publica no seu provedor de repositorio [GitHub, Gitlab]",
                  overflow: TextOverflow.clip,
                  maxLines: null),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => {
                  Clipboard.setData(ClipboardData(text: _publicKey)),
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.fixed,
                      content:
                          Text('Texto copiado para a área de transferência')))
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5, // Adiciona uma sombra para destacar o card
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      _publicKey,
                    ),
                  ),
                ),
              )
            ]),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green)),
              onPressed: () async {
                final result = await createRepo(
                  _repoNamekController.text,
                  _repoLinkController.text,
                  _repoBranchController.text,
                );
                final message = result
                    ? "Repositório Adicionado"
                    : "Erro ao adicionar o repositório";
                showSnackBar(message, result);
                initState() {
                  _repoNamekController.text = "";
                  _repoBranchController.text = "";
                  _repoLinkController.text = "";
                }

                Navigator.of(context).pop();
              },
              child: const Text(
                'Adicionar',
                style: TextStyle(color: Colors.white),
              ),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: ListTile(
                        onTap: () =>
                            getDetailReposotiory(snapshot.data![index].name),
                        title: Text(snapshot.data![index].name),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
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
        onPressed: () async {
          showFormCreateRepo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
