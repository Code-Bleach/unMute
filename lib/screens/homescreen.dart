import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:unmute/screens/nowplaying.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  // playSong(String? uri) {
  //   try {
  //     _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
  //     _audioPlayer.play();
  //   } on Exception {
  //     log("Error parsing song");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " unMUTE 🎧",
          style: TextStyle(
              fontSize: 23,
              fontFamily: "Times New Roman",
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        elevation: 6.5,
        shadowColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            iconSize: 30,
            color: Colors.white60,
          )
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Music found! 🥺",
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  item.data![index].title,
                  style: const TextStyle(fontSize: 18.0),
                ),
                subtitle: Text(
                  item.data![index].artist ?? "Unknown",
                  style: const TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.more_horiz),
                leading: QueryArtworkWidget(
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const CircleAvatar(
                    child: Icon(Icons.music_note),
                  ),
                ),
                onTap: () {
                  // Navigator.pop(context)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (contex) => NowPlaying(
                        songModel: item.data![index],
                        audioPlayer: _audioPlayer,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
