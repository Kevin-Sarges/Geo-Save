import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosave/app/features/map/domain/usecase/get_geo_localizacao_usuario_usecase.dart';
import 'package:geosave/app/features/map/domain/usecase/get_locais_salvos_usecase.dart';
import 'package:geosave/app/features/map/presenter/controller/map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({
    required this.getGeoLocalizacaoUsuarioUseCase,
    required this.getLocaisSalvosUseCase,
  }) : super(MapIntial());

  final GetGeoLocalizacaoUsuarioUseCase getGeoLocalizacaoUsuarioUseCase;
  final GetLocaisSalvosUseCase getLocaisSalvosUseCase;

  Future<void> localizacaoUsuario() async {
    emit(MapCarregando());

    final localUser = await getGeoLocalizacaoUsuarioUseCase();
    final localSalvo = await getLocaisSalvosUseCase();

    localUser.fold(
      (erroMap) => emit(MapErro(erroMap)),
      (sucesso) => localSalvo.fold(
        (erroLocal) => emit(ListaLocaisError(erroLocal)),
        (local) => emit(MapSucesso(
          sucesso.latitude,
          sucesso.longitude,
          local,
        )),
      ),
    );
  }
}
