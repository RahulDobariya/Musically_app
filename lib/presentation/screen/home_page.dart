import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_app/presentation/cubit/home_cubit.dart';
import 'package:music_app/presentation/cubit/tab_cubit.dart';
import 'package:music_app/presentation/screen/details_page.dart';
import 'package:music_app/presentation/screen/signin_signup_page.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: const HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  void logout(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login/signup screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  SigninSignupPage())); // Replace '/login' with your login screen route
    } catch (e) {
      print('Error logging out: $e');
      // Handle logout error
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabCubit>(
      create: (context) => sl<TabCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Musically',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => logout(context),
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is HomeLoaded) {
              final data = state.songs;
              return HomeBody(
                songs: data,
              );
            } else if (state is HomeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMsg),
                ),
              );
            }
            return const HomeBody(songs: []);
          },
        ),
        bottomNavigationBar: BlocBuilder<TabCubit, TabState>(
          builder: (context, state) {
            return SalomonBottomBar(
              currentIndex: state.index,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.read<TabCubit>().updateTab(TabState.home);
                    break;
                  case 1:
                    context.read<TabCubit>().updateTab(TabState.likes);
                    break;
                  case 2:
                    context.read<TabCubit>().updateTab(TabState.search);
                    break;
                  case 3:
                    context.read<TabCubit>().updateTab(TabState.profile);
                    break;
                }
              },
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: const Icon(CupertinoIcons.home),
                  title: const Text("Home"),
                  selectedColor: Colors.purple,
                  unselectedColor: Colors.grey,
                ),

                /// Likes
                SalomonBottomBarItem(
                  icon: const Icon(CupertinoIcons.heart),
                  title: const Text("Likes"),
                  unselectedColor: Colors.grey,
                  selectedColor: Colors.pink,
                ),

                /// Search
                SalomonBottomBarItem(
                  icon: const Icon(CupertinoIcons.search),
                  unselectedColor: Colors.grey,
                  title: const Text("Search"),
                  selectedColor: Colors.orange,
                ),

                /// Profile
                SalomonBottomBarItem(
                  icon: const Icon(CupertinoIcons.person),
                  title: const Text("Profile"),
                  unselectedColor: Colors.grey,
                  selectedColor: Colors.teal,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.songs,
  });
  final List songs;

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        const Heading(
          name: 'Top hit',
        ),
        MyListView(songs: songs),
        const Heading(
          name: 'Daily Mix',
        ),
        MyListView(songs: songs),
        const Heading(
          name: 'Focus',
        ),
        MyListView(songs: songs),
      ],
    );
  }
}

class MyListView extends StatelessWidget {
  const MyListView({
    super.key,
    required this.songs,
  });
  final List songs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 120,
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 10),
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: songs.length,
          itemBuilder: (context, id) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailsPage(
                                  songs: songs[id],
                                  id: id,
                                  songList: songs,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(songs[id].albumImage),
                            fit: BoxFit.cover),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    songs[id].songName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}
