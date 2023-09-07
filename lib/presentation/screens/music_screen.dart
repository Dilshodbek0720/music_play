import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../blocs/bloc/audio_bloc.dart';
import '../../blocs/cubit/audio_cubit.dart';
import '../../utils/colors.dart';
import '../../utils/routes.dart';
import '../../utils/style.dart';

class MusicsScreen extends StatelessWidget {
  const MusicsScreen({Key? key}) : super(key: key);

  // final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        centerTitle: true,
        backgroundColor: AppColors.cBADCEE,
        elevation: 0,
      ),
      backgroundColor: AppColors.cBADCEE,
      body: BlocBuilder<AudioCubit, AudioPlaylistState>(
        builder: (context, state) {
          if (state is AudioLoadSuccess) {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final song = state.songs[index];
                print(song.uri);
                return GestureDetector(
                  onTap: () {
                    context.read<AudioBloc>().add(StartedAudio(audioUrl: song.data));
                    context.read<AudioCubit>().currentSong = index;
                    Navigator.pushNamed(context, RouteNames.music, arguments: song);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF232323), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: QueryArtworkWidget(id: song.id, type: ArtworkType.AUDIO),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                style: AppStyle.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(song.artist ?? 'Unknown', style: AppStyle.bodySmall),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            formatSeconds((song.duration! / 3600).toInt()),
                            style: AppStyle.bodyMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: state.songs.length,
            );
          } else if (state is AudioLoadFailure) {
            return const Text('Something went error');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

String formatSeconds(int seconds) {
  if (seconds < 3600) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  } else {
    int hours = seconds ~/ 3600;
    int remainingMinutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
