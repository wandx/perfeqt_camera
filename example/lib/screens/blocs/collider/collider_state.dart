part of 'collider_bloc.dart';

abstract class ColliderState extends Equatable {
  const ColliderState();
}

class ColliderInitial extends ColliderState {
  @override
  List<Object> get props => [];
}

class ColliderLoading extends ColliderState {
  @override
  List<Object> get props => [];
}

class Contain extends ColliderState {
  @override
  List<Object> get props => [];
}

class NotContain extends ColliderState {
  @override
  List<Object> get props => [];
}