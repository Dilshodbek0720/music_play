import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_play/utils/colors.dart';
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
      backgroundColor: const Color(0xFF384050),
      appBar: AppBar(
        title: const Text("Now Playing", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF384050).withOpacity(0.4),
        toolbarHeight: 65,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text("Liked Songs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.white),),
            Padding(padding: const EdgeInsets.all(26), child: ClipRRect(borderRadius: BorderRadius.circular(1),child: SizedBox(
                height: 330,
                width: 330,
                child: QueryArtworkWidget(id: song.id, type: ArtworkType.AUDIO,)),),),
            const SizedBox(height: 6,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<AudioBloc, AudioState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<AudioBloc, AudioState>(
                        builder: (context, state) {
                          if (state is AudioPlaying) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BlocBuilder<AudioBloc, AudioState>(
                                        builder: (context, state) {
                                          if (state is AudioPlaying) {
                                            return Text(formatSeconds(state.currentPosition), style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white
                                            ),);
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                      Text(formatSeconds(state.maxDuration), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white
                                      ),),
                                    ],
                                  ),
                                ),
                                Slider(
                                    value: state.currentPosition.toDouble(),
                                    max: state.maxDuration.toDouble(),
                                    onChanged: (value) {
                                      context
                                          .read<AudioBloc>()
                                          .add(SeekAudioPlaying(targetPosition: value.toInt()));
                                    },
                                  activeColor: const Color(0xFF3D5A80),
                                  inactiveColor: Colors.white,
                                    ),
                              ],
                            );
                          }
                          if (state is AudioPaused){
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BlocBuilder<AudioBloc, AudioState>(
                                        builder: (context, state) {
                                          if (state is AudioPaused) {
                                            return Text(formatSeconds(state.currentPosition), style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white
                                            ),);
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                      Text(formatSeconds(state.maxDuration), style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white
                                      ),),
                                    ],
                                  ),
                                ),
                                Slider(
                                    value: state.currentPosition.toDouble(),
                                    max: state.maxDuration.toDouble(),
                                    onChanged: (value) {
                                      context
                                          .read<AudioBloc>()
                                          .add(SeekAudioPause(targetPosition: value.toInt()));
                                    },
                                  activeColor: const Color(0xFF3D5A80),
                                  inactiveColor: Colors.white,
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(onPressed: (){ }, icon: Icon(Icons.skip_previous, color: Colors.white,size: 30,)),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal.withOpacity(0.5)
                            ),
                            child: IconButton(
                                onPressed: () {
                                  print(state);
                                  if (state is AudioInitial || state is AudioStopped) {
                                    context.read<AudioBloc>().add(StartedAudio(audioUrl: song.data));
                                    // context.read<AudioBloc>().add(
                                    //     const StartedAudio(audioUrl: 'musics/Uzmir-Onamni_asra_Robbim.mp3'));
                                  } else if (state is AudioPlaying) {
                                    context.read<AudioBloc>().add(PauseAudio());
                                  } else if (state is AudioPaused) {
                                    context.read<AudioBloc>().add(PlayAudio());
                                  }
                                },
                                icon: state is AudioPlaying
                                    ? const Icon(Icons.pause, color: Colors.white,size: 37,)
                                    : const Icon(Icons.play_arrow, color: Colors.white, size: 37,)),
                          ),
                          IconButton(onPressed: (){ }, icon: Icon(Icons.skip_next, color: Colors.white, size: 30,))
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}