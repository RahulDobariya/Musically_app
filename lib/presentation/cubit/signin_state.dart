part of 'signin_cubit.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

class SigninInitial extends SigninState {
  @override
  List<Object> get props => [];
}

class SigninLoading extends SigninState {
  @override
  List<Object> get props => [];
}

class SigninLoaded extends SigninState {
  final User user;

  const SigninLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class SigninFailure extends SigninState {
  final String errorMsg;

  const SigninFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
