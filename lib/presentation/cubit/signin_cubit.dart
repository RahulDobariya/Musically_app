import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/domain/usecases/get_signup_usecase.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final GetSignupUseCase getSigninUseCase;
  SigninCubit({required this.getSigninUseCase}) : super(SigninInitial());

  Future<void> performFirebaseUserSignin(String email, String password) async {
    try {
      emit(SigninLoading());
      final signinData =
          await getSigninUseCase.call(Params(email: email, password: password));
      signinData.fold((l) => emit(SigninFailure(l.errorMsg)), (r) {
        emit(SigninLoaded(user: r));
      });
    } catch (e) {
      SigninFailure(e.toString());
    }
  }
}
