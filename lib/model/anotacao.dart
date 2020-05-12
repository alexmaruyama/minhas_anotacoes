import 'package:minhas_anotacoes/helper/anotacao_helper.dart';

class Anotacao {
  int id;
  String titulo;
  String descricao;
  String data;

  AnotacaoHelper anotacaoHelper = AnotacaoHelper();

  Anotacao({this.id, this.titulo, this.descricao, this.data});

  Anotacao.fromMap(Map map) {
    this.id = map['id'];
    this.titulo = map['titulo'];
    this.descricao = map['descricao'];
    this.data = map['data'];
  }

  Map toMap() {
    Map<String, dynamic> anotacao = {
      'titulo': this.titulo,
      'descricao': this.descricao,
      'data': this.data,
    };
    if (this.id != null) {
      anotacao['id'] = this.id;
    }
    return anotacao;
  }
}
