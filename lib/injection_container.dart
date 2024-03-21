import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/data/datasource/music_remote_data_source.dart';
import 'package:music_app/data/repositories/get_music_respository_impl.dart';
import 'package:music_app/domain/repositories/get_music_respository.dart';
import 'package:music_app/domain/usecases/get_login_usecase.dart';
import 'package:music_app/domain/usecases/get_signup_usecase.dart';
import 'package:music_app/domain/usecases/get_songs_usecase.dart';
import 'package:music_app/presentation/cubit/home_cubit.dart';
import 'package:music_app/presentation/cubit/login_cubit.dart';
import 'package:music_app/presentation/cubit/signin_cubit.dart';
import 'package:music_app/presentation/cubit/tab_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
//dataSource
  sl.registerLazySingleton<MusicRemoteDataSource>(
      () => MusicRemoteDataSourceImpl(client: sl()));

//repository
  sl.registerLazySingleton<GetMusicRespository>(
      () => GetMusicRepositoryImpl(musicRemoteDataSource: sl()));

//usecase
  sl.registerFactory<GetLoginUseCase>(
      () => GetLoginUseCase(getMusicRespository: sl()));
  sl.registerFactory<GetSignupUseCase>(
      () => GetSignupUseCase(getMusicRespository: sl()));
  sl.registerFactory<GetSongUseCase>(
      () => GetSongUseCase(getMusicRespository: sl()));

//cubit
  sl.registerFactory<HomeCubit>(() => HomeCubit(getSongUseCase: sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(getLoginUseCase: sl()));
  sl.registerFactory<SigninCubit>(() => SigninCubit(getSigninUseCase: sl()));
  sl.registerFactory<TabCubit>(() => TabCubit());

//http
  sl.registerLazySingleton(() => http.Client());
}
