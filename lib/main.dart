import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minhas_anotacoes/helper/anotacao_helper.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';

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
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  _salvarAnotacao({Anotacao anotacaoSelecionada}) async {
    Anotacao anotacao = Anotacao();
    int retorno;
    if (anotacaoSelecionada == null) {
      anotacao = Anotacao(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        data: DateTime.now().toString(),
      );
      retorno = await _db.salvarAnotacao(anotacao);
    } else {
      anotacao = Anotacao(
        id: anotacaoSelecionada.id,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        data: DateTime.now().toString(),
      );
      retorno = await _db.atualizarAnotacao(anotacao);
    }

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
    return retorno;
  }

  _recuperarAnotacoes() async {
    setState(() {
      _anotacoes.clear();
    });
    List anotacoes = await _db.recuperarAnotacoes();
    anotacoes.forEach((anotacao) {
      setState(() {
        _anotacoes.add(Anotacao.fromMap(anotacao));
      });
    });
  }

  _formatarData(String data) {
    initializeDateFormatting('pt_BR', null);
    DateTime dataConvertida = DateTime.parse(data);
    var formatador = DateFormat('d/M/y');
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _removerAnotacao(int id) async {
    int retorno;
    retorno = await _db.removerAnotacao(id);
    _recuperarAnotacoes();
    return retorno;
  }

  _cadastroAnotacaoForm({Anotacao anotacao}) {
    String _textoAtualizar = '';
    if (anotacao != null) {
      _textoAtualizar = 'Atualizar';
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
    } else {
      _textoAtualizar = 'Salvar';
    }
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
              onPressed: () {
                _salvarAnotacao(anotacaoSelecionada: anotacao);
                Navigator.pop(context);
              },
              child: Text(_textoAtualizar),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, indice) {
                Anotacao anotacao = _anotacoes[indice];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      anotacao.titulo,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      '${_formatarData(anotacao.data)} ${anotacao.descricao}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _cadastroAnotacaoForm(anotacao: anotacao);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _removerAnotacao(anotacao.id);
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cadastroAnotacaoForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
