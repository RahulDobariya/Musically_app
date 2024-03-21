import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/injection_container.dart';
import 'package:music_app/presentation/cubit/login_cubit.dart';
import 'package:music_app/presentation/cubit/signin_cubit.dart';
import 'package:music_app/presentation/screen/home_page.dart';
import 'package:music_app/presentation/widgets/my_button.dart';
import 'package:music_app/presentation/widgets/my_text_field.dart';

class FormPage extends StatelessWidget {
  FormPage({super.key, required this.type});
  final bool type;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _navigateToHome(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    });
  }

  _showMeError(error, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = type ? 'Sign in' : 'Sign up';
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider<SigninCubit>(
          create: (context) => sl<SigninCubit>(),
        ),
      ],
      child: type
          ? BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is LoginLoaded) {
                  _navigateToHome(context);
                } else if (state is LoginFailure) {
                  _showMeError(state.errorMsg, context);
                }
                return _FormData(
                    name: name,
                    emailController: emailController,
                    passwordController: passwordController,
                    type: type);
              },
            )
          : BlocBuilder<SigninCubit, SigninState>(
              builder: (context, state) {
                if (state is SigninLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is SigninLoaded) {
                  _navigateToHome(context);
                } else if (state is SigninFailure) {
                  _showMeError(state.errorMsg, context);
                }
                return _FormData(
                  name: name,
                  emailController: emailController,
                  passwordController: passwordController,
                  type: type,
                );
              },
            ),
    ));
  }
}

class _FormData extends StatelessWidget {
  const _FormData({
    required this.name,
    required this.emailController,
    required this.passwordController,
    required this.type,
  });

  final String name;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amber,
                  Colors.amber.shade100,
                ],
              ),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
          ),
        ),
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                        hint: 'Enter your email', controller: emailController),
                    MyTextField(
                        hint: 'Enter your paasword',
                        controller: passwordController),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MyButton(
                    fColor: Colors.black,
                    bColor: Colors.amber.shade300,
                    name: name,
                    onPressed: () {
                      type
                          ? BlocProvider.of<LoginCubit>(context)
                              .performFirebaseUserLogin(
                                  emailController.text, passwordController.text)
                          : BlocProvider.of<SigninCubit>(context)
                              .performFirebaseUserSignin(emailController.text,
                                  passwordController.text);
                    },
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ))
      ],
    );
  }
}
