import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:dartz/dartz.dart';
import 'package:music_app/data/models/songs.dart';

import '../../../core/errors/failure.dart';

abstract class MusicRemoteDataSource {
  Future<Either<Failure, User>> firebaseLogin(String email, String password);
  Future<Either<Failure, User>> firebaseSignup(String email, String password);
  // Future<Either<Failure, OrderBook>> getSearchCryptoOrderList(String name);
  Future<Either<Failure, List<Songs>>> getSongList();
}

class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final http.Client client;

  MusicRemoteDataSourceImpl({required this.client});
  @override
  Future<Either<Failure, User>> firebaseLogin(
      String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Right(userCredential.user!);
    } catch (error) {
      if (error is FirebaseAuthException) {
        return Left(ServerFailure(error.message.toString()));
      } else {
        return const Left(CacheFailure('Unexpected error occurred'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> firebaseSignup(
      String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return Right(userCredential.user!);
    } catch (error) {
      if (error is FirebaseAuthException) {
        return Left(ServerFailure(error.message.toString()));
      } else {
        return const Left(CacheFailure('Unexpected error occurred'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Songs>>> getSongList() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<Songs> songsList =
          jsonList.map((json) => Songs.fromJson(json)).toList();

      return Right(songsList);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
