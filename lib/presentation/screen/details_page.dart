import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/models/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage(
      {super.key,
      required this.songs,
      required this.id,
      required this.songList});
  final Songs songs;
  final int id;
  final List songList;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  late StreamSubscription _connectionSubscription;
  bool _isOnline = true;
  @override
  void initState() {
    super.initState();
    setAudio();
    currentIndex = widget.id;
    _getUser();
    _checkInternetConnection();

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  Future setAudio() async {
    try {
      String base = 'songs/';
      String url = base + widget.songList[currentIndex].songUrl!;

      await audioPlayer.setSource(AssetSource(url));
      duration = (await audioPlayer.getDuration())!;
      await audioPlayer.pause();
    } catch (e) {
      print('Error setting audio source: $e');
    }
  }

  Future<void> playNext() async {
    if (currentIndex < widget.songList.length - 1) {
      currentIndex++;
      await setAudio();
      await audioPlayer.resume();
    }
  }

  Future<void> playPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
      await setAudio();
      await audioPlayer.resume();
    }
  }

  void _getUser() async {
    _user = _auth.currentUser!;
  }

  void _checkInternetConnection() async {
    _connectionSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
        if (_isOnline) {
          _syncFavoritesWithFirebase();
        }
      });
    });
  }

  Future<void> _syncFavoritesWithFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localFavorites = prefs.getStringList('favorites') ?? [];

    for (String songName in localFavorites) {
      // Check if the song is already added to favorites in Firestore
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection('favorites')
          .doc(songName)
          .get();

      if (!snapshot.exists) {
        // If not, add it to Firestore
        await _firestore
            .collection('users')
            .doc(_user.uid)
            .collection('favorites')
            .doc(songName)
            .set({
          'name': songName,
          // You can also add more song details here
        });
      }
    }

    // Clear local storage
    await prefs.remove('favorites');
  }

  Future<void> _toggleFavorite(Songs song) async {
    if (_isOnline) {
      // Sync favorites with Firestore
      await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection('favorites')
          .doc(song.songName)
          .set({
        'name': song.songName,
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> localFavorites = prefs.getStringList('favorites') ?? [];
      if (localFavorites.contains(song.songName)) {
        localFavorites.remove(song.songName);
      } else {
        localFavorites.add(song.songName.toString());
      }
      await prefs.setStringList('favorites', localFavorites);
    }

    setState(() {}); // Refresh UI
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _toggleFavorite(widget.songList[currentIndex]),
            icon: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_user.uid)
                  .collection('favorites')
                  .doc(widget.songList[currentIndex].songName)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.red,
                    size: 25,
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    return const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 25,
                    );
                  } else {
                    return const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.red,
                      size: 25,
                    );
                  }
                }
              },
            ),
          )
        ],
        title: const Text(
          'NOW PLAYING',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      widget.songList[currentIndex].albumImage.toString(),
                    ),
                    fit: BoxFit.cover),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey,
                    Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.songList[currentIndex].songName.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  widget.songList[currentIndex].authorName.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.0,
                      color: Colors.grey),
                ),
                // Slider(
                //     min: 0,
                //     max: duration.inSeconds.toDouble(),
                //     value: position.inSeconds.toDouble(),
                //     onChanged: (value) async {
                //       final position = Duration(seconds: value.toInt());
                //       await audioPlayer.seek(position);
                //       audioPlayer.resume();
                //     }),

                FutureBuilder<void>(
                  future: Future.wait([
                    audioPlayer.getDuration(),
                    audioPlayer.getCurrentPosition()
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Once the duration is fetched, build the Slider widget
                      return Column(
                        children: [
                          Slider(
                            min: 0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds
                                .toDouble()
                                .clamp(0.0, duration.inMilliseconds.toDouble()),
                            onChanged: (value) async {
                              final position =
                                  Duration(milliseconds: value.toInt());
                              await audioPlayer.seek(position);
                              audioPlayer.resume();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formateTime(position)),
                                Text(formateTime(duration)),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                // Slider(
                //   min: 0,
                //   max: duration.inSeconds.toDouble(),
                //   value: position.inSeconds.toDouble(),
                //   onChanged: (value) async {
                //     final position = Duration(seconds: value.toInt());
                //     await audioPlayer.seek(position);
                //     audioPlayer.resume();
                //   },
                // ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(formateTime(position)),
                //       Text(formateTime(duration - position)),
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: playPrevious,
                      icon: Icon(Icons.skip_previous),
                    ),
                    const SizedBox(width: 20),
                    CircleAvatar(
                      radius: 35,
                      child: IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.resume();
                          }
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        iconSize: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: playNext,
                      icon: Icon(Icons.skip_next),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// String formateTime(Duration position) {
//   String twoDigits(int n) => n.toString().padLeft(2, '0');
//   final hours = twoDigits(position.inHours);
//   final min = twoDigits(position.inMinutes.remainder(60));
//   final sec = twoDigits(position.inSeconds.remainder(60));
//   return [if (position.inMilliseconds > 0) hours, min, sec].join(":");
// }

String formateTime(Duration position) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(position.inHours);
  final min = twoDigits(position.inMinutes.remainder(60));
  final sec = twoDigits(position.inSeconds.remainder(60));
  return '$hours:$min:$sec';
}
