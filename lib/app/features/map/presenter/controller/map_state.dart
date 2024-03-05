import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/common/error/failure.dart';

abstract base class MapState {}

final class MapIntial extends MapState {}

final class MapCarregando extends MapState {}

final class MapSucesso extends MapState {
  double lat;
  double lon;
  List<LocalEntity> local;

  MapSucesso(
    this.lat,
    this.lon,
    this.local,
  );
}

final class MapErro extends MapState {
  Failure erroMap;

  MapErro(this.erroMap);
}

final class ListaLocaisError extends MapState {
  Failure erroLocal;

  ListaLocaisError(this.erroLocal);
}
