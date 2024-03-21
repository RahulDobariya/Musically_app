import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/domain/repositories/get_music_respository.dart';

import '../../core/errors/failure.dart';
import '../../core/usecases/usecase.dart';

class GetLoginUseCase implements UseCase<User, Params> {
  final GetMusicRespository getMusicRespository;

  GetLoginUseCase({required this.getMusicRespository});

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await getMusicRespository.firebaseLogin(
        params.email, params.password);
  }

  // @override
  // Future<Either<Failure, OrderBook>> call(params) async {
  //   return await getCryptoRespository.getSearchCryptoOrderList(params.name);
  // }
}

class Params extends Equatable {
  final String email;
  final String password;

  const Params({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
