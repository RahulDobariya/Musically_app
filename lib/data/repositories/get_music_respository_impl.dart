import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/core/errors/failure.dart';
import 'package:music_app/data/datasource/music_remote_data_source.dart';
import 'package:music_app/data/models/songs.dart';
import 'package:music_app/domain/repositories/get_music_respository.dart';

class GetMusicRepositoryImpl implements GetMusicRespository {
  final MusicRemoteDataSource musicRemoteDataSource;

  GetMusicRepositoryImpl({required this.musicRemoteDataSource});
  
  @override
  Future<Either<Failure, User>> firebaseLogin(
      String email, String password) async {
    return await musicRemoteDataSource.firebaseLogin(email, password);
  }

  @override
  Future<Either<Failure, User>> firebaseSignup(
      String email, String password) async {
    return await musicRemoteDataSource.firebaseSignup(email, password);
  }

  @override
  Future<Either<Failure, List<Songs>>> getSongList() async {
    return await musicRemoteDataSource.getSongList();
  }
}
