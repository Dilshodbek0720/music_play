import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../presentation/screens/music_screen.dart';
import '../presentation/screens/widgets/music_detail.dart';

class RouteNames {
  static const String songs = "/";
  static const String music = "/music";
}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.songs:
        return MaterialPageRoute(builder: (context) => const MusicsScreen());
      case RouteNames.music:
        return MaterialPageRoute(
            builder: (context) => MusicDetail(
                  song: settings.arguments as SongModel,
                ));

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("Route not found"),
            ),
          ),
        );
    }
  }
}
