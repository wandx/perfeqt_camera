part of 'collider_bloc.dart';

abstract class ColliderEvent extends Equatable {
  const ColliderEvent();
}

class CheckCollideStatus extends ColliderEvent {
  @override
  List<Object?> get props => [];
}
