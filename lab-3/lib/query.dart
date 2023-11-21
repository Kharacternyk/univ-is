import 'package:sqlite3/sqlite3.dart';

typedef Values = List<Object?>;

class Query {
  final PreparedStatement _statement;

  Query(Database database, String sql) : _statement = database.prepare(sql);

  Iterable<Values> select([Values parameters = const []]) {
    final result = _statement.select(parameters);

    _statement.reset();

    return result.rows;
  }
}
