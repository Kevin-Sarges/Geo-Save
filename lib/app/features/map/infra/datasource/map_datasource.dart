import 'package:geolocator/geolocator.dart';
import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/common/error/common_errors.dart';
import 'package:geosave/app/common/helpers/open_database.dart';
import 'package:geosave/app/common/model/local_model.dart';
import 'package:geosave/app/common/strings/strings_app.dart';
import 'package:geosave/app/features/map/domain/datasource/imap_datasourcer.dart';
import 'package:sqflite/sqflite.dart';

class MapDataSource implements MapDataSourceImpl {
  final _db = DatabaseHelper();

  @override
  Future<Position> getGeoLocalizacaoUsuario() async {
    try {
      final permission = await Geolocator.checkPermission();
      final request = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied &&
          request == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso á localização !!');
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error('Você precisa autorizar o acesso á localização !!');
      }

      final local = await Geolocator.getCurrentPosition();

      return local;
    } on PositionUpdateException catch (e) {
      throw CommonDesconhecidoError(message: e.message);
    }
  }

  @override
  Future<List<LocalEntity>> getLocaisSalvos() async {
    try {
      final database = await _db.openDb();
      final getTable = await database.query(StringsApp.nomeTabela);

      final result = getTable.map((data) {
        return LocalModel.fromJson(data);
      }).toList();

      return result;

    } on DatabaseException catch(e) {
      throw CommonDesconhecidoError(message: e.toString());
    }
  }
}
