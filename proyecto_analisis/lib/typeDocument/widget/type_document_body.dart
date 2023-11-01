import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/typeDocument/bloc/type_document_bloc.dart';
import 'package:proyecto_analisis/typeDocument/model/type_document_response.dart'
    as model;

import '../../common/loader/loader.dart';

class TypeDocumentBody extends StatefulWidget {
  const TypeDocumentBody({Key? key}) : super(key: key);

  @override
  State<TypeDocumentBody> createState() => _TypeDocumentBodyState();
}

class _TypeDocumentBodyState extends State<TypeDocumentBody>
    with ErrorHandling {
  List<model.TypeDocument> typeDocumentList = [];
  late TypeDocumentBloc bloc;
  late String name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<TypeDocumentBloc>().add(
          GetTypeDocument(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<TypeDocumentBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TypeDocumentBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is TypeDocumentSuccess) {
          setState(() {
            typeDocumentList = state.success.typeDocuments;
          });
        } else if (state is TypeDocumentEditSuccess) {
          context.read<TypeDocumentBloc>().add(
                GetTypeDocument(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el tipo de documento con éxito',
              ),
            ),
          );
        } else if (state is TypeDocumentCreateSuccess) {
          context.read<TypeDocumentBloc>().add(
                GetTypeDocument(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el tipo de documento con éxito',
              ),
            ),
          );
        } else if (state is TypeDocumentDeleteSuccess) {
          context.read<TypeDocumentBloc>().add(
                GetTypeDocument(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el tipo de documento con éxito',
              ),
            ),
          );
        } else if (state is TypeDocumentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error!,
              ),
            ),
          );
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: secondaryColor,
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 30,
                      ),
                      child: const Text(
                        'Tipo de Documento',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _nameController.text = '';
                        });

                        _dialogCreate();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: bgColor,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                          ),
                          child: ListView.builder(
                            itemCount: typeDocumentList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.table_chart,
                                        color: Colors.purpleAccent,
                                      ),
                                      title: Text(
                                        'Nombre:   ${typeDocumentList[index].nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _nameController.text =
                                                      typeDocumentList[index]
                                                          .nombre;
                                                });
                                                _dialogEdit(
                                                  typeDocumentList[index],
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                bloc.add(
                                                  DeleteTypeDocument(
                                                    idTypeDocument:
                                                        typeDocumentList[index]
                                                            .idTipoDocumento,
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<TypeDocumentBloc, BaseState>(
            builder: (context, state) {
              if (state is TypeDocumentInProgress) {
                return const Loader();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  _dialogEdit(
    final model.TypeDocument typeDocument,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Tipo de Documento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: 'Nombre del Tipo de Documento'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Guardar'),
                  onPressed: () {
                    String typeDocumentName = _nameController.text;
                    bloc.add(
                      EditTypeDocument(
                        nombre: typeDocumentName,
                        idTypeDocument: int.parse(typeDocument.idTipoDocumento),
                        idUsuarioModificacion: name,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  _dialogCreate() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: Text('Crear Tipo de Documento'),
            content: IntrinsicHeight(
              child: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Nombre del Tipo de Documento'),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Crear'),
                onPressed: () {
                  String typeDocumentName = _nameController.text;
                  bloc.add(
                    CreateTypeDocument(
                      nombre: typeDocumentName,
                      idUsuarioModificacion: name,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  _getName() async {
    final UserRepository userRepository = UserRepository();
    final name = await userRepository.getUser();
    setState(() {
      this.name = name;
    });
  }
}
