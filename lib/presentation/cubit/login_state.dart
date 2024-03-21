part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  final User user;

  const LoginLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String errorMsg;

  const LoginFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
