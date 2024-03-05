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
import 'package:geosave/app/features/map/presenter/widgets/template_modal_widget.dart';
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

  void _modalBottomSheet(
    BuildContext context,
    double latSub,
    double lonSub,
    double w,
    double h,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: w,
        height: h * 0.3,
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
                  subtitle: latSub.toString(),
                ),
                TextWidget(
                  title: 'Longitude: ',
                  subtitle: lonSub.toString(),
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
                          lat: latSub,
                          lon: lonSub,
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

                    Navigator.pop(context);
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
    );
  }

  void modalMarker({
    required String name,
    required double lat,
    required double lon,
    required w,
    required h,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: w,
        height: h * 0.2,
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
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TemplateModalWidget(lon: lon, lat: lat)
          ],
        ),
      ),
    );
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
                child: Text(state.erroMap.errorMessage),
              );
            }

            if (state is ListaLocaisError) {
              return Center(
                child: Text(state.erroLocal.errorMessage),
              );
            }

            if (state is MapSucesso) {
              final markerCoordinates = state.local;

              return Scaffold(
                body: GoogleMap(
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      state.lat,
                      state.lon,
                    ),
                    zoom: 14,
                  ),
                  markers: Set<Marker>.from(markerCoordinates.map((local) {
                    return Marker(
                      markerId: MarkerId(local.id),
                      position: LatLng(local.lat, local.lon),
                      flat: true,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      ),
                      onTap: () => modalMarker(
                        name: local.nomeLocal,
                        lat: local.lat,
                        lon: local.lon,
                        w: width,
                        h: height,
                      ),
                    );
                  })),
                  onMapCreated: _onCreatedMap,
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    _modalBottomSheet(
                      context,
                      state.lat,
                      state.lon,
                      width,
                      height,
                    );
                  },
                  backgroundColor: ColorsApp.green100,
                  label: const Text(
                    "Local",
                    style: TextStyle(
                      color: ColorsApp.white100,
                    ),
                  ),
                  icon: const Icon(
                    Icons.pin_drop,
                    color: ColorsApp.white100,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.startFloat,
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
