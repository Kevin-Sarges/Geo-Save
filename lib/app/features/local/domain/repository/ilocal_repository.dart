import 'package:dartz/dartz.dart';
import 'package:geosave/app/common/error/failure.dart';

abstract interface class LocalRepositoryImpl {
  Future<Either<Failure, void>> deleteLocal(String id);
  Future<Either<Failure, void>> updateNome(String id, String novoNome);
}
