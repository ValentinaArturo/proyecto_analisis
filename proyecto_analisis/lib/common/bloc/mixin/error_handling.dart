import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_analisis/common/bloc/base_state.dart';

mixin ErrorHandling on Diagnosticable {
  BuildContext get context;

  void verifyServerError(
    final BaseState state,
  ) {}
}
