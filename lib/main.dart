import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  _cadastroAnotacaoForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cadastro anotação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autofocus: true,
                controller: _tituloController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Título',
                  hintText: 'Entre com o título',
                ),
              ),
              TextField(
                controller: _descricaoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Entre com o descrição',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Salvar'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
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
        title: Text('Anotações'),
        backgroundColor: Colors.green,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _cadastroAnotacaoForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
