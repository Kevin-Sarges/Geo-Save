import 'package:geolocator/geolocator.dart';
import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/common/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:geosave/app/features/map/domain/datasource/imap_datasourcer.dart';
import 'package:geosave/app/features/map/domain/repository/imap_repository.dart';

class MapRepository implements MapRepositoryImpl {
  final MapDataSourceImpl dataSource;

  MapRepository({required this.dataSource});

  @override
  Future<Either<Failure, Position>> getGeoLocalizacaoUsuario() async {
    try {
      final result = await dataSource.getGeoLocalizacaoUsuario();

      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<LocalEntity>>> getLocaisSalvos() async {
    try {
      final result = await dataSource.getLocaisSalvos();

      return Right(result);
    } on Failure catch(e) {
      return Left(e);
    }
  }
}
