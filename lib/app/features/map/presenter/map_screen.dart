// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosave/app/common/colors/colors_app.dart';
import 'package:geosave/app/common/helpers/debouncer_helpers.dart';
import 'package:geosave/app/common/routes/app_routes.dart';
import 'package:geosave/app/common/widget/loading_widget.dart';
import 'package:geosave/app/common/widget/text_button_widget.dart';
import 'package:geosave/app/features/map/presenter/controller/map_cubit.dart';
import 'package:geosave/app/features/map/presenter/controller/map_state.dart';
import 'package:geosave/app/features/map/presenter/widgets/button_map_widget.dart';
import 'package:geosave/app/features/map/presenter/widgets/text_widget.dart';
import 'package:geosave/app/features/save/presenter/save_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _cubit = GetIt.I.get<MapCubit>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late GoogleMapController _controller;
  final debouncer = DebouncerHelpers();

  void _onCreatedMap(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  void initState() {
    super.initState();

    _cubit.localizacaoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MapCubit, MapState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state is MapCarregando) {
              return const Center(child: LoadingWidget());
            }

            if (state is MapErro) {
              return Center(
                child: Text(state.erro.errorMessage),
              );
            }

            if (state is MapSucesso) {
              return Scaffold(
                body: Stack(
                  children: [
                    GoogleMap(
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.lat,
                          state.lon,
                        ),
                        zoom: 19,
                      ),
                      onMapCreated: _onCreatedMap,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: width,
                        height: height * 0.3,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 19,
                          vertical: 31,
                        ),
                        decoration: const BoxDecoration(
                          color: ColorsApp.white200,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  title: 'Latitude: ',
                                  subtitle: state.lat.toString(),
                                ),
                                TextWidget(
                                  title: 'Longitude: ',
                                  subtitle: state.lon.toString(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtoMapWidget(
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SaveScreen(
                                          lat: state.lat,
                                          lon: state.lon,
                                        ),
                                      ),
                                    );
                                  },
                                  text: 'Salvar',
                                ),
                                const SizedBox(width: 12),
                                ButtoMapWidget(
                                  onPress: () {
                                    debouncer(() {
                                      _cubit.localizacaoUsuario();
                                      _refreshIndicatorKey.currentState?.show();
                                    });
                                  },
                                  text: 'Atualizar',
                                ),
                              ],
                            ),
                            TextButtonWidget(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.list,
                                );
                              },
                              text: 'Lista de Locais',
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }

            return Container(
              color: ColorsApp.red100,
            );
          },
        ),
      ),
    );
  }
}
