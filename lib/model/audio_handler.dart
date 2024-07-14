import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:first_project/model/player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:first_project/model/track.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConcatenatingAudioSource _playlist;
  static const methodChannel =
      const MethodChannel('com.testing.qawl/audio_session');
  Track? _currentTrack;

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      androidCompactActionIndices: [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }

  // ValueNotifier to notify listeners about current track changes
  ValueNotifier<Track?> currentTrackNotifier = ValueNotifier<Track?>(null);

  void _updateNowPlayingInfo(Track track) {
    final _mediaItem = track.toMediaItem();
    // methodChannel.invokeMethod('updateNowPlayingInfo', {
    //   'id': mediaItem.id,
    //   'title': mediaItem.title,
    //   'artist': mediaItem.artist,
    //   'artUri': mediaItem.artUri.toString(),
    //   'duration': mediaItem.duration?.inSeconds,
    //   'position': _audioPlayer.position.inSeconds,
    // });
    mediaItem.add(_mediaItem);
    updateMediaItem(_mediaItem);
  }

  // MyAudioHandler() {
  //   _init();
  // }

  MyAudioHandler() {
    _init();
    AudioService.init(
      builder: () => this,
      config: const AudioServiceConfig(
        androidNotificationChannelName: 'Qawl Audio Playback',
        androidNotificationChannelDescription: 'Audio playback controls',
        androidNotificationIcon: 'drawable/ic_notification',
        androidShowNotificationBadge: true,
        notificationColor: Color(0xFF2196F3),
      ),
    );
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }
  void _listenForDurationChanges() {
    audioPlayer.durationStream.listen((duration) {
      final index = audioPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  void _init() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && _playlist.children.isNotEmpty) {
        final _mediaItem =
            (_playlist.children[index] as UriAudioSource).tag as MediaItem;
        final track = Track.fromMediaItem(_mediaItem);
        _currentTrack = track;
        currentTrackNotifier.value = track; // Notify listeners
        mediaItem.add(_mediaItem);
        _updateNowPlayingInfo(track);
      } else {
        _currentTrack = null;
        currentTrackNotifier.value = null; // Notify listeners
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
      }
    });

    _audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  @override
  void dispose() {
    currentTrackNotifier.dispose();
  }

  Future<void> updatePlaylist(List<Track> tracks) async {
    currentPlaylist = tracks;
    List<AudioSource> audioSources = tracks.map((track) {
      return AudioSource.uri(
        Uri.parse(track.audioPath),
        tag: MediaItem(
          id: track.id,
          title: track.trackName,
          artist: track.userId ?? '', // Replace with actual artist name
          artUri: Uri.parse(track.coverImagePath),
          extras: <String, dynamic>{
            'surah': track.surahNumber,
            'plays': track.plays,
            'audioPath': track.audioPath,
            'inPlaylists': track.inPlaylists,
          },
        ),
      );
    }).toList();
    _playlist = ConcatenatingAudioSource(children: audioSources);
    await _audioPlayer.setAudioSource(_playlist);
    queue.add(tracks.map((track) => track.toMediaItem()).toList());
    audioHandler
        .addQueueItems(tracks.map((track) => track.toMediaItem()).toList());
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  // Future<void> loadSingleTrack(Track track) async {
  //   final mediaItem = MediaItem(
  //     id: track.id,
  //     title: track.trackName,
  //     artist: track.userId ?? '',
  //     artUri: Uri.parse(track.coverImagePath),
  //     extras: <String, dynamic>{
  //       'surah': track.surahNumber,
  //       'plays': track.plays,
  //       'audioPath': track.audioPath,
  //       'inPlaylists': track.inPlaylists,
  //     },
  //   );

  //   final audioSource = AudioSource.uri(
  //     Uri.parse(track.audioPath),
  //     tag: mediaItem,
  //   );
  //   _currentTrack = track;
  //   await _audioPlayer.setAudioSource(audioSource);
  //   this.mediaItem.add(mediaItem);
  //   this.queue.add([mediaItem]);
  //   _updateNowPlayingInfo(track);
  // }

  @override
  Future<void> play() async {
    await _audioPlayer.play();
    if (_currentTrack != null) {
      _updateNowPlayingInfo(_currentTrack!);
      mediaItem.add(_currentTrack!.toMediaItem());
    }
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
    if (_currentTrack != null) {
      _updateNowPlayingInfo(_currentTrack!);
    }
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await super.stop();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    await _audioPlayer.seek(Duration.zero, index: index);
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) {
    _audioPlayer.setLoopMode(
      repeatMode == AudioServiceRepeatMode.one ? LoopMode.one : LoopMode.all,
    );
    return super.setRepeatMode(repeatMode);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) {
    _audioPlayer
        .setShuffleModeEnabled(shuffleMode == AudioServiceShuffleMode.all);
    return super.setShuffleMode(shuffleMode);
  }

  @override
  Future<void> setSpeed(double speed) => _audioPlayer.setSpeed(speed);

  bool get isLoaded => _audioPlayer.processingState == ProcessingState.ready;

  Future<void> playTrackWithPlaylist(
      Track selectedTrack, List<Track> playlist) async {
    // Find index of selected track in the playlist
    final index = playlist.indexWhere((track) => track.id == selectedTrack.id);
    if (index == -1) {
      // Selected track not found in playlist
      return;
    }

    // Add tracks to playlist audio source
    List<AudioSource> audioSources = playlist.map((track) {
      return AudioSource.uri(
        Uri.parse(track.audioPath),
        tag: MediaItem(
          id: track.id,
          title: track.trackName,
          artist: track.userId,
          artUri: Uri.parse(track.coverImagePath),
          extras: <String, dynamic>{
            'surah': track.surahNumber,
            'plays': track.plays,
            'audioPath': track.audioPath,
            'inPlaylists': track.inPlaylists,
          },
        ),
      );
    }).toList();
    _playlist = ConcatenatingAudioSource(children: audioSources);

    // Set playlist audio source for the audio player
    await _audioPlayer.setAudioSource(_playlist);

    // Set the initial queue with all tracks
    queue.add(playlist.map((track) => track.toMediaItem()).toList());

    // Play the selected track
    await _audioPlayer.seek(Duration.zero, index: index);
    await _audioPlayer.play();
  }

  Track? getPreviousTrack(List<Track> tracks) {
    final currentIndex = audioPlayer.currentIndex;
    if (currentIndex != null && currentIndex > 0) {
      return tracks[currentIndex - 1];
    }
    return null;
  }

  Track? getNextTrack(List<Track> tracks) {
    final currentIndex = audioPlayer.currentIndex;
    if (currentIndex != null && currentIndex < tracks.length - 1) {
      return tracks[currentIndex + 1];
    }
    return null;
  }
}
