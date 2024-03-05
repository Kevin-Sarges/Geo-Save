// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosave/app/common/colors/colors_app.dart';
import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/common/routes/app_routes.dart';
import 'package:geosave/app/common/widget/appbar_widget.dart';
import 'package:geosave/app/common/widget/text_button_widget.dart';
import 'package:geosave/app/features/local/presenter/full_map_local_screen.dart';
import 'package:geosave/app/features/local/presenter/controller/local_cubit.dart';
import 'package:geosave/app/features/local/presenter/controller/local_state.dart';
import 'package:geosave/app/features/local/presenter/widget/template_row_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geosave/app/features/local/presenter/widget/column_widget.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({
    Key? key,
    required this.local,
  }) : super(key: key);

  final LocalEntity local;

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final LocalCubit _cubit = GetIt.I.get<LocalCubit>();
  late GoogleMapController _controller;
  final _controllerText = TextEditingController();
  bool _clickButton = false;
  bool _clickUpdate = false;

  void _onCreatedMap(GoogleMapController controller) {
    _controller = controller;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _navigatorFullMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullMapLocalScreen(
          lat: widget.local.lat,
          lon: widget.local.lon,
        ),
      ),
    );
  }

  void _navigateToMapScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.map,
      (_) => false,
    );
  }

  void _deleteLocal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deletar"),
        content: const Text("Você deseja deletar esse local?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () {
              _cubit.delete(widget.local.id);

              setState(() {
                _clickButton = true;
              });
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }

  void _updateNomeLocal() {
    _cubit.update(
      widget.local.id,
      _controllerText.text,
    );

    setState(() {
      _clickUpdate = false;
      widget.local.nomeLocal = _controllerText.text;
    });
  }

  void _editNome() {
    setState(() {
      _clickUpdate = true;
      _controllerText.text = widget.local.nomeLocal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Local",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: AppBarWidget(
          onPressed: () {
            Navigator.popAndPushNamed(context, AppRoutes.list);
          },
        ),
      ),
      body: SafeArea(
        child: BlocListener<LocalCubit, LocalState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is LocalErro) {
              _showSnackBar('Erro ao deletar o local 🤔');
            }

            if (state is LocalSucesso) {
              _showSnackBar('Local deletado com sucesso 🙂');
              _navigateToMapScreen();
            }

            if (state is UpdateLocalNome) {
              _showSnackBar('Nome do Local Atualizado');
            }
          },
          child: SingleChildScrollView(
            child:
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        _clickUpdate
                            ? TemplateRowWidget(
                                widget: [
                                  Expanded(
                                    child: TextField(
                                      controller: _controllerText,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _clickUpdate = false;
                                        _controllerText.text = '';
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: ColorsApp.red100,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _updateNomeLocal();
                                    },
                                    icon: const Icon(
                                      Icons.send_rounded,
                                      color: ColorsApp.green150,
                                    ),
                                  ),
                                ],
                              )
                            : TemplateRowWidget(
                                widget: [
                                  Text(
                                    widget.local.nomeLocal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _editNome();
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                        const Divider(),
                      ],
                    ),
                    TemplateRowWidget(
                      widget: [
                        const Text(
                          'Local no Mapa: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButtonWidget(
                          onPressed: () {
                            _navigatorFullMap();
                          },
                          text: 'Ver mapa completo',
                        )
                      ],
                    ),
                    SizedBox(
                      height: 245,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            widget.local.lat,
                            widget.local.lon,
                          ),
                          zoom: 18,
                        ),
                        onMapCreated: _onCreatedMap,
                        markers: {
                          Marker(
                            markerId: MarkerId(widget.local.nomeLocal),
                            position: LatLng(
                              widget.local.lat,
                              widget.local.lon,
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen,
                            ),
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TemplateRowWidget(
                      widget: [
                        ColumnWidget(
                          title: 'Latitude:',
                          subtitle: widget.local.lat.toString(),
                        ),
                        ColumnWidget(
                          title: 'Longitude:',
                          subtitle: widget.local.lon.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _clickButton ? null : _deleteLocal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.red100,
                      ),
                      child: _clickButton
                          ? const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                color: ColorsApp.white100,
                              ),
                            )
                          : const Text(
                              'Deletar local',
                              style: TextStyle(
                                color: ColorsApp.white100,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
}
