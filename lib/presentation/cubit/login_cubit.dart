import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final GetLoginUseCase getLoginUseCase;
  LoginCubit({required this.getLoginUseCase}) : super(LoginInitial());

  Future<void> performFirebaseUserLogin(String email, String password) async {
    try {
      emit(LoginLoading());
      final loginData =
          await getLoginUseCase.call(Params(email: email, password: password));
      loginData.fold((l) => emit(LoginFailure(l.errorMsg)), (r) {
        emit(LoginLoaded(user: r));
      });
    } catch (e) {
      LoginFailure(e.toString());
    }
  }
}
