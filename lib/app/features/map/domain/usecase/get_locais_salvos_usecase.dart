import 'package:dartz/dartz.dart';
import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/common/error/failure.dart';
import 'package:geosave/app/features/map/domain/repository/imap_repository.dart';

class GetLocaisSalvosUseCase {
  final MapRepositoryImpl repositoryImpl;

  GetLocaisSalvosUseCase({required this.repositoryImpl});

  Future<Either<Failure, List<LocalEntity>>> call() async {
    return await repositoryImpl.getLocaisSalvos();
  }
}