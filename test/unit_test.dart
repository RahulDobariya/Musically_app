import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:music_app/core/errors/failure.dart';
import 'package:music_app/domain/usecases/get_login_usecase.dart';
import 'package:music_app/presentation/cubit/login_cubit.dart';

class MockGetLoginUseCase extends Mock implements GetLoginUseCase {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  late LoginCubit loginCubit;
  late MockGetLoginUseCase mockGetLoginUseCase;

  setUp(() {
    mockGetLoginUseCase = MockGetLoginUseCase();
    loginCubit = LoginCubit(getLoginUseCase: mockGetLoginUseCase);
  });

  group('LoginCubit', () {
    final email = 'test@example.com';
    final password = 'password';

    test('initial state is LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    test(
        'performFirebaseUserLogin emits LoginLoading and LoginLoaded on success',
        () async {
      final user = FirebaseAuth.instance.currentUser;

      when(mockGetLoginUseCase.call(Params(email: email, password: password)))
          .thenAnswer((_) async => Right(user!));

      expectLater(loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginLoaded>()]));

      await loginCubit.performFirebaseUserLogin(email, password);
    });

    test(
        'performFirebaseUserLogin emits LoginLoading and LoginFailure on failure',
        () async {
      final failure = ServerFailure('Error');

      when(mockGetLoginUseCase.call(Params(email: email, password: password)))
          .thenAnswer((_) async => Left(failure));

      expectLater(loginCubit.stream,
          emitsInOrder([isA<LoginLoading>(), isA<LoginFailure>()]));

      await loginCubit.performFirebaseUserLogin(email, password);
    });
  });
}
