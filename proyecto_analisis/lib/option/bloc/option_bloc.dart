import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_bloc.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';
import 'package:proyecto_analisis/menu/model/menu.dart';
import 'package:proyecto_analisis/option/model/option_response.dart';
import 'package:proyecto_analisis/option/service/option_service.dart';
import 'package:proyecto_analisis/repository/user_repository.dart';

part 'option_event.dart';
part 'option_state.dart';

class OptionBloc extends BaseBloc<OptionEvent, BaseState> {
  OptionBloc({
    required this.service,
    required this.userRepository,
  }) : super(OptionInitial()) {
    on<GetOption>(getOptions);
    on<CreateOption>(createOption);
    on<EditOption>(editOption);
    on<DeleteOption>(deleteOption);
    on<Menu>(menu);
  }

  final OptionService service;
  final UserRepository userRepository;
  Future<void> menu(
      Menu event,
      Emitter<BaseState> emit,
      ) async {
    emit(
      OptionInProgress(),
    );

    try {
      final response = await service.menu();

      if (response.statusCode == 401) {
        emit(
          OptionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = MenuResponse.fromJson(
          response.data!,
        );
        emit(
          MenuSuccess(
            menuResponse: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        OptionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
  Future<void> getOptions(
    GetOption event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      OptionInProgress(),
    );

    try {
      final response = await service.getOption();

      if (response.statusCode == 401) {
        emit(
          OptionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        final success = OptionResponse.fromJson(
          response.data!,
        );
        emit(
          OptionSuccess(
            success: success,
          ),
        );
      }
    } on DioError catch (dioError) {
      emit(
        OptionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> createOption(
    CreateOption event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      OptionInProgress(),
    );

    try {
      final response = await service.optionCreate(
        nombre: event.nombre,
        idUsuarioCreacion: event.idUsuarioModificacion,
        idMenu: event.idMenu,
        ordenMenu: event.ordenMenu,
        pagina: event.pagina,
      );

      if (response.statusCode == 401) {
        emit(
          OptionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          OptionCreateSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        OptionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> editOption(
    EditOption event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      OptionInProgress(),
    );

    try {
      final response = await service.optionEdit(
        nombre: event.nombre,
        idUsuarioModificacion: event.idUsuarioModificacion,
        idMenu: event.idMenu,
        ordenMenu: event.ordenMenu,
        pagina: event.pagina,
        idOption: event.idOption,
      );

      if (response.statusCode == 401) {
        emit(
          OptionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          OptionEditSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        OptionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }

  Future<void> deleteOption(
    DeleteOption event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      OptionInProgress(),
    );

    try {
      final response = await service.optionDelete(
        idOpcion: event.idOption,
      );

      if (response.statusCode == 401) {
        emit(
          OptionError(
            response.data['msg'],
          ),
        );
      } else if (response.statusCode == 200) {
        emit(
          OptionDeleteSuccess(),
        );
      }
    } on DioError catch (dioError) {
      emit(
        OptionError(
          dioError.response!.data['msg'],
        ),
      );
    }
  }
}
