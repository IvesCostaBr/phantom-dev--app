import 'dart:convert';

import 'package:code_edit/db/database.dart';
import 'package:code_edit/dtos/url.dart';
import 'package:flutter/material.dart';
import '../../api.dart';

class ConfigPage extends StatelessWidget {
  final TextEditingController urlApiController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();
  // final _database = PhantomDatabase.instance;
  ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuração"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Digite as configrações da API",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: urlApiController,
                decoration: const InputDecoration(
                  labelText: 'API URL',
                  hintText: 'URL é obrigatório',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'error';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: apiKeyController,
                decoration: const InputDecoration(labelText: 'API KEY'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.green)),
                onPressed: () {
                  // Simular envio do formulário
                  if (urlApiController.text.isNotEmpty) {
                    baseUrl = urlApiController.text;
                    // final result = _database.create(UrlModel(url: baseUrl, apiKey: apiKeyController.text));
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text('Campo url é obrigatório'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
