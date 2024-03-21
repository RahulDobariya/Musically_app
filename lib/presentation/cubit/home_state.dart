part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final List<Songs> songs;

  const HomeLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}

class HomeFailure extends HomeState {
  final String errorMsg;

  const HomeFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
