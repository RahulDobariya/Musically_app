import 'package:dartz/dartz.dart';
import 'package:music_app/core/errors/failure.dart';
import 'package:music_app/core/usecases/usecase.dart';
import 'package:music_app/data/models/songs.dart';
import 'package:music_app/domain/repositories/get_music_respository.dart';

class GetSongUseCase implements UseCase<List<Songs>, NoParams> {
  final GetMusicRespository getMusicRespository;

  GetSongUseCase({required this.getMusicRespository});
  @override
  Future<Either<Failure, List<Songs>>> call(NoParams noParams) async {
    return await getMusicRespository.getSongList();
  }
}
