// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosave/app/common/colors/colors_app.dart';
import 'package:geosave/app/common/helpers/open_database.dart';
import 'package:geosave/app/common/model/local_model.dart';
import 'package:geosave/app/common/routes/app_routes.dart';
import 'package:geosave/app/common/widget/appbar_widget.dart';
import 'package:geosave/app/features/save/presenter/controller/save_cubit.dart';
import 'package:geosave/app/features/save/presenter/controller/save_state.dart';
import 'package:geosave/app/features/save/presenter/widget/input_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class SaveScreen extends StatefulWidget {
  SaveScreen({
    Key? key,
    required this.lat,
    required this.lon,
  }) : super(key: key);

  double lat;
  double lon;

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _cubit = GetIt.I.get<SaveCubit>();
  final _controllerTextNomeLocal = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _clickButton = false;
  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salvar Localização',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: AppBarWidget(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.map,
              (_) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocListener<SaveCubit, SaveState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is SaveErro) {
              setState(() {
                _clickButton = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erro ao salvar o local 🤔 '),
                ),
              );

              return;
            }

            if (state is SaveSucesso) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Local salvo com sucesso 🙂'),
                ),
              );

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.list,
                (_) => false,
              );
              return;
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nome do Local',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          InputWidget(
                            controller: _controllerTextNomeLocal,
                            hintText: 'Ex: Escola',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _clickButton
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _cubit.saveLocal(
                                  LocalModel(
                                    id: uuid.v4(),
                                    lat: widget.lat,
                                    lon: widget.lon,
                                    nomeLocal: _controllerTextNomeLocal.text,
                                  ),
                                );

                                setState(() {
                                  _clickButton = true;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.green100,
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
                              'Salvar',
                              style: TextStyle(
                                color: ColorsApp.white100,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
