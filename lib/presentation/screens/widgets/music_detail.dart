import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../blocs/bloc/audio_bloc.dart';
import '../music_screen.dart';

class MusicDetail extends StatelessWidget {
  const MusicDetail({
    super.key,
    required this.song,
  });
  final SongModel song;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: BlocBuilder<AudioBloc, AudioState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<AudioBloc, AudioState>(
                  builder: (context, state) {
                    if (state is AudioPlaying) {
                      return Column(
                        children: [
                          Slider(
                              value: state.currentPosition.toDouble(),
                              max: state.maxDuration.toDouble(),
                              onChanged: (value) {
                                context
                                    .read<AudioBloc>()
                                    .add(SeekAudio(targetPosition: value.toInt()));
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocBuilder<AudioBloc, AudioState>(
                                builder: (context, state) {
                                  if (state is AudioPlaying) {
                                    return Text(formatSeconds(state.currentPosition));
                                  }
                                  return const SizedBox();
                                },
                              ),
                              Text(formatSeconds(state.maxDuration)),
                            ],
                          )
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                IconButton(
                    onPressed: () {
                      print(state);
                      if (state is AudioInitial || state is AudioStopped) {
                        // context.read<AudioBloc>().add(
                        //     const StartedAudio(audioUrl: 'musics/Uzmir-Onamni_asra_Robbim.mp3'));
                      } else if (state is AudioPlaying) {
                        context.read<AudioBloc>().add(PauseAudio());
                      } else if (state is AudioPaused) {
                        context.read<AudioBloc>().add(PlayAudio());
                      }
                    },
                    icon: state is AudioPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow))
              ],
            );
          },
        )),
      ),
    );
  }
}