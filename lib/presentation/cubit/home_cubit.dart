import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/core/usecases/usecase.dart';
import 'package:music_app/data/models/songs.dart';
import 'package:music_app/domain/usecases/get_songs_usecase.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetSongUseCase getSongUseCase;
  HomeCubit({required this.getSongUseCase}) : super(HomeInitial()) {
    getSongs();
  }

  Future<void> getSongs() async {
    try {
      emit(HomeLoading());
      await Future.delayed(const Duration(seconds: 1));
      final songData = await getSongUseCase.call(NoParams());
      songData.fold((l) => emit(HomeFailure(l.errorMsg)), (r) {
        emit(HomeLoaded(songs: r));
      });
    } catch (e) {
      HomeFailure(e.toString());
    }
  }
}
