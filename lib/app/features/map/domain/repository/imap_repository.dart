import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/common/error/failure.dart';

abstract interface class MapRepositoryImpl {
  Future<Either<Failure, List<LocalEntity>>> getLocaisSalvos();
  Future<Either<Failure, Position>> getGeoLocalizacaoUsuario();
}
