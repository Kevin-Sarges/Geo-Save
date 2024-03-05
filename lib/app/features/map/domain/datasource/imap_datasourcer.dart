import 'package:geolocator/geolocator.dart';
import 'package:geosave/app/common/entity/local_entity.dart';

abstract interface class MapDataSourceImpl {
  Future<List<LocalEntity>> getLocaisSalvos();
  Future<Position> getGeoLocalizacaoUsuario();
}
