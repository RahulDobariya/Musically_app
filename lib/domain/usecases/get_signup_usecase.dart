import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/domain/repositories/get_music_respository.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';

class GetSignupUseCase implements UseCase<User, Params> {
  final GetMusicRespository getMusicRespository;

  GetSignupUseCase({required this.getMusicRespository});

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await getMusicRespository.firebaseSignup(
        params.email, params.password);
  }

}

class Params extends Equatable {
  final String email;
  final String password;

  const Params({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
