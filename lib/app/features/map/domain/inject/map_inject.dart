import 'package:geosave/app/features/map/domain/datasource/imap_datasourcer.dart';
import 'package:geosave/app/features/map/domain/repository/imap_repository.dart';
import 'package:geosave/app/features/map/domain/usecase/get_geo_localizacao_usuario_usecase.dart';
import 'package:geosave/app/features/map/domain/usecase/get_locais_salvos_usecase.dart';
import 'package:geosave/app/features/map/infra/datasource/map_datasource.dart';
import 'package:geosave/app/features/map/infra/repository/map_repository.dart';
import 'package:geosave/app/features/map/presenter/controller/map_cubit.dart';
import 'package:get_it/get_it.dart';

class MapInjectDependecy {
  static void init(GetIt getIt) {
    getIt.registerFactory<MapDataSourceImpl>(() => MapDataSource());

    getIt.registerFactory<MapRepositoryImpl>(
        () => MapRepository(dataSource: getIt()));

    getIt.registerFactory<GetGeoLocalizacaoUsuarioUseCase>(
      () => GetGeoLocalizacaoUsuarioUseCase(repository: getIt()),
    );

    getIt.registerFactory<GetLocaisSalvosUseCase>(
      () => GetLocaisSalvosUseCase(repositoryImpl: getIt()),
    );

    getIt.registerFactory(
      () => MapCubit(
        getGeoLocalizacaoUsuarioUseCase: getIt(),
        getLocaisSalvosUseCase: getIt(),
      ),
    );
  }
}
