import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'collider_event.dart';

part 'collider_state.dart';

class ColliderBloc extends Bloc<ColliderEvent, ColliderState> {
  ColliderBloc() : super(ColliderInitial()) {
    on<ColliderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final List<Offset> anchor = [];
  final List<Offset> strip = [];
}
