import 'package:flutter/material.dart';
import '../../api.dart';

class NewFile extends StatefulWidget {
  String name;
  NewFile({super.key, required this.name});

  @override
  State<NewFile> createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  final TextEditingController _filePathController = TextEditingController();
  final TextEditingController _fileContentController = TextEditingController();

  _createFile() async {
    final filePath = _filePathController.text;
    final fileContent = _fileContentController.text;
    final response = await updateFile(
        widget.name, '${widget.name}/$filePath', fileContent.split("\n"));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: response ? Colors.green : Colors.red,
        content: Text(response
            ? 'Arquivo criado com sucesso!'
            : 'erro ao criar o novo arquivo'),
        duration: Duration(seconds: 2),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Novo Arquivo",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _filePathController,
                decoration: InputDecoration(
                  labelText: 'Caminho do Arquivo',
                  hintText: '/${widget.name}/*',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fileContentController,
                decoration: InputDecoration(
                  labelText: 'Conteúdo do Arquivo',
                  hintText: 'Conteudo',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => _createFile(),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.green)),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save,
                            color: Colors.white), // Ícone antes do texto
                        SizedBox(width: 8), // Espaço entre o ícone e o texto
                        Text(
                          "Criar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
