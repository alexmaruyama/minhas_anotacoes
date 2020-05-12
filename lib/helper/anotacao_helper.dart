import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._inicial();

  Database _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }
  AnotacaoHelper._inicial();

  _createDatabase(Database db, int version) async {
    String sql =
        'create table anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)';
    await db.execute(sql);
  }

  _inicializarBancoDados() async {
    var caminhoBancoDados = await getDatabasesPath();
    var localBancoDados = join(caminhoBancoDados, 'minhas_anotacoes.db');

    Database db = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: _createDatabase,
    );
    return db;
  }

  get db async {
    if (_db == null) {
      _db = await _inicializarBancoDados();
      return _db;
    } else {
      return _db;
    }
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    int retorno = await bancoDados.insert(
      'anotacao',
      anotacao.toMap(),
    );
    return retorno;
  }

  recuperarAnotacoes() async {
    var bancoDados = await db;
    var sql = 'SELECT * FROM anotacao';

    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    int retorno = await bancoDados.update(
      'anotacao',
      anotacao.toMap(),
      where: 'id = ?',
      whereArgs: [anotacao.id],
    );
    return retorno;
  }

  Future<int> removerAnotacao(int id) async {
    var bancoDados = await db;
    int retorno = await bancoDados.delete(
      'anotacao',
      where: 'id = ?',
      whereArgs: [id],
    );
    return retorno;
  }
}
