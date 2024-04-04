import 'package:flutter/material.dart';
import 'package:code_edit/api.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class EditFilePage extends StatefulWidget {
  String name;
  String fileDir;
  EditFilePage({super.key, required this.name, required this.fileDir});

  @override
  State<EditFilePage> createState() => _EditFilePageState();
}

class _EditFilePageState extends State<EditFilePage> {
  TextEditingController _problemTextController = TextEditingController();
  List<String> _dropdownItems = ["refact", "fix"];
  var selectItem = "refact";
  var text = "";
  var _loading = false;

  sendFileGpt() async {
    Navigator.of(context).pop();
    setState(() {
      _loading = true;
    });
    await autoChange(widget.fileDir, selectItem, _problemTextController.text);
    setState(() {
      _loading = false;
    });
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Formulário de Análise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectItem,
                onChanged: (newValue) {
                  setState(() {
                    selectItem = newValue!;
                  });
                },
                items: _dropdownItems.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: _problemTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Descreva o problema no arquivo',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await sendFileGpt();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green)),
              child: const Text(
                'Enviar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (_loading)
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: const Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Envinado Arquivo para Analise"),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> saveFile() async {
    final response =
        await updateFile(widget.name, widget.fileDir, text.split("\n"));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: response ? Colors.green : Colors.redAccent,
        content: Text(response ? 'Arquivo Salvo' : 'Erro ao salvar o arquivo'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.amberAccent,
          centerTitle: true,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: getFileDetail(widget.fileDir),
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
              text = snapshot.data!
                  .map((line) => line.replaceAll(RegExp(r"^\d+: "), ""))
                  .toList()
                  .join('\n');
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Arquivo sendo editado:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.fileDir,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                style: const TextStyle(color: Colors.green),
                                controller: TextEditingController(text: text),
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                onChanged: (value) {
                                  text = value;
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.warning,
                                      size:
                                          20), // Ícone do lado esquerdo do texto
                                  SizedBox(
                                      width:
                                          8), // Espaçamento entre o ícone e o texto
                                  Text(
                                    'Atenção, verifique a indentação do arquivo que \n você está editando antes de salvar.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () => saveFile(),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.green)),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save,
                                            color: Colors
                                                .white), // Ícone antes do texto
                                        SizedBox(
                                            width:
                                                8), // Espaço entre o ícone e o texto
                                        Text(
                                          "Salvar",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                              ElevatedButton(
                                  onPressed: () async {
                                    _showAlertDialog();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.blueAccent)),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.analytics_outlined,
                                            color: Colors
                                                .white), // Ícone antes do texto
                                        SizedBox(
                                            width:
                                                8), // Espaço entre o ícone e o texto
                                        Text(
                                          "Auto Analise - GPT",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )
                      // child: ListView.builder(
                      //   itemCount: snapshot.data!.length,
                      //   itemBuilder: (context, index) {
                      //     return Column(
                      //       children: [
                      //         for (var item in snapshot.data!["tree_dir"])
                      //           ElevatedButton(
                      //             child: Text(
                      //               "$item ->",
                      //               style: TextStyle(color: Colors.green),
                      //             ),
                      //             onPressed: () => {},
                      //           ),
                      //         const SizedBox(height: 5),
                      //         const Divider(),
                      //       ],
                      //     );
                      //   },
                      // ));
                      ),
                ),
              );
            }
          },
        ));
  }
}
