import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/data/models/songs.dart';
import '../../core/errors/failure.dart';

abstract class GetMusicRespository {
  Future<Either<Failure, User>> firebaseLogin(String email, String password);
  Future<Either<Failure, User>> firebaseSignup(String email, String password);
  Future<Either<Failure, List<Songs>>> getSongList();
  
}
