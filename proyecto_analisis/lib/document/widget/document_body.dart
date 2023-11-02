import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/common/bloc/mixin/error_handling.dart';
import 'package:proyecto_analisis/document/bloc/document_bloc.dart';
import 'package:proyecto_analisis/document/model/document_response.dart'
    as model;
import 'package:proyecto_analisis/person/model/person.dart' as model;
import 'package:proyecto_analisis/repository/user_repository.dart';
import 'package:proyecto_analisis/resources/constants.dart';
import 'package:proyecto_analisis/typeDocument/model/type_document_response.dart'
    as model;

import '../../common/loader/loader.dart';

class DocumentBody extends StatefulWidget {
  const DocumentBody({Key? key}) : super(key: key);

  @override
  State<DocumentBody> createState() => _DocumentBodyState();
}

class _DocumentBodyState extends State<DocumentBody> with ErrorHandling {
  List<model.Document> documentList = [];
  late DocumentBloc bloc;
  late String name;
  final TextEditingController _noDocumentController = TextEditingController();

  List<model.Person> person = [];
  late model.Person _selectedPerson;
  List<model.TypeDocument> typeDocument = [];
  late model.TypeDocument _selectedTypeDocument;

  @override
  void initState() {
    super.initState();
    _getName();
    context.read<DocumentBloc>().add(
          GetDocument(),
        );
    context.read<DocumentBloc>().add(
          GetTypeDocument(),
        );
    context.read<DocumentBloc>().add(
          Person(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<DocumentBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentBloc, BaseState>(
      listener: (context, state) {
        verifyServerError(state);
        if (state is DocumentSuccess) {
          setState(() {
            documentList = state.success.documents;
          });
        } else if (state is PersonSuccess) {
          setState(() {
            person = state.personResponse.users;
            _selectedPerson = state.personResponse.users.first;
          });
        } else if (state is TypeDocumentSuccess) {
          setState(() {
            typeDocument = state.success.typeDocuments;
            _selectedTypeDocument = state.success.typeDocuments.first;
          });
        } else if (state is DocumentEditSuccess) {
          context.read<DocumentBloc>().add(
                GetDocument(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha actualizado el documento con éxito',
              ),
            ),
          );
        } else if (state is DocumentCreateSuccess) {
          context.read<DocumentBloc>().add(
                GetDocument(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha creado el documento con éxito',
              ),
            ),
          );
        } else if (state is DocumentDeleteSuccess) {
          context.read<DocumentBloc>().add(
                GetDocument(),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Se ha eliminado el documento con éxito',
              ),
            ),
          );
        } else if (state is DocumentError) {
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
                        'Documento',
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
                          _noDocumentController.text = '';
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
                            itemCount: documentList.length,
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
                                      subtitle: Text(
                                        'Persona: ${person.firstWhere(
                                              (objeto) =>
                                                  objeto.idPersona ==
                                                  documentList[index].idPersona,
                                            ).nombre} ${person.firstWhere(
                                              (objeto) =>
                                                  objeto.idPersona ==
                                                  documentList[index].idPersona,
                                            ).apellido}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      title: Text(
                                        'Numero de documento: ${documentList[index].noDocumento}',
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
                                                  _noDocumentController.text =
                                                      documentList[index]
                                                          .noDocumento;
                                                  _selectedTypeDocument =
                                                      typeDocument.firstWhere(
                                                    (objeto) =>
                                                        objeto
                                                            .idTipoDocumento ==
                                                        documentList[index]
                                                            .idTipoDocumento,
                                                  );
                                                  _selectedPerson =
                                                      person.firstWhere(
                                                    (objeto) =>
                                                        objeto.idPersona ==
                                                        documentList[index]
                                                            .idPersona,
                                                  );
                                                });
                                                _dialogEdit(
                                                  documentList[index],
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
                                                  DeleteDocument(
                                                    idDocument: int.parse(
                                                        documentList[index]
                                                            .idTipoDocumento),
                                                    noDocument:
                                                        documentList[index]
                                                            .noDocumento,
                                                    idPersona: int.parse(
                                                        documentList[index]
                                                            .idPersona),
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
          BlocBuilder<DocumentBloc, BaseState>(
            builder: (context, state) {
              if (state is DocumentInProgress) {
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
    final model.Document document,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editar Documento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _noDocumentController,
                    decoration:
                        InputDecoration(labelText: 'Numero del Documento'),
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
                    String documentName = _noDocumentController.text;
                    bloc.add(
                      EditDocument(
                        idPersona: int.parse(document.idPersona),
                        noDocument: document.noDocumento,
                        idDocument: int.parse(document.idTipoDocumento),
                        usuarioModificacion: name,
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
            title: Text('Crear Documento'),
            content: IntrinsicHeight(
              child: Container(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _noDocumentController,
                      decoration:
                          InputDecoration(labelText: 'Numero del Documento'),
                    ),
                    DropdownButton2<model.Person>(
                      value: _selectedPerson,
                      items: person.map((role) {
                        return DropdownMenuItem<model.Person>(
                          value: role,
                          child: Text(role.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPerson = value!;
                        });
                      },
                    ),
                    DropdownButton2<model.TypeDocument>(
                      value: _selectedTypeDocument,
                      items: typeDocument.map((role) {
                        return DropdownMenuItem<model.TypeDocument>(
                          value: role,
                          child: Text(role.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTypeDocument = value!;
                        });
                      },
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
                  String documentName = _noDocumentController.text;
                  bloc.add(
                    CreateDocument(
                      idPersona: int.parse(_selectedPerson.idPersona),
                      noDocument: _noDocumentController.text,
                      idDocument:
                          int.parse(_selectedTypeDocument.idTipoDocumento),
                      usuarioModificacion: name,
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
